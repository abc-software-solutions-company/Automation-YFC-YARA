import { Page, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";

export class CouponHomePage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    couponCard(couponCode: string) {
        return this.page.locator(`.CouponCard_CouponCardInnerVarient1__xL8QV:has-text("${couponCode}")`);
    }

    async verifyCouponCard(couponCode: string, couponName: string, discount: string): Promise<void> {
        const card = this.couponCard(couponCode);
        await expect(card).toBeVisible();
        await expect(card).toContainText(discount);
        await expect(card).toContainText(couponCode);
        await expect(card).toContainText(couponName);
    }
}
