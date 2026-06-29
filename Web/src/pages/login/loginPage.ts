import { Page, expect } from "@playwright/test";
import { peekOTP, getFreshOTP } from "../../utils/otp/otp.helper";
import { LocalePage } from "./localePage";
import { BasePage } from "../core/basePage";
import { COUNTRY_CONFIG, CountryConfig, resolveLanguage, getLanguageLabel } from "../../support/config";
import { Utils } from "../../utils/common/commonUtils";
import { TestDataLoader } from "../../utils/i18n/testDataLoader";

async function handleMarketingConsentIfShown(page: Page): Promise<void> {
    if (!page.url().includes("/marketing-consent")) return;
    await page.locator("button.MuiButton-containedPrimary").first().click();
    await page.waitForURL((url) => !url.pathname.includes("/marketing-consent"), { timeout: 30000 });
    await page.waitForLoadState("networkidle").catch(() => {});
}

async function handleSignupOnboardingIfShown(page: Page, country: CountryConfig, countryName: string): Promise<void> {
    if (!page.url().includes("/signup")) return;
    if (!country.onboarding) {
        throw new Error(`Country "${countryName}" landed on /signup but has no onboarding fixture in COUNTRY_CONFIG.`);
    }
    const { labels, defaults } = country.onboarding;

    await page.getByLabel(labels.name).fill(Utils.randomFullName());

    // Address typeahead requires real keystrokes to fire suggestions — `fill()` sets the value
    // directly and doesn't trigger the autocomplete. pressSequentially simulates typing.
    const addressInput = page.getByLabel(labels.address);
    await addressInput.click();
    await addressInput.pressSequentially(defaults.address, { delay: 80 });
    // Give debounced autocomplete + maps API call time to return.
    await page.waitForTimeout(2000);

    const suggestionSelectors = [
        "div.hover:has(p.listLabel)",
        "[role='listbox'] [role='option']",
        "[class*='suggestion'] [class*='item']",
        "[class*='autocomplete'] li",
        ".pac-container .pac-item", // Google Maps Places API
        "[data-testid*='suggestion']",
        "[data-testid*='autocomplete']",
        "[data-testid*='address-list']",
        `li:has-text("${defaults.address}")`,
        `div[class*='dropdown'] div:has-text("${defaults.address}")`,
    ];
    let clicked = false;
    for (const sel of suggestionSelectors) {
        const candidate = page.locator(sel).first();
        if (await candidate.isVisible({ timeout: 1500 }).catch(() => false)) {
            await candidate.click();
            clicked = true;
            console.log(`✓ Onboarding address autocomplete selector matched: ${sel}`);
            break;
        }
    }
    if (!clicked) {
        // Capture DOM snapshot near the address field to help update selectors next round.
        const debugDom = await page
            .locator("body")
            .evaluate((el) => {
                const all = Array.from(el.querySelectorAll("*"));
                const visible = all.filter((n) => {
                    const r = (n as HTMLElement).getBoundingClientRect();
                    return r.width > 0 && r.height > 0;
                });
                const samples = visible
                    .filter((n) => n.textContent && (n.textContent.toLowerCase().includes("jakarta") || n.textContent.toLowerCase().includes("alamat")))
                    .slice(0, 8)
                    .map((n) => `${n.tagName.toLowerCase()}.${(n as HTMLElement).className} → ${n.textContent?.slice(0, 80)}`);
                return samples.join("\n");
            })
            .catch(() => "(failed to capture DOM)");
        const screenshotPath = `debug-onboarding-${Date.now()}.png`;
        await page.screenshot({ path: screenshotPath, fullPage: true }).catch(() => {});
        throw new Error(
            `Onboarding address autocomplete: no suggestion appeared after typing "${defaults.address}".\n` +
                `Tried selectors: ${suggestionSelectors.join(", ")}\n` +
                `Visible elements containing "Jakarta" or "Alamat":\n${debugDom}\n` +
                `Screenshot saved to: ${screenshotPath}`,
        );
    }

    await page.getByRole("button", { name: labels.continueBtn }).click();

    await page.getByLabel(labels.farmSize).fill(defaults.farmSize);
    await page.locator('[data-testid^="crop-card-"]').first().click();
    await page.getByRole("button", { name: labels.finishBtn }).click();

    await page.getByRole("button", { name: labels.successBtn }).click({ timeout: 30000 });
    await page.waitForURL((url) => !url.pathname.includes("/signup"), { timeout: 30000 });
    await page.waitForLoadState("networkidle").catch(() => {});
}

