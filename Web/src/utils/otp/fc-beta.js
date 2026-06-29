//node fc-beta

const crypto = require("crypto");
const { createHmac } = require("crypto");

const HMAC_SECRET = 'f5b122e5-1b7c-4dca-b323-cef4f6ebb0c4';
const ENV = { STAGE: 'stage', PREPROD: 'preprod', PROD: 'production' }; // Environment
const AS = { AZURE: 'azure', AUTH0: 'auth0' }; // Authorization Service
const VENDOR = { TWILIO: 'twilio', AWS_SNS: 'aws-sns', AFRICAS_TALKING: 'africas-talking', BIRD: 'bird' }; // Vendor

const CONFIG = {
  [ENV.STAGE]: {
    env: { [AS.AZURE]: 'integration', [AS.AUTH0]: 'stage' },
    baseUrl: {
      [AS.AZURE]: 'https://usermanagement-sms-integration.stage.apac.yaradigitallabs.io/api/v1',
      [AS.AUTH0]: 'https://usermanagement-sms.stage.apac.yaradigitallabs.io/api/v1',
    },
  },
  [ENV.PREPROD]: {
    env: { [AS.AZURE]: 'stage', [AS.AUTH0]: 'preprod' },
    baseUrl: {
      [AS.AZURE]: 'https://usermanagement-sms.stage.apac.yaradigitallabs.io/api/v1',
      [AS.AUTH0]: 'https://usermanagement-sms.preprod.apac.yaradigitallabs.io/api/v1',
    },
  },
  [ENV.PROD]: {
    env: { [AS.AZURE]: 'production', [AS.AUTH0]: 'production' },
    baseUrl: {
      [AS.AZURE]: 'https://usermanagement-sms.apac.yaradigitallabs.io/api/v1',
      [AS.AUTH0]: 'https://usermanagement-sms.apac.yaradigitallabs.io/api/v1',
    },
  },
};

const chalk = {
  green: (text) => `\x1b[32m${text}\x1b[0m`,
  yellow: (text) => `\x1b[33m${text}\x1b[0m`,
  cyan: (text) => `\x1b[36m${text}\x1b[0m`,
  red: (text) => `\x1b[31m${text}\x1b[0m`,
};

// Function to generate HMAC hash for authentication
const generateHMAC = (data, secret) => createHmac('sha256', secret).update(data).digest('hex');

// Function to format phone number by removing spaces
const formatPhoneNumber = (phoneNumber) => {
  return phoneNumber.replace(/\s+/g, '');
};

const getVendorByPhone = (phoneNumber) => {
  const formattedPhoneNumber = formatPhoneNumber(phoneNumber);
  if (formattedPhoneNumber.startsWith('+254')) return VENDOR.AFRICAS_TALKING;
  if (formattedPhoneNumber.startsWith('+255')) return VENDOR.AFRICAS_TALKING;
//   if (formattedPhoneNumber.startsWith('+91')) return VENDOR.AWS_SNS;
  if (formattedPhoneNumber.startsWith('+62')) return VENDOR.BIRD;
  return VENDOR.TWILIO;
};

// Function to fetch OTP message
const getOTPMessage = async (phoneNumber, environment, vendor, authService, isCached = false) => {
  const params = [phoneNumber, environment, vendor, authService];

  // HMAC is signed over the canonical body only. The backend ignores extra fields
  // (isCached) in the request body, but rejects them if included in the signed string.
  const body = JSON.stringify({ recipient: phoneNumber, environment: CONFIG[environment].env[authService], vendor });
  const headers = { 'Content-Type': 'application/json', Authorization: generateHMAC(body, HMAC_SECRET) };
  const url = `${CONFIG[environment].baseUrl[authService]}/readsms`;

  const response = await fetch(url, {
    method: 'POST',
    headers,
    body: JSON.stringify({ ...JSON.parse(body), isCached }),
  });

  return { params, response: await response.json() };
};

// Extract a 5-digit OTP from the response, or null if none found
const extractOTP = (response) => {
  const match = JSON.stringify(response).match(/(?<!\d)\d{5}(?!\d)/g);
  return match ? match[0] : null;
};

// Try live SMS first; if no OTP, retry the same call with isCached = true
const getOTPWithCacheFallback = async (phoneNumber, environment, vendor, authService) => {
  let result = await getOTPMessage(phoneNumber, environment, vendor, authService, false);
  if (!extractOTP(result.response)) {
    result = await getOTPMessage(phoneNumber, environment, vendor, authService, true);
  }
  return result;
};



const [, , phoneNumber, cacheArg] = process.argv;

if (!phoneNumber) {
    console.error("❌ Phone number is required");
    process.exit(1);
}

const formattedPhone = formatPhoneNumber(phoneNumber);
const vendor = getVendorByPhone(formattedPhone);
const authService = AS.AZURE;
const allowCache = cacheArg === 'cache';

// Tests only run against preprod
const environments = [ENV.PREPROD];

Promise.all(
  environments.map((env) =>
    allowCache
      ? getOTPWithCacheFallback(formattedPhone, env, vendor, authService)
      : getOTPMessage(formattedPhone, env, vendor, authService, false)
  )
).then((responses) => {
  responses.map(({ response }) => {
    const otp = extractOTP(response);
    if (otp) {
      console.info(chalk.green('✅ OTP found:'), chalk.yellow(otp));
    } else {
      console.info(chalk.red('❌ No OTP found for params:'), response.msg);
    }
  });
});