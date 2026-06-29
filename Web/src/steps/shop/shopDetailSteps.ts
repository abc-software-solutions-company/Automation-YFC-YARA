import { Given, When, Then, DataTable } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";
import { Utils } from "../../utils/common/commonUtils";

When("User selects the {string} product", async function (this: CustomWorld, product: string) {
    await this.shopDetailPage.selectProduct(product);
});
