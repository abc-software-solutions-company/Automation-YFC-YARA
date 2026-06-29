import { Page, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";

export class HomePage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    //#region Locators
    shop = (shopName: string) => this.page.locator('[class*="shopCard_cardInfo"]').filter({ hasText: shopName }).first();
    sectionHeading = (sectionName: string) => this.page.locator('[class*="section-heading"]').filter({ hasText: sectionName });
    //#endregion

    async selectShop(name: string): Promise<void> {
        await this.pageAlready();
        let locator = this.shop(name);
        await locator.waitFor({ state: "visible" });
        await locator.click();
        await this.pageAlready();
    }

    async clickButtonInSection(buttonName: string, sectionName: string): Promise<void> {
        const resolvedSection = this.resolve(sectionName);
        const resolvedButton = this.resolve(buttonName);
        const button = this.sectionHeading(resolvedSection).getByText(resolvedButton, { exact: true });
        await button.waitFor({ state: "visible" });
        await button.click();
        await this.pageAlready();
    }
}
