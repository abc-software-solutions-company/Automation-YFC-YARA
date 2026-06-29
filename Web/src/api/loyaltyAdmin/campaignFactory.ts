// High-level factory for test admin campaigns. Pure functions: no world / no side effects
// beyond HTTP. Naming format: `AUTO {kind} DD/MM/YYYY hh:mm (phone)`.

import { LoyaltyAdminClient } from "./loyaltyAdminClient";
import { buildAndPublishCampaign, BuildCampaignOptions } from "./buildCampaign";
import { resolveRewardId, resolveCouponId } from "../../support/config";

export type RewardKind = "physical reward" | "reward coupon";
export const SALES_TRACKER = "Product sales";
export const DEFAULT_MIN_TRACKER_VALUE = 2;
export const DEFAULT_CAMPAIGN_END_DATE = "2027-12-01T23:59:59.999Z";

function pad2(n: number): string {
    return String(n).padStart(2, "0");
}

export function formatCampaignName(kind: RewardKind, phone: string, now: Date = new Date()): string {
    return `AUTO ${kind} ${pad2(now.getDate())}/${pad2(now.getMonth() + 1)}/${now.getFullYear()} ${pad2(now.getHours())}:${pad2(now.getMinutes())} (${phone})`;
}

export function formatTrackerName(trackerType: string, goal: number, kind: RewardKind): string {
    return `${trackerType} - ${goal} - ${kind}`;
}

export function resolveOutcome(kind: RewardKind, item: string): Pick<BuildCampaignOptions, "rewardId" | "couponId"> {
    switch (kind) {
        case "physical reward":
            return { rewardId: resolveRewardId(item) };
        case "reward coupon":
            return { couponId: resolveCouponId(item) };
        default:
            throw new Error(`Unsupported reward kind: "${kind}". Expected one of: physical reward, reward coupon.`);
    }
}

export interface BuildFarmerCampaignOptions {
    phone: string;
    loyaltyId: string;
    kind: RewardKind;
    item: string;
    trackerType?: string;
    minTrackerValue?: number;
    lineitemsOperator?: "containsAny" | "containsAll";
}

export interface BuiltCampaign {
    id: string;
    name: string;
    trackerName: string;
}

export async function buildFarmerCampaign(api: LoyaltyAdminClient, opts: BuildFarmerCampaignOptions): Promise<BuiltCampaign> {
    const trackerType = opts.trackerType ?? SALES_TRACKER;
    const minTrackerValue = opts.minTrackerValue ?? DEFAULT_MIN_TRACKER_VALUE;
    const isSales = trackerType === SALES_TRACKER || trackerType.toLowerCase() === "sales";
    const customEventName = isSales ? undefined : trackerType;
    const trackerLabel = isSales ? SALES_TRACKER : trackerType;

    const name = formatCampaignName(opts.kind, opts.phone);
    const trackerName = formatTrackerName(trackerLabel, minTrackerValue, opts.kind);

    const id = await buildAndPublishCampaign(api, {
        name,
        startDate: new Date().toISOString(),
        endDate: DEFAULT_CAMPAIGN_END_DATE,
        ...resolveOutcome(opts.kind, opts.item),
        loyaltyId: opts.loyaltyId,
        minTrackerValue,
        customEventName,
        trackerName,
        lineitemsOperator: opts.lineitemsOperator,
    });
    return { id, name, trackerName };
}
