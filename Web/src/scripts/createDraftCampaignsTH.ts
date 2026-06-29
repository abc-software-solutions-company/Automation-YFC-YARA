// One-off: create 4 TH campaigns (mix 2 coupon + 2 reward) as DRAFT (skipPublish).
// Usage:
//   ADMIN_TOKEN_TH="<token>" npx ts-node src/scripts/createDraftCampaignsTH.ts

import { LoyaltyAdminClient } from "../api/loyaltyAdmin/loyaltyAdminClient";
import { buildAndPublishCampaign } from "../api/loyaltyAdmin/buildCampaign";
import { resolveCouponId, resolveRewardId } from "../support/config";

async function main() {
    const token = process.env.ADMIN_TOKEN_TH;
    if (!token) throw new Error("ADMIN_TOKEN_TH not set");

    const api = new LoyaltyAdminClient(token, "thailand");

    const now = new Date();
    const pad = (n: number) => String(n).padStart(2, "0");
    const stamp = `${pad(now.getDate())}/${pad(now.getMonth() + 1)}/${now.getFullYear()} ${pad(now.getHours())}:${pad(now.getMinutes())}`;
    const startDate = now.toISOString();
    const endDate = "2027-12-01T23:59:59.999Z";

    const couponId = resolveCouponId("Discount AUTO TH");
    const rewardId = resolveRewardId("T-shirt (Auto)");

    const plan: Array<{ kind: "coupon" | "reward"; outcomeId: string }> = [
        { kind: "coupon", outcomeId: couponId },
        { kind: "coupon", outcomeId: couponId },
        { kind: "reward", outcomeId: rewardId },
        { kind: "reward", outcomeId: rewardId },
    ];

    for (let i = 0; i < plan.length; i++) {
        const slot = plan[i];
        const name = `AUTO draft TH ${stamp} #${i + 1}`;
        const id = await buildAndPublishCampaign(api, {
            name,
            startDate,
            endDate,
            minTrackerValue: 2,
            ...(slot.kind === "coupon" ? { couponId: slot.outcomeId } : { rewardId: slot.outcomeId }),
            skipPublish: true,
            trackerName: name,
        });
        console.log(`OK [${slot.kind}] ${name} -> id=${id}`);
    }
}

main().catch((err) => {
    console.error(err);
    process.exit(1);
});
