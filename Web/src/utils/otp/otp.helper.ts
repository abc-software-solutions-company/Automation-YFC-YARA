import { exec } from "child_process";
import { log } from "console";
import util from "util";

const execAsync = util.promisify(exec);

export async function getOTP(phoneNumber: string, allowCache = false): Promise<string> {
    const cacheArg = allowCache ? "cache" : "";
    const { stdout } = await execAsync(`node src/utils/otp/fc-beta.js ${phoneNumber} ${cacheArg}`.trim());
    const clean = stdout.replace(/\x1B\[[0-9;]*[mK]/g, "");
    const otps = clean.match(/\b\d{5,6}\b/g);
    if (!otps || otps.length === 0) {
        throw new Error("OTP not found in any environment");
    }
    return otps[otps.length - 1];
}

// Snapshot the currently stored OTP without throwing — used as a baseline before requesting a new one
export async function peekOTP(phoneNumber: string): Promise<string | null> {
    try {
        return await getOTP(phoneNumber);
    } catch {
        return null;
    }
}

// Poll until an OTP different from `previousOtp` appears (the freshly requested one, not a stale value)
export async function getFreshOTP(phoneNumber: string, previousOtp: string | null, retry = 6, delayMs = 5000): Promise<string> {
    for (let attempt = 1; attempt <= retry; attempt++) {
        const allowCache = attempt === retry;
        let otp: string | null = null;
        try {
            otp = await getOTP(phoneNumber, allowCache);
        } catch {
            otp = null;
        }
        if (otp && otp !== previousOtp) {
            return otp;
        }
        if (attempt < retry) {
            await new Promise((res) => setTimeout(res, delayMs));
        }
    }
    throw new Error("Fresh OTP not found (still matches previous OTP) after retry");
}

export async function getOTPWithRetry(phoneNumber: string, retry = 5, delayMs = 5000): Promise<string> {
    for (let attempt = 1; attempt <= retry; attempt++) {
        try {
            // Read the live OTP first; only fall back to the cached OTP on the final attempt
            const otp = await getOTP(phoneNumber, attempt === retry);
            return otp;
        } catch (error) {
            if (attempt === retry) throw error;
            await new Promise((res) => setTimeout(res, delayMs));
        }
    }

    throw new Error("OTP not found after retry");
}
