import { Then } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";

Then("User should be redirected to order success page", async function (this: CustomWorld) {
    this.orderId = await this.placeOrderPage.waitForOrderSuccessAndExtractId();
});

Then("Order number should be displayed on success page", async function (this: CustomWorld) {
    const orderNumber = await this.placeOrderPage.extractOrderNumberFromURL();
    await this.placeOrderPage.verifyOrderNumberVisible(orderNumber);
    this.orderNumbers.push(orderNumber);
});
