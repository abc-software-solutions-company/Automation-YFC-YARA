import { Page, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";

export class GetHelpPage extends BasePage {
    constructor(page: Page) {
        super(page);
        this.switchToFrame("Get Help");
    }

    //#region Get Help specific methods
    async selectDropdown(label: string, optionName: string): Promise<void> {
        const container = this.loc.comboboxByLabel(label).first();
        await container.waitFor({ state: "visible", timeout: 30000 });
        await container.click();
        await this.page.waitForTimeout(2000);

        const opt = this.loc.optionByName(optionName).first();
        await opt.waitFor({ state: "visible", timeout: 30000 });
        await opt.click();
        await this.pageAlready();
    }

    async getTicketId(): Promise<string> {
        const locator = this.loc.paragraphText().filter({ hasText: /\d{4,}/ }).first();
        await locator.waitFor({ state: "visible", timeout: 30000 });
        const fullText = await locator.textContent();
        const ticketId = fullText?.replace(/[^\d]/g, "").trim() || "";
        return ticketId;
    }

    async verifyTicketId(ticketId: string): Promise<void> {
        const locator = this.loc.containsText(ticketId).first();
        await expect(locator).toBeVisible({ timeout: 30000 });
    }

    async uploadFile(filePath: string): Promise<void> {
        const input = this.loc.fileInput().first();
        await input.setInputFiles(filePath);
        await this.pageAlready();
    }

    async clickIconButton(name: string): Promise<void> {
        const iconMap: Record<string, string> = {
            "+": "lucide-plus",
            back: "lucide-arrow-left",
        };
        const iconClass = iconMap[name];
        if (iconClass) {
            const locator = this.loc.classNameContains(iconClass).first();
            await locator.waitFor({ state: "visible", timeout: 30000 });
            await locator.click();
            await this.pageAlready();
        } else {
            await this.clickOnBTNGeneral(name);
        }
    }
    //#endregion
}
