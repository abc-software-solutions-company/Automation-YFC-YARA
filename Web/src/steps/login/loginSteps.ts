import { Given, When, Then, DataTable } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";
import { getOTP, getOTPWithRetry } from "../../utils/otp/otp.helper";
import { Utils } from "../../utils/common/commonUtils";
import { captureTokenFromConsentBundle } from "../../utils/token/tokens";
import { saveTokenToCSV } from "../../utils/token/csv";

When("User types the otp of the {string} phone number", async function (this: CustomWorld, phone: string) {
    await this.page.waitForTimeout(2000);
    const otp = await getOTPWithRetry(phone, 5);
    await this.loginPage.TypeOtp(otp);
});

When("User selects {string} option on the {string} dropdown", async function (this: CustomWorld, option: string, dropdownName: string) {
    await this.loginPage.clickOnCountryDropdown(dropdownName);
    await this.loginPage.selectCountryOption(option);
});

Then("Navigate to {string} page or {string} or {string} page", async function (this: CustomWorld, page1: string, page2: string, page3: string) {
    await this.basePage.pageAlready();
    await this.loginPage.expectURLHave(page1, page2, page3);
});

Then("The {string} dropdown should have {string} selected by default", async function (this: CustomWorld, dropdownName: string, defaultValue: string) {
    await this.loginPage.expectCountryDefault(defaultValue, dropdownName);
});

Then("The {string} dropdown should have the following {string} options:", async function (this: CustomWorld, label: string, options: string) {
    const phoneCodeList = Utils.splitString(options);
    await this.loginPage.expectCountryOptions(label, phoneCodeList);
});

Then("The following buttons should be {string}: {string}", async function (this: CustomWorld, status: string, buttons: string) {
    const buttonList = Utils.splitString(buttons);
    for (const buttonText of buttonList) {
        await this.basePage.verifyButtonStatus(buttonText, status);
    }
});

Then("User verify the link {string} should be {string}", async function (this: CustomWorld, link: string, status: string) {
    await this.basePage.pageAlready();
    await this.basePage.verifyLinkState(link, status);
    await this.basePage.clickLink(link);
    await this.page.waitForTimeout(1000);
});

Then("User verify the title {string} should be {string}", async function (this: CustomWorld, title: string, status: string) {
    await this.page.waitForTimeout(1000);
    await this.basePage.verifyTitleState(title, status);
    await this.loginPage.clickCloseIcon();
    await this.page.waitForTimeout(1000);
});

Then("I capture token and save to {string}", async function (fileName: string) {
    await this.page.waitForLoadState("domcontentloaded");
    const token = await captureTokenFromConsentBundle(this.page);

    console.log("TOKEN:", token);
    this.token = token;

    // call function saveTokenToCSV
    saveTokenToCSV(token, fileName);
});
