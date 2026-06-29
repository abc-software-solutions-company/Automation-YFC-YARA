import { Given, When, Then, DataTable } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";

When("User change {string} location", async function (this: CustomWorld, text: string) {
    await this.editProfilePage.addLocation(text);
});

When("User select {string} option in the {string} dropdown", async function (this: CustomWorld, option: string, dropdownName: string) {
    await this.editProfilePage.selectFarmSizeUnit(option);
});

When("User clicks on the {string} dropdown", async function (this: CustomWorld, text: string) {
    await this.editProfilePage.editCropsSelection(text);
});
