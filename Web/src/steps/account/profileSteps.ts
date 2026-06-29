import { When, Then } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";

Then("I verify account options for {string}", async function (this: CustomWorld, optionList: string) {
    const options = optionList.split(",").map((opt) => opt.trim());
    await this.profilePage.verifyAccountOptions(options);
});

Then("User verify language list including {string}", async function (this: CustomWorld, optionList: string) {
    const options = optionList.split(",").map((opt) => opt.trim());
    await this.profilePage.verifyLanguageOptions(options);
});

When("User select language {string}", async function (language: string) {
    await this.profilePage.selectLanguage(language);
});
