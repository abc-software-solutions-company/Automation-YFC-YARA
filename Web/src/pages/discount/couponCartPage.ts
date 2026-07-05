import { Page, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";

export class CouponCartPage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    async isCouponCardVisible(couponCode: string, couponName: string, discount: string): Promise<boolean> {
        const card = this.page
            .locator(`.CouponCard_CouponCardInnerVarient1`)
            .filter({ hasText: couponCode })
            .filter({ hasText: couponName })
            .filter({ hasText: discount })
            .filter({ hasText: /Remove/i });

        return await card.isVisible().catch(() => false);
    }

    async clickAddToCartButton(productName: string): Promise<void> {

    const productCard = this.page
        .locator('[class*="ProductCard_card"]')
        .filter({
            has: this.page.getByText(productName, { exact: true }),
        });

    await productCard.waitFor({ state: "visible" });
    await productCard.locator(`[data-testid="addToCartBtn"]`).click();
}
}
