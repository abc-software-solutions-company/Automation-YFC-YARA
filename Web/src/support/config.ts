import dotenv from "dotenv";
import { expect as baseExpect } from "@playwright/test";

export const expect = baseExpect.configure({ timeout: 30000 });

dotenv.config();

export const config = {
    baseUrl: process.env.BASE_URL!,
} as const;

export enum LanguageCode {
    EN = "en",
    TH = "th",
    VI = "vi",
    HI = "hi",
    MR = "mr",
    TE = "te",
    PA = "pa",
    BN = "bn",
    GU = "gu",
    KN = "kn",
    TA = "ta",
    ID = "id",
    SW = "sw",
    MS = "ms",
}

export const LANGUAGE_LABEL: Record<LanguageCode, string> = {
    [LanguageCode.EN]: "English",
    [LanguageCode.TH]: "Thai",
    [LanguageCode.VI]: "Vietnamese",
    [LanguageCode.HI]: "Hindi",
    [LanguageCode.ID]: "Indonesian",
    [LanguageCode.SW]: "Swahili",
    [LanguageCode.MR]: "Marathi",
    [LanguageCode.TE]: "Telugu",
    [LanguageCode.PA]: "Punjabi",
    [LanguageCode.BN]: "Bengali",
    [LanguageCode.GU]: "Gujarati",
    [LanguageCode.KN]: "Kannada",
    [LanguageCode.TA]: "Tamil",
    [LanguageCode.MS]: "Bahasa Melayu",
};
export function getLanguageLabel(code: LanguageCode): string {
    return LANGUAGE_LABEL[code];
}

export const LANGUAGE_ALIAS: Record<string, LanguageCode> = {
    english: LanguageCode.EN,
    en: LanguageCode.EN,

    thai: LanguageCode.TH,
    th: LanguageCode.TH,

    vietnamese: LanguageCode.VI,
    vi: LanguageCode.VI,

    hindi: LanguageCode.HI,
    hi: LanguageCode.HI,

    marathi: LanguageCode.MR,
    mr: LanguageCode.MR,

    telugu: LanguageCode.TE,
    te: LanguageCode.TE,

    punjabi: LanguageCode.PA,
    pa: LanguageCode.PA,

    bengali: LanguageCode.BN,
    bn: LanguageCode.BN,

    gujarati: LanguageCode.GU,
    gu: LanguageCode.GU,

    kannada: LanguageCode.KN,
    kn: LanguageCode.KN,

    tamil: LanguageCode.TA,
    ta: LanguageCode.TA,

    indonesian: LanguageCode.ID,
    id: LanguageCode.ID,

    swahili: LanguageCode.SW,
    sw: LanguageCode.SW,

    bahasa: LanguageCode.MS,
    ms: LanguageCode.MS,
};

export interface OnboardingFixture {
    labels: {
        name: string;
        address: string;
        farmSize: string;
        continueBtn: string;
        finishBtn: string;
        successBtn: string;
    };
    defaults: {
        address: string;
        farmSize: string;
    };
}

export interface CountryConfig {
    countryCode: string;
    defaultLanguage: LanguageCode;
    supportedLanguages: LanguageCode[];
    hasLanguageSelector: boolean;
    phone: string;
    dialCode: string;
    onboarding?: OnboardingFixture;
}

export const COUNTRY_CONFIG: Record<string, CountryConfig> = {
    Thailand: {
        countryCode: "th",
        defaultLanguage: LanguageCode.TH,
        supportedLanguages: [LanguageCode.TH, LanguageCode.EN],
        hasLanguageSelector: false,
        phone: "3335445440",
        dialCode: "+91",
        onboarding: {
            labels: {
                name: "Auto TH",
                address: "Bangkok",
                farmSize: "3",
                continueBtn: "ดำเนินการต่อ",
                finishBtn: "",
                successBtn: "",
            },
            defaults: {
                address: "Bangkok",
                farmSize: "1",
            },
        },
    },
    VietNam: {
        countryCode: "vn",
        defaultLanguage: LanguageCode.EN,
        supportedLanguages: [LanguageCode.VI, LanguageCode.EN],
        hasLanguageSelector: true,
        phone: "3335445432",
        dialCode: "+91",
    },
    India: {
        countryCode: "in",
        defaultLanguage: LanguageCode.EN,
        supportedLanguages: [LanguageCode.EN, LanguageCode.HI, LanguageCode.MR, LanguageCode.TE, LanguageCode.PA, LanguageCode.BN, LanguageCode.GU, LanguageCode.KN, LanguageCode.TA],
        hasLanguageSelector: true,
        phone: "3335445444",
        dialCode: "+91",
    },
    Indonesia: {
        countryCode: "id",
        defaultLanguage: LanguageCode.EN,
        supportedLanguages: [LanguageCode.EN, LanguageCode.ID],
        hasLanguageSelector: false,
        phone: "82222222222",
        dialCode: "+62",
        onboarding: {
            labels: {
                name: "Nama lengkap",
                address: "Alamat",
                farmSize: "Masukkan ukuran kebun",
                continueBtn: "Lanjutkan",
                finishBtn: "Selesai",
                successBtn: "Jelajahi YaraFarmcare",
            },
            defaults: {
                // Only certain regions supported by autocomplete ("Hanya wilayah tertentu").
                // Plain "Jakarta" returns 0 results. Must be a more specific district name —
                // "Jakarta Pusat" matches (verified shop AUTOMATION FC SHOP serves this area).
                address: "Jakarta Pusat",
                farmSize: "1",
            },
        },
    },
    Kenya: {
        countryCode: "ke",
        defaultLanguage: LanguageCode.EN,
        supportedLanguages: [LanguageCode.EN],
        hasLanguageSelector: false,
        phone: "3335445445",
        dialCode: "+91",
    },
    Tanzania: {
        countryCode: "tz",
        defaultLanguage: LanguageCode.EN,
        supportedLanguages: [LanguageCode.EN, LanguageCode.SW],
        hasLanguageSelector: true,
        phone: "123456789",
        dialCode: "+255",
    },
    Malaysia: {
        countryCode: "my",
        defaultLanguage: LanguageCode.EN,
        supportedLanguages: [LanguageCode.EN, LanguageCode.MS],
        hasLanguageSelector: true,
        phone: "1233458890",
        dialCode: "+91",
    },
};

