import { Given, When, Then } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";
import { buildLocale, PAGE_ROUTES } from "../../support/config";

When("User clicks on {string} button in the {string} section", async function (this: CustomWorld, buttonName: string, productName: string) {
    await this.couponCartPage.clickAddToCartButton(productName);
});

Then("User ensures coupon is applied with code {string}, name {string} and discount {string}", 
    async function (this: CustomWorld, code: string, name: string, discount: string) {
    const pagePath = PAGE_ROUTES.discounts;

    await this.basePage.goto(`${this.config.baseUrl}/${this.locale}/${pagePath}`);
    await this.couponCartPage.applyCouponIfNeeded(code);
    await this.couponHomePage.verifyCouponCard(code, name, discount);
  }
);