export class LoginPage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    //#region Locators
    countryCodeDropdown = (label: string) => this.page.locator(`xpath=//div[contains(.,'${label}')]/..//div[@data-testid="input_button"]`);
    countryOption = (name: string) => this.page.locator(`xpath=//ul/li/span[contains(normalize-space(.),"${name}")]`);
    countryDefault = (defaultValue: string, dropdownName: string) => this.page.locator(`xpath=//div[contains(.,'${dropdownName}')]/..//div[@data-testid="input_button"]/..//span[contains(normalize-space(.),"${defaultValue}")]`);
    countryListItem = (option: string) => this.page.locator(".country-list__item", { hasText: option });
    otpInput = this.page.locator(`//input[@data-testid="InputMask"]`);
    closeIcon = this.page.locator('[testid="CloseIcon"]');
    /* ===================== HEADER ===================== */
    headerName = (hdName: string) => this.page.locator(`xpath=//p[@data-testid='headertext'and normalize-space(text())='${hdName}']`);

    // Login flow
    loginBtn = this.page.locator('button[eventname="a_Farmers_OnboardingScreen_select_sign_up_login"]');
    inputButton = this.page.getByTestId("input_button");
    countryCode = (dialCode: string) => this.page.locator("span.country-list__code", { hasText: dialCode });
    phoneInput = this.page.getByTestId("Input");
    continueBtn = this.page.getByTestId("ContinueButton");
    confirmationBtn = this.page.getByTestId("ConfirmationButton");
    //#endregion

    async TypeOtp(value: string): Promise<void> {
        if (value !== null) {
            await this.otpInput.waitFor({ state: "visible" });
            await this.otpInput.click();
            await this.otpInput.pressSequentially(value, { delay: 120 });
            for (const digit of value) {
                await this.page.keyboard.press(digit);
            }
            await this.page.waitForTimeout(1000);
        }
    }

    async expectCountryOptions(label: string, options: string[]) {
        await this.clickOnCountryDropdown(this.resolve(label));
        for (const option of options) {
            await expect(this.countryListItem(option)).toBeVisible();
        }
        await this.page.keyboard.press("Escape");
    }

    async expectURLHave(url: string, url2: string, url3: string): Promise<void> {
        await this.pageAlready();
        await this.page.waitForURL((currentUrl) => currentUrl.href.includes(url) || currentUrl.href.includes(url2) || currentUrl.href.includes(url3));
    }

    async expectCountryDefault(label: string, dropdownName: string) {
        await this.pageAlready();
        await expect(this.countryDefault(this.resolve(label), this.resolve(dropdownName))).toBeVisible();
    }

    async expectCountryCodeOptions(label: string, options: string[]) {
        await this.clickOnCountryDropdown(this.resolve(label));
        for (const option of options) {
            await expect(this.countryListItem(option)).toBeVisible();
        }
        await this.page.keyboard.press("Escape");
    }

    async clickOnCountryDropdown(name: string): Promise<void> {
        await this.countryCodeDropdown(this.resolve(name)).waitFor({ state: "visible" });
        await this.countryCodeDropdown(this.resolve(name)).click({ force: true });
    }

    async selectCountryOption(name: string): Promise<void> {
        await this.countryOption(name).waitFor({ state: "visible" });
        await this.countryOption(name).click();
        await this.pageAlready();
    }

    async clickCloseIcon(): Promise<void> {
        await this.page.waitForTimeout(2000);
        await this.closeIcon.click();
    }
    async handleLanguageIfDisplayed(): Promise<void> {
        if (
            await this.headerName("Choose your language")
                .isVisible()
                .catch(() => false)
        ) {
            // Select English
            await this.verifyText("English", "visible");
            await this.clickOnSection("English");

            // click Next
            await this.clickOnBTNGeneral("Next");
        }
        const locale = TestDataLoader.captureLocale(this.page);
        if (locale) this.locale = locale;
    }
}

