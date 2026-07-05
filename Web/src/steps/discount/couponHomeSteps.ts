import { Then, DataTable } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";

Then("User verifies coupon card with code {string}, name {string} and discount {string}", async function (this: CustomWorld, code: string, name: string, discount: string) {
    await this.couponHomePage.verifyCouponCard(code, name, discount);
});
