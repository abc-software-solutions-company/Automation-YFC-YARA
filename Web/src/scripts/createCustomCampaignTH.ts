// One-off: create 1 TH campaign with CUSTOM_EVENT tracker as DRAFT.
// Usage:
//   ADMIN_TOKEN_TH="<token>" npx ts-node src/scripts/createCustomCampaignTH.ts

import { LoyaltyAdminClient } from "../api/loyaltyAdmin/loyaltyAdminClient";
import { buildAndPublishCampaign } from "../api/loyaltyAdmin/buildCampaign";
import { resolveRewardId } from "../support/config";

async function main() {
    const token = process.env.ADMIN_TOKEN_TH;
    if (!token) throw new Error("ADMIN_TOKEN_TH not set");

    const api = new LoyaltyAdminClient(token, "thailand");

    const now = new Date();
    const pad = (n: number) => String(n).padStart(2, "0");
    const stamp = `${pad(now.getDate())}/${pad(now.getMonth() + 1)}/${now.getFullYear()} ${pad(now.getHours())}:${pad(now.getMinutes())}`;
    const startDate = now.toISOString();
    const endDate = "2027-12-01T23:59:59.999Z";

    const rewardId = resolveRewardId("T-shirt (Auto)");
    const customEventName = "a_Field_Mapping";
    const name = `AUTO draft TH Custom ${stamp}`;

    const id = await buildAndPublishCampaign(api, {
        name,
        startDate,
        endDate,
        minTrackerValue: 2,
        rewardId,
        customEventName,
        trackerName: name,
        skipPublish: true,
    });
    console.log(`OK [custom-event:${customEventName}] ${name} -> id=${id}`);
}

main().catch((err) => {
    console.error(err);
    process.exit(1);
});
