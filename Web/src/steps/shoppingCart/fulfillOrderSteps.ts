import { When } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";
import { fulfillB2cOrderAsRetailer } from "../../api/marketplace/b2cFulfillOrder";

When("Retailer {string} fulfills the placed order", async function (this: CustomWorld, retailerPhone: string) {
    if (!this.orderId) {
        throw new Error("orderId not set in world. Run 'User should be redirected to order success page' first.");
    }
    await fulfillB2cOrderAsRetailer({ orderId: this.orderId, retailerPhone, country: this.country });
    console.log(`✓ Retailer ${retailerPhone} fulfilled order ${this.orderId}`);
});
