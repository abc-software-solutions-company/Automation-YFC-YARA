import { LoyaltyAdminClient } from "./loyaltyAdminClient";
import { CampaignMeta, PlatformType } from "./types";

export interface BuildCampaignOptions {
    name: string;
    description?: string;
    tnc?: string;
    startDate: string;
    endDate: string;
    imageUrl?: string;
    rewardId?: string;
    couponId?: string;
    loyaltyId?: string;
    minTrackerValue: number;
    createPlatform?: PlatformType;
    updatePlatform?: PlatformType;
    customEventName?: string;
    trackerName?: string;
    skipPublish?: boolean;
    lineitemsOperator?: "containsAny" | "containsAll";
}

function localizedFor(langs: readonly string[], value: string) {
    return langs.map((lang) => ({ lang, value }));
}

export async function buildAndPublishCampaign(api: LoyaltyAdminClient, opts: BuildCampaignOptions): Promise<string> {
    const description = opts.description ?? opts.name;
    const tnc = opts.tnc ?? "<p>TnC automation</p>";
    const createPlatform = opts.createPlatform ?? api.spec.createPlatform;
    const updatePlatform = opts.updatePlatform ?? api.spec.updatePlatform;
    const imageUrl = opts.imageUrl ?? api.spec.defaultImageUrl;
    const metaLangs = api.spec.metaLangs;

    const meta: CampaignMeta = {
        campaign_type: "Milestone",
        platform_type: createPlatform,
        start_date: opts.startDate,
        end_date: opts.endDate,
        loyalty_campaign_meta: {
            name: opts.name,
            name_localized: localizedFor(metaLangs, opts.name),
            description: `<p>${description}</p>`,
            description_localized: localizedFor(metaLangs, `<p>${description}</p>`),
            image_url: imageUrl,
            image_url_localized: localizedFor(metaLangs, imageUrl),
            tnc,
            tnc_localized: localizedFor(metaLangs, tnc),
        },
    };

    const created = await api.createCampaign(meta);
    await api.setPlatformAndEligibility(created.id, updatePlatform);

    const milestone = await api.createMilestone(created.id, "Milestone Level 1");
    const tracker = await api.createTracker(created.id, {
        name: opts.trackerName ?? opts.name,
        loyaltyId: opts.loyaltyId,
        trackerValue: 1,
        customEventName: opts.customEventName,
        lineitemsOperator: opts.lineitemsOperator,
    });
    if (!opts.rewardId === !opts.couponId) {
        throw new Error("buildAndPublishCampaign: provide exactly one of rewardId or couponId");
    }
    const outcomeId = (opts.rewardId ?? opts.couponId)!;
    const outcomeType = opts.rewardId ? "AWARD_REWARD" : "AWARD_COUPON";
    await api.setMilestoneOutcome(created.id, milestone.id, {
        id: outcomeId,
        type: outcomeType,
        expiry_strategy_id: "",
    });
    await api.setMilestoneConditions(created.id, milestone.id, [{ tracker_id: tracker.id, min_tracker_value: opts.minTrackerValue }]);

    if (!opts.skipPublish) {
        await api.publishCampaign(created.id);
    }

    return created.id;
}
