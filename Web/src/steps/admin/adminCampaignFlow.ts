// World-aware orchestration for admin campaign steps. Reads/writes scenario state on the
// CustomWorld; calls into the pure factory for HTTP work. Imported by adminCampaignSteps.ts.

import { CustomWorld } from "../../support/world";
import { loyaltyAdminClientFor } from "../../api/loyaltyAdmin/loyaltyAdminClient";
import { adminCountryFor } from "../../api/loyaltyAdmin/config";
import { buildFarmerCampaign, RewardKind, SALES_TRACKER } from "../../api/loyaltyAdmin/campaignFactory";
import { resolveLoyaltyId } from "../../support/config";
import { extractLoyaltyIdFromSession } from "../../utils/auth/loyaltyHelper";

function resolvePhone(world: CustomWorld, raw: string): string {
    if (raw !== "random") return raw;
    const picked = (world as unknown as { phone?: string }).phone;
    if (!picked) throw new Error('Admin step received "random" but no phone was picked by a prior login step.');
    return picked;
}

async function resolveLoyaltyIdForPhone(world: CustomWorld, phone: string): Promise<string> {
    try {
        return await extractLoyaltyIdFromSession(world.page);
    } catch {
        return resolveLoyaltyId(phone);
    }
}

export async function createCampaignForFarmer(
    world: CustomWorld,
    rawPhone: string,
    kind: RewardKind,
    item: string,
    trackerType: string = SALES_TRACKER,
    lineitemsOperator?: "containsAny" | "containsAll",
): Promise<void> {
    const phone = resolvePhone(world, rawPhone);
    const loyaltyId = await resolveLoyaltyIdForPhone(world, phone);
    const api = loyaltyAdminClientFor(adminCountryFor(world));
    const { id, name, trackerName } = await buildFarmerCampaign(api, { phone, loyaltyId, kind, item, trackerType, lineitemsOperator });
    world.adminCampaignId = id;
    world.adminCampaignName = name;
    world.loyaltyId = loyaltyId;
    console.log(`✓ Created admin campaign ${id} (${name}) — tracker="${trackerName}", item="${item}", operator="${lineitemsOperator ?? api.spec.lineitemsOperator}"`);
}

export async function verifyAdminCampaignVisible(world: CustomWorld): Promise<void> {
    if (!world.adminCampaignName) throw new Error("No adminCampaignName in world. Run admin create step first.");
    await world.basePage.verifyText(world.adminCampaignName, "visible");
}

export async function clickAdminCampaign(world: CustomWorld): Promise<void> {
    if (!world.adminCampaignName) throw new Error("No adminCampaignName in world. Run admin create step first.");
    await world.basePage.clickOnSection(world.adminCampaignName);
}

export async function stopAdminCampaignIfAny(world: CustomWorld): Promise<void> {
    if (!world.adminCampaignId) return;
    try {
        const api = loyaltyAdminClientFor(adminCountryFor(world));
        await api.stopCampaign(world.adminCampaignId);
        console.log(`✓ Stopped admin campaign ${world.adminCampaignId}`);
    } catch (e) {
        console.warn(`⚠ Failed to stop campaign ${world.adminCampaignId}: ${(e as Error).message.split("\n")[0]}`);
    }
}
