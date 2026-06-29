import { Page, Locator, expect } from "@playwright/test";

export class ProfilePage {
    private page: Page;

    constructor(page: Page) {
        this.page = page;
    }
    //locator
    accountOption = (text: string) =>
        this.page.locator(".listLabel.normal").filter({
            hasText: text,
        });

    languageItem = (text: string) => this.page.locator(`//p[normalize-space()="${text}" and following-sibling::div//input[@type="radio"]]`);

    async verifyAccountOptions(expectedOptions: string[]) {
        for (const option of expectedOptions) {
            const locator = this.accountOption(option.trim());
            await expect(locator).toBeVisible();
        }
    }

    async verifyLanguageOptions(expected: string[]) {
        for (const lang of expected) {
            const locator = this.languageItem(lang.trim());
            await expect(locator).toBeVisible();
        }
    }

    async selectLanguage(language: string): Promise<void> {
        const locator = this.languageItem(language);

        await locator.waitFor({ state: "visible" });
        await locator.click();
    }
}
