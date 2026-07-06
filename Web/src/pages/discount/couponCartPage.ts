import { Page, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";

export class CouponCartPage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    async applyCouponIfNeeded(couponCode: string): Promise<void> {
    const card = this.page
        .locator('[class*="CouponCard_CouponCardInnerVarient1"]')
        .filter({ hasText: couponCode })
        .first();

    await card.waitFor({ state: "visible" });

    if (await card.getByRole("button", { name: this.resolve("Remove") }).isVisible().catch(() => false)) {
        await this.page.goBack();
        return;
    }

    await card.getByRole("button", { name: this.resolve("Apply") }).click();
    await this.clickOnBTNGeneral("continue");
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
