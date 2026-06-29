import { Given, When, Then, DataTable } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";
import { Utils } from "../../utils/common/commonUtils";

When("User clicks on the {string} country", async function (this: CustomWorld, itemName: string) {
    await this.localePage.clickOnCountry(itemName);
});

Then("User verify the list of countries:", async function (this: CustomWorld, table: DataTable) {
    const rows = table.hashes() as { Country: string }[];
    for (const { Country } of rows) {
        await this.localePage.expectCountryVisible(Country);
    }
});

Then("User selects the {string} language", async function (this: CustomWorld, language: string) {
    await this.localePage.clickOnLanguage(language);
});

Then("User verify the languages {string}", async function (this: CustomWorld, languages: string) {
    const languageList = Utils.splitString(languages);
    for (const language of languageList) {
        await this.localePage.expectLanguageVisible(language);
    }
});

When("User selects on the {string} country and select English", async function (this: CustomWorld, countryName: string) {
    await this.localePage.clickOnCountry(countryName);
    //  if has the language page
    await this.loginPage.handleLanguageIfDisplayed();
    await this.page.waitForTimeout(3000);
    if (this.loginPage.locale) this.setLocale(this.loginPage.locale);
});