export async function loginWithPhone(page: Page, countryName: string, language: string, phone: string): Promise<void> {
    const localePage = new LocalePage(page);
    const loginPage = new LoginPage(page);
    await page.waitForTimeout(5000);

    const config = COUNTRY_CONFIG[countryName];
    if (!config) {
        throw new Error(`Unsupported country: ${countryName}`);
    }

    const { dialCode } = config;
    const selectedLanguage = resolveLanguage(language, config);
    const label = getLanguageLabel(selectedLanguage);

    if ((await loginPage.loginBtn.count()) === 0) {
        await localePage.clickOnCountry(countryName);
        if (config.hasLanguageSelector) {
            await localePage.clickOnLanguage(label);
            await localePage.clickOnBTNGeneral("Next");
        }
    }

    await loginPage.loginBtn.waitFor({ state: "visible", timeout: 20000 });
    await loginPage.loginBtn.click();

    await loginPage.inputButton.click();
    await loginPage.countryCode(dialCode).click();
    await loginPage.phoneInput.fill(phone);
    // Snapshot the existing OTP before requesting a new one, then wait until it changes
    const previousOtp = await peekOTP(`${dialCode}${phone}`);
    await loginPage.continueBtn.click();
    await page.waitForLoadState("domcontentloaded");
    await expect(loginPage.confirmationBtn).toBeVisible();
    const otp = await getFreshOTP(`${dialCode}${phone}`, previousOtp);
    await loginPage.TypeOtp(otp);
    await loginPage.confirmationBtn.click();

    await loginPage.confirmationBtn.waitFor({ state: "detached", timeout: 60000 });
    await page.waitForURL((url) => !url.href.includes("/auth/callback") && !url.href.includes("onmicrosoft.com"), { timeout: 60000 });

    await handleMarketingConsentIfShown(page);
    await handleSignupOnboardingIfShown(page, config, countryName);
}

export async function login(page: Page, countryName: string, language: string): Promise<void> {
    const localePage = new LocalePage(page);
    const loginPage = new LoginPage(page);
    await page.waitForTimeout(5000);

    const config = COUNTRY_CONFIG[countryName];

    if (!config) {
        throw new Error(`Unsupported country: ${countryName}`);
    }

    const { phone, dialCode } = COUNTRY_CONFIG[countryName];

    const selectedLanguage = resolveLanguage(language, config);
    const label = getLanguageLabel(selectedLanguage);

    if ((await loginPage.loginBtn.count()) === 0) {
        await localePage.clickOnCountry(countryName);
        if (config.hasLanguageSelector) {
            await localePage.clickOnLanguage(label);
            await localePage.clickOnBTNGeneral("Next");
        }
    }

    await loginPage.loginBtn.waitFor({ state: "visible", timeout: 20000 });
    await loginPage.loginBtn.click();

    await loginPage.inputButton.click();
    await loginPage.countryCode(dialCode).click();
    await loginPage.phoneInput.fill(phone);
    // Snapshot the existing OTP before requesting a new one, then wait until it changes
    const previousOtp = await peekOTP(`${dialCode}${phone}`);
    await loginPage.continueBtn.click();
    await page.waitForLoadState("domcontentloaded");
    await expect(loginPage.confirmationBtn).toBeVisible();
    const otp = await getFreshOTP(`${dialCode}${phone}`, previousOtp);
    await loginPage.TypeOtp(otp);
    await loginPage.confirmationBtn.click();

    await loginPage.confirmationBtn.waitFor({ state: "detached", timeout: 60000 });
    await page.waitForURL((url) => !url.href.includes("/auth/callback") && !url.href.includes("onmicrosoft.com"), { timeout: 60000 });

    await handleMarketingConsentIfShown(page);
    await handleSignupOnboardingIfShown(page, config, countryName);
}
