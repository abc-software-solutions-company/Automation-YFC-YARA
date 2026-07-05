import { Given, When, Then } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";
import { buildLocale, PAGE_ROUTES } from "../../support/config";

When("User clicks on {string} button in the {string} section", async function (this: CustomWorld, buttonName: string, productName: string) {
    await this.couponCartPage.clickAddToCartButton(productName);
});

Then("User ensures coupon is applied with code {string}, name {string}, discount {string} and coupon id {string}", async function (this: CustomWorld, code: string, name: string, discount: string, couponId: string) {
    const couponExists = await this.couponCartPage.isCouponCardVisible(code, name, discount);

    if (!couponExists) {
        const pagePath = PAGE_ROUTES.discounts;

        this.locale = buildLocale(this.country? this.country : '', this.language);
        await this.basePage.goto(`${this.config.baseUrl}/${this.locale}/${pagePath}`);

        await this.couponCartPage.clickElementByDataTestId(couponId);
        await this.couponCartPage.clickOnBTNGeneral("continue");
    }

    await this.couponHomePage.verifyCouponCard(code, name, discount);
});
