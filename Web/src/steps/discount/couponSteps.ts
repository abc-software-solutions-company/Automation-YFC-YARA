import { Then, When } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";

Then ("User applies coupon {string} if it is not already applied", async function (this: CustomWorld, code: string) {
    await this.couponPage.applyCouponIfNeeded(code);
});
     
When("User clicks on the {string} button for product {string}", async function (this: CustomWorld, productName: string) {
    await this.couponPage.clickAddToCartButton(productName);
});
