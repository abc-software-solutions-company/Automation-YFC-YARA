import { When, Then } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";

When("User clicks on the {string} search result", async function (this: CustomWorld, productName: string) {
    await this.searchPage.clickSearchResult(productName);
});
