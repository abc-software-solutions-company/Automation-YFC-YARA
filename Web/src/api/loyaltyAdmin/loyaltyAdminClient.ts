import { CampaignMeta, MilestoneCondition, MilestoneOutcome, PlatformType, Tracker } from "./types";
import { CreateDiscountCouponOptions, buildDiscountCouponBody } from "./discountClient";
import { RejectReasonCode, SubmissionDetail } from "./submissionClient";
import { ADMIN_BFF_BASE, AdminCountry, AdminCountrySpec, getAdminCountrySpec } from "./config";

export class LoyaltyAdminClient {
    public readonly spec: AdminCountrySpec;

    constructor(
        private token: string,
        public readonly country: AdminCountry,
    ) {
        const spec = getAdminCountrySpec(country);
        if (!token) throw new Error(`LoyaltyAdminClient: token required (set ${spec.tokenEnv} in .env)`);
        this.spec = spec;
    }

    private headers(): Record<string, string> {
        return {
            Accept: "application/json",
            "Content-Type": "application/json",
            Authorization: `Bearer ${this.token}`,
            "x-app-platform": "web",
            "x-country-code": this.spec.countryHeader,
            "x-tenant-id": this.spec.tenantId,
        };
    }

    async request<T>(method: string, path: string, body?: unknown): Promise<T> {
        const url = `${ADMIN_BFF_BASE}${path}`;
        const res = await fetch(url, {
            method,
            headers: this.headers(),
            body: body !== undefined ? JSON.stringify(body) : undefined,
        });
        const text = await res.text();
        if (!res.ok) {
            throw new Error(`LoyaltyAdminClient ${method} ${path} → HTTP ${res.status}\n${text}`);
        }
        if (!text) return undefined as T;
        const parsed = JSON.parse(text);
        return (parsed && typeof parsed === "object" && "data" in parsed ? parsed.data : parsed) as T;
    }

    async createCampaign(meta: CampaignMeta): Promise<{ id: string }> {
        return this.request("POST", "/admin/loyalty/loyalty-campaigns", meta);
    }

    async setPlatformAndEligibility(campaignId: string, platform: PlatformType = this.spec.updatePlatform, eligibility: { location_level_1: string[] } = { location_level_1: [] }): Promise<void> {
        await this.request("PUT", `/admin/loyalty/loyalty-campaigns/${campaignId}`, {
            platform_type: platform,
            loyalty_campaign_eligibility: eligibility,
        });
    }

    async createMilestone(campaignId: string, name: string): Promise<{ id: string }> {
        return this.request("POST", `/admin/loyalty/loyalty-campaigns/${campaignId}/milestones`, {
            name,
            milestone_conditions: [],
        });
    }

    async setMilestoneOutcome(campaignId: string, milestoneId: string, outcome: MilestoneOutcome, extras?: Record<string, unknown>): Promise<void> {
        await this.request("PUT", `/admin/loyalty/loyalty-campaigns/${campaignId}/milestones/${milestoneId}`, {
            outcome,
            ...(extras ?? {}),
        });
    }

    async setMilestoneConditions(campaignId: string, milestoneId: string, conditions: MilestoneCondition[]): Promise<void> {
        await this.request("PUT", `/admin/loyalty/loyalty-campaigns/${campaignId}/milestones/${milestoneId}`, {
            milestone_conditions: conditions,
        });
    }

    async publishCampaign(campaignId: string): Promise<void> {
        await this.request("PUT", `/admin/loyalty/loyalty-campaigns/${campaignId}/publish`, {});
    }

    async stopCampaign(campaignId: string): Promise<void> {
        await this.request("PUT", `/admin/loyalty/loyalty-campaigns/${campaignId}/stop`, {});
    }

    async deleteCampaign(campaignId: string): Promise<void> {
        await this.request("PUT", `/admin/loyalty/loyalty-campaigns/${campaignId}/delete`, {});
    }

    // ---- Tracker create ----