export function resolveLanguage(input: string | undefined, config: CountryConfig): LanguageCode {
    if (!input) return config.defaultLanguage;

    const mapped = LANGUAGE_ALIAS[input.toLowerCase().trim()];

    if (!mapped || !config.supportedLanguages.includes(mapped)) {
        console.warn(`Language "${input}" invalid for ${config.countryCode}, using default`);
        return config.defaultLanguage;
    }

    return mapped;
}

export const PAGE_ROUTES: Record<string, string> = {
    Home: "home",
    "My orders": "profile/myorders?status=Pending",
    "privacy-and-legal": "profile/privacy-and-legal",
};

export function buildLocale(country: string, language?: string): string {
    const config = COUNTRY_CONFIG[country];

    if (!config) {
        throw new Error(`Country not supported: ${country}`);
    }

    const langCode = resolveLanguage(language, config);

    return `${langCode}-${config.countryCode}`;
}

// ===== Admin / loyalty test fixtures =====

export const PHONE_TO_LOYALTY_ID: Record<string, string> = {
    "+62811000001": "bb3932b5-340f-41b0-8623-69c4ddb3bf08",
    "811000001": "bb3932b5-340f-41b0-8623-69c4ddb3bf08",
    "+62811000010": "ff55dbec-b67b-4b60-995b-7a3e25f81d10",
    "811000010": "ff55dbec-b67b-4b60-995b-7a3e25f81d10",
};

/**
 * Generate a random Indonesia test phone in the format `81100XXXXX` (10 digits).
 * Range: 811_00_00000 → 811_00_99999 (100,000 unique phones).
 * Preprod backend OTP accepts any phone in this test range.
 * Each phone can only earn 1 first-time reward (claim form one-time).
 */
export function generateRandomPhoneIndonesia(): string {
    const suffix = String(Math.floor(Math.random() * 100000)).padStart(5, "0");
    return `81100${suffix}`;
}

/**
 * Generate a random Thailand test phone in the format `21100XXXXX` (10 digits).
 * Mirrors the Indonesia pattern (`81100XXXXX`) — same 5-digit random tail, different prefix.
 * TH preprod uses dial code `+91` (not real `+66`), so full E.164 example: `+9121100XXXXX`.
 */
export function generateRandomPhoneThailand(): string {
    const suffix = String(Math.floor(Math.random() * 100000)).padStart(5, "0");
    return `21100${suffix}`;
}

export const REWARD_CATALOG: Record<string, string> = {
    "T - shirt (AUTO)": "26a61e67-15d3-4445-b715-7dda8e95cb2d",
    "T-shirt (Auto)": "880a1cd6-3245-4589-ae14-409f8b5e36d5",
};

export const COUPON_CATALOG: Record<string, string> = {
    // Coupon name → discount-strategy id from admin BFF (preprod).
    // "ID" = Indonesia, "TH" = Thailand (matches ADMIN_TOKEN_ID / ADMIN_TOKEN_TH).
    // Verified live 2026-07-01: earlier ids were deleted on preprod; these are the current ones.
    "Discount AUTO ID": "bb90e7bc-c5d3-44a6-ab45-32e198ed1c04",
    "Discount AUTO TH": "40be05e4-93c5-48da-98ff-b5c519155e68",
};

export const ADMIN_CAMPAIGN_DEFAULT_IMAGE = "temp_upload/1777172494239-campaign-ind.jpeg";

import path from "path";
export const SAMPLE_KTP_PATH = path.resolve(process.cwd(), "src/data/campaign/ktp.jpg");

export function resolveLoyaltyId(phone: string): string {
    const id = PHONE_TO_LOYALTY_ID[phone] ?? PHONE_TO_LOYALTY_ID[phone.replace(/^\+62/, "")];
    if (!id) throw new Error(`No loyalty_id mapping for phone "${phone}". Add to PHONE_TO_LOYALTY_ID in config.ts.`);
    return id;
}

export function resolveRewardId(rewardKey: string): string {
    const id = REWARD_CATALOG[rewardKey];
    if (!id) throw new Error(`Unknown reward "${rewardKey}". Add to REWARD_CATALOG in config.ts.`);
    return id;
}

export function resolveCouponId(couponKey: string): string {
    const id = COUPON_CATALOG[couponKey];
    if (!id) throw new Error(`Unknown coupon "${couponKey}". Add to COUPON_CATALOG in config.ts.`);
    return id;
}
