import { Page, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";

export class LocalePage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    //#region Dynamic XPath locators
    country = (name: string) => this.page.locator(`xpath=//div[contains(normalize-space(.),"${name}")]/span`);
    language = (name: string) => this.page.locator(`xpath=//div[@data-testid="language-item"]/div[contains(normalize-space(.),"${name}")]`).first();

    //#endregion

    //#region Button
    async clickOnCountry(name: string): Promise<void> {
        let loc = this.country(name);
        await loc.waitFor({ state: "visible" });
        await loc.click();
        await this.pageAlready();
    }

    async clickOnLanguage(name: string): Promise<void> {
        let loc = this.language(name);
        await loc.waitFor({ state: "visible" });
        await loc.click();
        await this.pageAlready();
    }
    //#endregion

    async expectCountryVisible(name: string): Promise<void> {
        await this.pageAlready();
        await expect(this.country(name)).toBeVisible();
    }

    async expectLanguageVisible(name: string): Promise<void> {
        await this.pageAlready();
        await expect(this.language(name)).toBeVisible();
    }
}
