// Types for the loyalty admin BFF (campaigns, milestones, trackers, rewards).

export type PlatformType = "YC" | "YFC";
export type CampaignType = "Milestone";
export type OutcomeType = "AWARD_REWARD" | "AWARD_COUPON";

export interface LocalizedString {
    lang: string;
    value: string;
}

export interface CampaignMeta {
    campaign_type: CampaignType;
    platform_type: PlatformType;
    start_date: string;
    end_date: string;
    loyalty_campaign_meta: {
        name: string;
        name_localized: LocalizedString[];
        description: string;
        description_localized: LocalizedString[];
        image_url: string;
        image_url_localized: LocalizedString[];
        tnc: string;
        tnc_localized: LocalizedString[];
    };
}

export interface MilestoneCondition {
    tracker_id: string;
    min_tracker_value: number;
}

export interface MilestoneOutcome {
    id: string;
    type: OutcomeType;
    expiry_strategy_id?: string;
}

export interface Tracker {
    id: string;
    name: string;
    [key: string]: unknown;
}

