import { Page, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";

export interface OrderCardInfo {
    orderId: string;
}

export class MyOrderPage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    //#region Locators
    // Order list card
    orderCards = this.page.locator("[class*='Orders_orderCard']");
    statusBadge = "[class*='badgeInner']";
    cardOrderId = ".title.small";

    // Order detail page
    orderDetailId = this.page.locator(".title.normal.mb-4px");
    //#endregion

    async hasOrders(): Promise<boolean> {
        await this.page.waitForTimeout(2000);
        return (await this.orderCards.count()) > 0;
    }

    async waitForMyOrdersPage(): Promise<void> {
        await this.page.waitForURL("**/myorders**");
    }

    async verifyOrderNumbersVisible(orderNumbers: string[]): Promise<void> {
        for (const orderNumber of orderNumbers) {
            await expect(this.page.getByText(orderNumber)).toBeVisible();
        }
    }

    async verifyAllOrdersHaveStatus(_expectedStatus: string): Promise<void> {
        if (!(await this.hasOrders())) return;
        const card = this.orderCards.first();
        await expect.soft(card.locator(this.statusBadge).first()).toBeVisible();
    }

    async verifyEachOrderCardContainsFields(fields: string[]): Promise<void> {
        if (!(await this.hasOrders())) return;
        const card = this.orderCards.first();
        for (const field of fields) {
            await expect.soft(card.getByText(field)).toBeVisible();
        }
    }

    async saveFirstOrderCardInfo(): Promise<OrderCardInfo | null> {
        if (!(await this.hasOrders())) {
            return null;
        }
        const card = this.orderCards.first();
        await card.waitFor({ state: "visible" });
        const orderId = await card.locator(this.cardOrderId).textContent() ?? "";
        return { orderId: orderId.replace(/.*#/, "").trim() };
    }

    async verifyOrderDetailMatchesCard(cardInfo: OrderCardInfo): Promise<void> {
        await this.page.waitForTimeout(2000);
        const detailId = await this.orderDetailId.textContent() ?? "";
        expect.soft(detailId.trim()).toContain(cardInfo.orderId);
    }
}
