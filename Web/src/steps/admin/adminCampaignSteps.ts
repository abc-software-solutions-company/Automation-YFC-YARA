import { Given, When, Then, After } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";
import { RewardKind } from "../../api/loyaltyAdmin/campaignFactory";
import {
    createCampaignForFarmer,
    verifyAdminCampaignVisible,
    clickAdminCampaign,
    stopAdminCampaignIfAny,
} from "./adminCampaignFlow";

Given(
    "Admin creates a {string} campaign for user {string} with {string}",
    async function (this: CustomWorld, kind: string, phone: string, item: string) {
        await createCampaignForFarmer(this, phone, kind as RewardKind, item);
    },
);

// Backward-compat alias for older feature scenarios that say "reward campaign with reward X" —
// implies kind="physical reward".
Given(
    "Admin creates a reward campaign for user {string} with reward {string}",
    async function (this: CustomWorld, phone: string, rewardKey: string) {
        await createCampaignForFarmer(this, phone, "physical reward", rewardKey);
    },
);

// Operator override variant — pass "containsAll" to require every SKU in the variant list to
// appear in the qualifying order, or "containsAny" to mirror default behavior.
Given(
    "Admin creates a reward campaign for user {string} with reward {string} with SKU operator {string}",
    async function (this: CustomWorld, phone: string, rewardKey: string, operator: string) {
        if (operator !== "containsAny" && operator !== "containsAll") {
            throw new Error(`Invalid SKU operator "${operator}". Expected "containsAny" or "containsAll".`);
        }
        await createCampaignForFarmer(this, phone, "physical reward", rewardKey, undefined, operator);
    },
);

Then("User verifies the admin campaign is visible", async function (this: CustomWorld) {
    await verifyAdminCampaignVisible(this);
});

When("User clicks on the admin campaign", async function (this: CustomWorld) {
    await clickAdminCampaign(this);
});

After(async function (this: CustomWorld) {
    await stopAdminCampaignIfAny(this);
});
