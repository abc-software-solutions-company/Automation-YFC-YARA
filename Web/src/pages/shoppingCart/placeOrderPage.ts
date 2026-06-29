import { Page, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";

export class PlaceOrderPage extends BasePage {
    orderNumberPattern = /\d{3}-\d{8}-\d{4}/;
    orderNumberElement = this.page.locator("div", {
        hasText: /\d{3}-\d{8}-\d{4}/,
    });

    constructor(page: Page) {
        super(page);
    }

    /** After placing an order the URL is `/orders/<oId>?...`. Returns oId, throws if missing. */
    async waitForOrderSuccessAndExtractId(): Promise<string> {
        await this.page.waitForURL(/\/orders\/.+/);
        const oId = new URL(this.page.url()).searchParams.get("oId");
        if (!oId) throw new Error(`Order success URL missing oId query param: ${this.page.url()}`);
        return oId;
    }

    async extractOrderNumberFromURL(): Promise<string> {
        const url = this.page.url();
        const match = url.match(/\/orders\/([^?]+)/);
        if (!match) throw new Error("Order number not found in URL");
        return match[1];
    }

    async extractOrderNumber(): Promise<string> {
        await this.orderNumberElement.waitFor({ state: "visible" });
        const text = await this.orderNumberElement.textContent();
        const match = text?.match(this.orderNumberPattern);
        if (!match) throw new Error("Order number not found");
        return match[0];
    }

    async verifyOrderNumberVisible(orderNumber: string): Promise<void> {
        await expect(this.page.getByText(orderNumber)).toBeVisible();
    }
}
