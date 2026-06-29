import { Given, When, Then, DataTable } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";

When("User adds products to cart:", async function (this: CustomWorld, table) {
    const rows = table.hashes();
    for (const row of rows) {
        await this.shopDetailPage.addProductToCart(row.Product, row.Quantity);
    }
});

Then("User verifies cart summary", async function (this: CustomWorld) {
    await this.cartPage.verifyCartSummary();
});

Then("User ensures discount state is {string}", async function (this: CustomWorld, state: string) {
    await this.cartPage.ensureDiscountState(state);
});
