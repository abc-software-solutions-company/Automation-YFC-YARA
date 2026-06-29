import { Given, When, Then, DataTable } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";
import { buildLocale, PAGE_ROUTES, generateRandomPhoneIndonesia } from "../../support/config";
import { Utils } from "../../utils/common/commonUtils";

When("User enters {string} into the {string} field", async function (this: CustomWorld, value: string, fieldName: string) {
    await this.basePage.fillInGeneralInputField(fieldName, value);
});

When("User enters {string} into the {string} field exactly", async function (this: CustomWorld, value: string, fieldName: string) {
    await this.basePage.fillInExactInputField(fieldName, value);
});

When("User enters {string} into the {string} textarea", async function (this: CustomWorld, value: string, fieldName: string) {
    await this.basePage.fillInTextArea(fieldName, value);
});

Then("User verifies the {string} field is {string}", async function (this: CustomWorld, label: string, status: string) {
    await this.basePage.verifyTextFieldStatus(label, status);
});

When("User clicks on the {string} button", async function (this: CustomWorld, btnName: string) {
    await this.basePage.clickOnBTNGeneral(btnName); //index = 0 by default
});

When("User clicks on the {string} button at index {int}", async function (this: CustomWorld, btnName: string, index: number) {
    await this.basePage.clickOnBTNGeneral(btnName, index);
});

Given("User goes to landing page", async function (this: CustomWorld) {
    await this.launchBrowserWithoutStorageSession();
});

Given("User log in with phone number {string} in the {string} country with {string} language", async function (this: CustomWorld, phone: string, country: string, language: string) {
    this.country = country;
    this.language = language || undefined;
    this.locale = buildLocale(country, this.language);
    if (phone === "random") {
        phone = generateRandomPhoneIndonesia();
        console.log(`✓ Picked random Indonesia test phone: ${phone}`);
    }
    (this as any).phone = phone;
    await this.launchBrowserWithPhoneLogin(country, language, phone);
});

Given("User goes to dashboard page in the {string} country with {string} language", async function (this: CustomWorld, country: string, language: string) {
    this.country = country;
    this.language = language || undefined;
    // build locale
    this.locale = buildLocale(country, this.language);
    await this.launchBrowserWithStorageSession(country, language);
});

Then("User verify the {string} button is {string}", async function (this: CustomWorld, buttonText: string, state: string) {
    await this.basePage.verifyButtonStatus(buttonText, state);
});

Then("User verifies the {string} text is {string}", async function (this: CustomWorld, text: string, state: string) {
    await this.basePage.verifyText(text, state);
});

When("User clicks on the {string} section", async function (this: CustomWorld, label: string) {
    await this.basePage.clickOnSection(label);
});

When("User clicks on the exact {string} section", async function (this: CustomWorld, label: string) {
    await this.basePage.clickOnExactSection(label);
});

When("User clicks on the {string} tab", async function (this: CustomWorld, name: string) {
    await this.basePage.clickOnTab(name);
});

When("User takes a screenshot", async function (this: CustomWorld) {
    await this.page.screenshot({ path: "debug-screenshot.png", fullPage: true });
});

When("User waits for {int} seconds", async function (this: CustomWorld, seconds: number) {
    await this.page.waitForTimeout(seconds * 1000);
});

When("User presses the {string} key", async function (this: CustomWorld, key: string) {
    await this.page.keyboard.press(key);
});
When("User switches to {string} iframe", async function (this: CustomWorld, name: string) {
    this.basePage.switchToFrame(name);
});

When("User switches to main page", async function (this: CustomWorld) {
    this.basePage.switchToMain();
});

When("User goes back", async function (this: CustomWorld) {
    await this.page.goBack();
    await this.basePage.pageAlready();
});

Then("The page should contain the following fields:", async function (this: CustomWorld, dataTable: DataTable) {
    const fields = dataTable.raw().flat();
    for (const field of fields) {
        await this.basePage.verifyText(field, "visible");
    }
});

Then("User should see the URL contains {string}", async function (this: CustomWorld, expected: string) {
    await this.basePage.verifyURL(expected);
});

When("User goes to {string} page", async function (this: CustomWorld, pageName: string) {
    const path = PAGE_ROUTES[pageName];
    if (!path) throw new Error(`Unknown page: ${pageName}. Available: ${Object.keys(PAGE_ROUTES).join(", ")}`);
    await this.basePage.goto(`${this.config.baseUrl}/${this.locale}/${path}`);
});

Then("User verifies URL {string}", async function (this: CustomWorld, expectedUrl: string) {
    await this.basePage.verifyURL(expectedUrl);
});

When("User verify the {string} header is {string}", async function (this: CustomWorld, header: string, state: string) {
    await this.basePage.verifyHeaderState(header, state);
});

Then("User verify the {string} text exactly is {string}", async function (this: CustomWorld, text: string, state: string) {
    await this.basePage.verifyTextExact(text, state);
});

When("User {string} the {string} toggle", async function (this: CustomWorld, action: string, label: string) {
    const checked = action.toLowerCase() === "enables" || action.toLowerCase() === "on";
    await this.basePage.setToggle(label, checked);
    if (checked) {
        await this.basePage.clickUnsubscribeIfShown();
    }
});

Then("User verify the {string} toggle is {string}", async function (this: CustomWorld, label: string, status: string) {
    await this.basePage.verifyToggleStatus(label, status);
});

When("User fill the random value in the {string} field", async function (this: CustomWorld, fieldName: string) {
    const fullName = Utils.randomFullName();
    this.fullName = fullName;
    await this.basePage.fillInGeneralInputField(fieldName, fullName);
});

When("User clicks on the element of data-testid {string}", async function (this: CustomWorld, testId: string) {
    await this.basePage.clickElementByDataTestId(testId);
});

When("User selects the {string} option from the dropdown", async function (this: CustomWorld, label: string) {
    await this.basePage.selectFirstDropdownOption(label);
});

When("User enters {string} into the {string} field and selects from dropdown", async function (this: CustomWorld, value: string, fieldName: string) {
    await this.basePage.fillAndSelectFromDropdown(fieldName, value, value);
});

Then("User verifies the image with alt text {string} is visible", async function (this: CustomWorld, altText: string) {
    await this.basePage.verifyImageByAltText(altText);
});

Then("User verifies the {string} class contains value {string}", async function (this: CustomWorld, className: string, expected: string) {
    await this.basePage.verifyTextByClassName(className, expected);
});

When("User clicks on the element of class {string}", async function (this: CustomWorld, className: string) {
    await this.basePage.clickOnElementByClass(className); //index = 0 by default
});

When("User chooses the option {int} in the {string} section", async function (this: CustomWorld, index: number, className: string) {
    await this.basePage.clickOnElementByClass(className, index - 1);
});

When("User verifies the popup {string} is {string}", async function (this: CustomWorld, popupName: string, state: string) {
    await this.basePage.verifyClassName(popupName, state);
});

When("User chooses the {string} radio button", async function (this: CustomWorld, groupLabel: string) {
    await this.basePage.selectRadioByName(groupLabel);
});

When("User clicks on the element with class containing {string}", async function (this: CustomWorld, partial: string) {
    await this.basePage.clickOnElementByClassContains(partial);
});
