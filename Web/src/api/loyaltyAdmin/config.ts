import { PlatformType } from "./types";

export type AdminCountry = "indonesia" | "thailand";

export interface AdminCountrySpec {
    countryHeader: string;
    tenantId: string;
    createPlatform: PlatformType;
    updatePlatform: PlatformType;
    metaLangs: readonly string[];
    trackerLangs: readonly string[];
    lineitemsOperator: "containsAny" | "containsAll";
    lineitemMinAmount?: number;
    productVariantIds: readonly string[];
    productFamilyIds: readonly string[];
    defaultImageUrl: string;
    tokenEnv: string;
}

export const ADMIN_BFF_BASE = "https://sh-yaraconnect-admin-bff-service.preprod.apac.yaradigitallabs.io";

export const ADMIN_COUNTRY_SPEC: Record<AdminCountry, AdminCountrySpec> = {
    indonesia: {
        countryHeader: "indonesia",
        tenantId: "4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed",
        createPlatform: "YFC",
        updatePlatform: "YFC",
        metaLangs: ["en_ID", "id"],
        trackerLangs: ["en_ID", "id"],
        lineitemsOperator: "containsAny",
        lineitemMinAmount: 999,
        productVariantIds: ["b8df490a-15cb-4141-8047-12bb7fc16f3d", "97d6f928-7736-4055-8eaf-27c979bfb002"],
        productFamilyIds: ["69ee0a82bbc6b7f44a3ef143"],
        defaultImageUrl: "temp_upload/1777172494239-campaign-ind.jpeg",
        tokenEnv: "ADMIN_TOKEN_ID",
    },
    thailand: {
        countryHeader: "thailand",
        tenantId: "32c89363-b532-468a-8828-d2a72038c7c1",
        createPlatform: "YC",
        updatePlatform: "YFC",
        metaLangs: ["en", "th"],
        trackerLangs: ["en", "th"],
        lineitemsOperator: "containsAny",
        productVariantIds: ["9921de89-db6b-497e-9f0a-617ccd551509", "0ba122fa-2226-4b5c-8675-ba8ff57d554a"],
        productFamilyIds: ["6401a53e92f2c963f02bc1f4"],
        defaultImageUrl: "temp_upload/1778288135998-post-album-uncut.png",
        tokenEnv: "ADMIN_TOKEN_TH",
    },
};

export function getAdminCountrySpec(country: AdminCountry): AdminCountrySpec {
    const spec = ADMIN_COUNTRY_SPEC[country];
    if (!spec) throw new Error(`Unsupported admin country "${country}". Add an entry to ADMIN_COUNTRY_SPEC.`);
    return spec;
}

export function adminCountryFor(world: { country?: string }): AdminCountry {
    return world.country?.toLowerCase() === "thailand" ? "thailand" : "indonesia";
}
