import { Given, When, Then, DataTable } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";
import { Utils } from "../../utils/common/commonUtils";

When("User selects the {string} shop", async function (this: CustomWorld, shop: string) {
    await this.homePage.selectShop(shop);
});

When("User clicks on {string} in the {string} section", async function (this: CustomWorld, buttonName: string, sectionName: string) {
    await this.homePage.clickButtonInSection(buttonName, sectionName);
});