    async createTracker(
        campaignId: string,
        opts: { name: string; loyaltyId?: string; trackerValue?: number; customEventName?: string; lineitemsOperator?: "containsAny" | "containsAll" },
    ): Promise<{ id: string }> {
        const isCustomEvent = !!opts.customEventName;
        const conditions: unknown[] = [];

        if (isCustomEvent) {
            if (opts.loyaltyId) {
                conditions.push({ fact: "loyalty_id", operator: "equal", value: opts.loyaltyId, metadata: { order: "1", type: "configure_trigger" } });
            }
            conditions.push({ fact: "custom_event_name", operator: "equal", value: opts.customEventName, metadata: { order: opts.loyaltyId ? 2 : 1, type: "event_dropdown" } });
        } else {
            conditions.push({ fact: "transaction_type", operator: "equal", value: "b2c", metadata: { order: "1" } });
            if (opts.loyaltyId) {
                conditions.push({ fact: "loyalty_id", operator: "equal", value: opts.loyaltyId, metadata: { order: "2", type: "configure_trigger" } });
            }
            const lineitemsValue: unknown[] = [
                { key: "internal_variant_id", operator: "in", value: this.spec.productVariantIds },
                { key: "product_family_id", operator: "in", value: this.spec.productFamilyIds },
            ];
            if (this.spec.lineitemMinAmount !== undefined) {
                lineitemsValue.push({ key: "lineitem_amount", operator: "greaterThan", value: this.spec.lineitemMinAmount, metadata: { order: "2" } });
            }
            conditions.push({
                fact: "lineitems",
                operator: opts.lineitemsOperator ?? this.spec.lineitemsOperator,
                value: lineitemsValue,
                metadata: { order: opts.loyaltyId ? "3" : "2" },
            });
        }

        const body = {
            tracker_name: opts.name,
            tracker_name_localized: this.spec.trackerLangs.map((lang) => ({ lang, value: opts.name })),
            campaign_type: "Milestone",
            tracker_based_on: isCustomEvent ? "CUSTOM_EVENT" : "SALES_PURCHASE",
            tracker_entity: "",
            conditions,
            outcome: { tracker_type: "FIXED", tracker_value: opts.trackerValue ?? 1 },
            max_activity_per_user_per_period: null,
        };
        return this.request("POST", `/admin/loyalty/loyalty-campaigns/${campaignId}/trackers`, body);
    }

    // ---- Discovery ----

    async listTrackers(campaignId: string): Promise<Tracker[]> {
        return this.request("GET", `/admin/loyalty/loyalty-campaigns/${campaignId}/trackers`);
    }

    async getCampaign(campaignId: string): Promise<Record<string, unknown>> {
        return this.request("GET", `/admin/loyalty/loyalty-campaigns/${campaignId}`);
    }

    // ---- Discount / coupon strategies ----

    async createDiscountCoupon(opts: CreateDiscountCouponOptions): Promise<{ id: string; raw: unknown }> {
        const body = buildDiscountCouponBody(opts);
        const raw = await this.request<Record<string, unknown>>("POST", "/admin/discounts/create", body);
        const id = (raw?.id as string | undefined) ?? (raw?.discountId as string | undefined) ?? (raw?.strategyId as string | undefined);
        if (!id) throw new Error(`createDiscountCoupon: cannot locate id in response. Raw: ${JSON.stringify(raw)}`);
        return { id, raw };
    }

    async editDiscountCoupon(discountId: string, fullBody: Record<string, unknown>): Promise<void> {
        await this.request("PATCH", `/admin/discounts/${discountId}`, { ...fullBody, discountId });
    }

    // ---- Farmer document submission (KTP review) ----

    async approveSubmission(submissionId: string): Promise<void> {
        await this.request("PATCH", `/admin/farmer-document-submission/${submissionId}/approve`, {});
    }

    async rejectSubmission(submissionId: string, reasonCode: RejectReasonCode = "unclear_wrong_id_document"): Promise<void> {
        await this.request("PATCH", `/admin/farmer-document-submission/${submissionId}/reject`, {
            remark_category_code: reasonCode,
        });
    }

    async getSubmission(submissionId: string): Promise<SubmissionDetail> {
        return this.request("GET", `/admin/farmer-document-submission/${submissionId}?returnPresignedUrl=true`);
    }
}

export function loyaltyAdminClientFor(country: AdminCountry): LoyaltyAdminClient {
    const spec = getAdminCountrySpec(country);
    const token = process.env[spec.tokenEnv];
    if (!token) {
        throw new Error(`${spec.tokenEnv} not set in .env. Copy from ${country} admin UI Network tab → Authorization header (without 'Bearer ').`);
    }
    return new LoyaltyAdminClient(token, country);
}
