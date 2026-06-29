import { Page, Locator, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";
import { Utils } from "../../utils/common/commonUtils";

export type DiscountState = "NONE" | "AVAILABLE" | "APPLIED";

export class CartPage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    //#region Locators
    // Cart items
    cartItems = this.page.locator('div.flex-center.flex-gap.box:has([data-testid="itemQuantity"])');
    private sellingPrice = (item: Locator) => item.locator('[class*="sellingPrice"]');
    private mrpPrice = (item: Locator) => item.locator('[class*="mrp"]');
    private itemQuantity = (item: Locator) => item.getByTestId("itemQuantity");

    // Summary
    summaryRows = this.page.locator('[class*="CartSummary_summaryItem"]');

    // Coupon
    couponSection = this.page.locator("div.flex-center:has(> svg[data-testid='SellOutlinedIcon']):has(.listLabel)");
    couponCard = this.page.locator("div:has(svg[data-testid='CloseIcon'])");
    couponCodeLabel = this.couponCard.locator("h3.label.small");
    couponHintAvailable = this.page.locator('[class*="ApplyCoupon_errorContainer"]');

    // Coupon list page
    validCoupons = this.page
        .locator(".couponListContainer > div")
        .filter({ hasNot: this.page.locator("svg[data-testid='CloseIcon']") })
        .filter({ hasNot: this.page.locator(".label.sx") });
    couponApplyBtn = (coupon: Locator) => coupon.locator("button[data-testid]");
    couponRemoveBtn = this.page.locator(".couponListContainer button:has(svg[data-testid='CloseIcon'])");
    submitBtn = this.page.locator('[data-tesid="submit"]');
    //#endregion

    async getSummaryValues(): Promise<number[]> {
        const count = await this.summaryRows.count();
        const values: number[] = [];

        for (let i = 0; i < count; i++) {
            const text = await this.summaryRows.nth(i).locator("p").nth(1).textContent();
            values.push(Utils.parseCurrency(text ?? ""));
        }

        return values;
    }

    async calculateProductsSubtotal(): Promise<number> {
        const count = await this.cartItems.count();
        let subtotal = 0;

        for (let i = 0; i < count; i++) {
            const item = this.cartItems.nth(i);
            const priceText = await this.sellingPrice(item).textContent();
            const qtyText = await this.itemQuantity(item).textContent();

            subtotal += Utils.parseCurrency(priceText ?? "") * Number(qtyText ?? "0");
        }

        return subtotal;
    }

    async calculateOriginalSubtotal(): Promise<number> {
        const count = await this.cartItems.count();
        let subtotal = 0;

        for (let i = 0; i < count; i++) {
            const item = this.cartItems.nth(i);
            const mrp = this.mrpPrice(item);
            const hasMrp = await mrp.isVisible().catch(() => false);
            const priceText = hasMrp ? await mrp.textContent() : await this.sellingPrice(item).textContent();
            const qtyText = await this.itemQuantity(item).textContent();

            subtotal += Utils.parseCurrency(priceText ?? "") * Number(qtyText ?? "0");
        }

        return subtotal;
    }

    async verifyCartSummary() {
        await this.summaryRows.first().waitFor({ state: "visible", timeout: 30000 });

        const sellingSubtotal = await this.calculateProductsSubtotal();
        const originalSubtotal = await this.calculateOriginalSubtotal();
        const summaryValues = await this.getSummaryValues();

        if (summaryValues.length === 2) {
            const [displayedSubtotal, displayedTotal] = summaryValues;

            expect(displayedSubtotal).toBe(sellingSubtotal);
            expect(displayedTotal).toBe(sellingSubtotal);
            return;
        }

        if (summaryValues.length === 3) {
            const [displayedSubtotal, displayedDiscount, displayedTotal] = summaryValues;

            expect(displayedSubtotal).toBe(originalSubtotal);
            expect(displayedSubtotal - displayedDiscount).toBe(displayedTotal);
            expect(displayedDiscount).toBeGreaterThan(0);
            return;
        }

        throw new Error("Unexpected summary row count");
    }

    async isCouponAvailableHintVisible(): Promise<boolean> {
        return await this.couponHintAvailable.isVisible().catch(() => false);
    }

    async verifyCouponAvailableHintVisible(): Promise<void> {
        await expect(this.couponHintAvailable).toBeVisible();
    }

    async isCouponApplied(): Promise<boolean> {
        return await this.couponCard.isVisible().catch(() => false);
    }

    async verifyCouponApplied(expectedCode?: string): Promise<void> {
        await expect(this.couponCard).toBeVisible();

        if (expectedCode) {
            await expect(this.couponCodeLabel).toHaveText(expectedCode);
        }
    }

    private async getDiscountState(): Promise<DiscountState> {
        const summaryValues = await this.getSummaryValues();
        if (summaryValues.length === 3) {
            return "APPLIED";
        }
        if (await this.couponHintAvailable.isVisible().catch(() => false)) {
            return "AVAILABLE";
        }

        return "NONE";
    }

    async ensureDiscountState(expected: string): Promise<void> {
        await this.page.waitForTimeout(3000);
        const current = await this.getDiscountState();

        if (current === expected) return;

        switch (expected) {
            case "NONE":
                if (current === "APPLIED") {
                    await this.openCouponSection();
                    await this.removeAppliedCoupon();
                }
                await this.page.goBack();
                await this.page.waitForTimeout(3000);
                const afterRemove = await this.getDiscountState();
                if (afterRemove == "APPLIED") {
                    throw new Error(`Expected NONE but got ${afterRemove}`);
                }
                return;

            case "AVAILABLE":
                if (current === "APPLIED") {
                    await this.openCouponSection();
                    await this.removeAppliedCoupon();
                }
                await this.page.goBack();

                await this.page.waitForURL(/\/cart$/);
                await this.page.waitForTimeout(3000);
                const stateAfterRemove = await this.getDiscountState();

                if (stateAfterRemove !== "AVAILABLE") {
                    throw new Error(`Coupon not available. Current state: ${stateAfterRemove}`);
                }

                return;

            case "APPLIED":
                if (current === "APPLIED") {
                    await this.openCouponSection();
                    await this.removeAppliedCoupon();
                }

                await this.applyFirstAvailableCoupon();
                await this.page.goBack();
                await this.page.waitForURL(/\/cart$/);
                await this.page.waitForTimeout(3000);
                const finalState = await this.getDiscountState();
                if (finalState !== "APPLIED") {
                    throw new Error("Failed to apply coupon");
                }

                return;
        }
    }

    private async openCouponSection(): Promise<void> {
        await this.couponSection.click({ force: true });

        await this.page.waitForTimeout(3000);

        await this.pageAlready();
    }

    private async applyFirstAvailableCoupon(): Promise<void> {
        const firstCoupon = this.validCoupons.first();
        const applyBtn = this.couponApplyBtn(firstCoupon);

        await applyBtn.waitFor({ state: "visible" });
        await applyBtn.click();
        await this.page.waitForTimeout(3000);
    }

    private async removeAppliedCoupon(): Promise<void> {
        await this.couponRemoveBtn.waitFor({ state: "visible" });
        await this.couponRemoveBtn.click();
        await this.page.waitForTimeout(3000);
        await this.submitBtn.click();
        await this.page.waitForTimeout(3000);
    }
}
