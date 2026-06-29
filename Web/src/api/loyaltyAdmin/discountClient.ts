// Types + body builders for the admin BFF discount/coupon strategy endpoints.
// HTTP methods live on LoyaltyAdminClient (createDiscountCoupon, editDiscountCoupon).

export interface CreateDiscountCouponOptions {
    name: string;
    couponCode: string;
    discountValue?: { value: number; type: "Fixed" | "Percent" };
    maxDiscount?: { value: number; currency: string };
    minCartOrderValue?: { value: number; currency: string };
    numberOfCoupons?: number;
    maxUsePerUser?: number;
    startDate?: string;
    endDate?: string;
}

export function buildDiscountCouponBody(opts: CreateDiscountCouponOptions): Record<string, unknown> {
    return {
        discountTag: "autocampaigncoupon",
        areOptionalConditionsEnabled: false,
        areCustomisedProductConditions: false,
        // Indonesia preprod tenant–specific UUIDs (categoryId / discount-level-id).
        discountAppliedFor: "2b263df6-1ce4-4b8f-b0f8-dbcaf13841f3",
        discountLevels: "82bdb97f-480a-48c7-9ea0-13a37f5be38c",
        level1Locations: [],
        messageLocalised: { en_ID: opts.name, id: opts.name },
        name: opts.name,
        nameLocalised: { en_ID: opts.name, id: opts.name },
        orderLevel: {
            discountValueAndType: opts.discountValue ?? { value: 10, type: "Fixed" },
            maximumDiscountValueAndCurrency: opts.maxDiscount ?? { value: 100, currency: "IDR" },
            minimumCartOrderValue: opts.minCartOrderValue ?? { value: 1000, currency: "IDR" },
            minimumOrderQty: { value: 1, unit: "KG_OR_L" },
        },
        startDate: opts.startDate ?? "2026-04-29T13:00:00.000+07:00",
        endDate: opts.endDate ?? "2029-05-31T12:00:00.000+07:00",
        products: [],
        maxUsePerUser: opts.maxUsePerUser ?? 1,
        termsAndConditionsLocalised: { en_ID: "", id: "" },
        couponType: "unique",
        couponCode: opts.couponCode,
        images: ["temp_upload/1777366474381-campaignind.jpeg"],
        numberOfCoupons: opts.numberOfCoupons ?? 10000,
        buUserId: "8c461ef7-b503-4fa0-9f32-7cdefaab2cac",
        membership: [],
        segmentIds: [],
        platform: "farmcare",
        isEligibleForLoyaltyCampaign: true,
    };
}

export const DISCOUNT_AUTO_BASE_BODY: Record<string, unknown> = {
    discountTag: "autocampaigncoupon",
    areOptionalConditionsEnabled: false,
    areCustomisedProductConditions: false,
    discountAppliedFor: "2b263df6-1ce4-4b8f-b0f8-dbcaf13841f3",
    discountLevels: "82bdb97f-480a-48c7-9ea0-13a37f5be38c",
    level1Locations: [],
    messageLocalised: { en_ID: "Auto campaign Td", id: "Auto campaign " },
    name: "AUTO CAMG COUPON 1 (10000users)",
    nameLocalised: { en_ID: "AUTO CAMG COUPON 1 (10000users)", id: "AUTO CAMG COUPON (10000user)" },
    orderLevel: {
        discountValueAndType: { value: 10, type: "Fixed" },
        maximumDiscountValueAndCurrency: { value: 100, currency: "IDR" },
        minimumCartOrderValue: { value: 1000, currency: "IDR" },
        minimumOrderQty: { value: 1, unit: "KG_OR_L" },
    },
    products: [],
    maxUsePerUser: 1000,
    termsAndConditionsLocalised: { en_ID: "", id: "" },
    couponType: "unique",
    couponCode: "AUTOCAM1",
    images: [""],
    numberOfCoupons: 10,
    buUserId: "8c461ef7-b503-4fa0-9f32-7cdefaab2cac",
    membership: [],
    segmentIds: [],
    platform: "farmcare",
    isEligibleForLoyaltyCampaign: true,
};
