import { Page, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";

export class EditProfilePage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    location = this.page.locator('[data-testid="input-location"] input');
    selectCrops = this.page.locator(`[data-testid="selectCropsField"]`);
    categorisedContainer = this.page.locator('[data-testid="crops-inner-container-categorised"]');
    availableCrops = this.page.locator(".CategorisedCropList_cropCard__VWk6V:not(.CategorisedCropList_cropSelected__N1kpj)");
    selectedContainer = this.page.locator('[data-testid="crops-inner-container-selected"]');
    selectedCrops = this.page.locator(".CategorisedCropList_cropCard__VWk6V");
    dropdownTrigger = this.page.locator('xpath=//div[contains(@class,"CustomDropdown_dropdownToggle")]');

    async addLocation(state: string): Promise<void> {
        const label = "location";
        const listSelector = '[data-testid="locationList"]';

        const locator = this.loc.textbox(label);
        await locator.waitFor({ state: "visible" });
        await locator.click();
        await locator.fill("");
        await locator.pressSequentially(state, { delay: 100 });

        const list = this.page.locator(listSelector);
        await list.waitFor({ state: "visible" });

        const firstItem = list.locator(".hover").first();
        await firstItem.waitFor({ state: "visible" });
        await firstItem.click();

        await this.page.waitForTimeout(1000);
    }

    async selectFarmSizeUnit(unitName: string): Promise<void> {
        const trigger = this.dropdownTrigger.first();
        await trigger.click({ force: true });
        await this.page.waitForTimeout(1000);

        const option = this.page.locator(`xpath=//div[contains(@class,'FarmUnitList_farmUnitOption')][.//div[normalize-space(text())='${unitName}']]`);
        await option.click();

        await trigger.click().catch(() => {});
        await this.page.keyboard.press("Escape").catch(() => {});
        await this.page.waitForTimeout(500);
    }

    async editCropsSelection(saveButtonText: string): Promise<void> {
        await this.selectCrops.click();

        const count = await this.selectedCrops.count();
        if (count > 0) {
            const itemsToRemove = Math.min(count, 2);
            for (let i = 0; i < itemsToRemove; i++) {
                await this.selectedCrops.first().locator('[data-testid="CloseIcon"]').click();
                await this.page.waitForTimeout(400);
            }
        }

        const availableCount = await this.availableCrops.count();
        const itemsToSelect = Math.min(availableCount, 2);

        for (let i = 0; i < itemsToSelect; i++) {
            const item = this.availableCrops.nth(i);
            if (await item.isVisible()) {
                await item.scrollIntoViewIfNeeded();
                await item.click();
                await this.page.waitForTimeout(300);
            }
        }

        const saveBtn = this.page
            .locator('[data-testid="saveCrops"]')
            .or(this.page.locator(`button:has-text("${saveButtonText}")`))
            .first();

        await saveBtn.click();
    }
}
