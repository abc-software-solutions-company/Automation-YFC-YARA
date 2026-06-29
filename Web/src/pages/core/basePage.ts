import { Page, expect, Locator, FrameLocator } from "@playwright/test";
import { CommonLocator } from "./baseLocator";
import { time } from "console";
import { TestDataLoader, TestDataStore } from "../../utils/i18n/testDataLoader";

export class BasePage {
    protected readonly page: Page;
    protected loc: CommonLocator;
    locale?: string;
    testDataCache: Record<string, TestDataStore> = {};

    constructor(page: Page) {
        this.page = page;
        this.loc = new CommonLocator(page, (value) => TestDataLoader.resolve(value, this.locale ?? "", this.testDataCache));
        this.page.setDefaultTimeout(60000);
    }
    resolve(value: string): string {
        // return TestDataLoader.resolve(value, this.locale ?? "", this.testDataCache);
        return this.loc.resolve(value);
    }
    switchToFrame(name: string): void {
        const frame = this.page.frameLocator(`iframe[title="${name}"]`);
        this.loc = new CommonLocator(frame, (value) => TestDataLoader.resolve(value, this.locale ?? "", this.testDataCache));
    }

    switchToMain(): void {
        this.loc = new CommonLocator(this.page, (value) => TestDataLoader.resolve(value, this.locale ?? "", this.testDataCache));
    }

    //#region Action
    async goto(url: string): Promise<void> {
        await this.page.goto(url);
        await this.pageAlready();
    }

    async reload(): Promise<void> {
        await this.page.reload();
        await this.pageAlready();
    }

    async dismissPopupIfShown(maxAttempts: number = 5): Promise<void> {
        const selector = 'button[aria-label="close" i], button:has(svg[data-testid="CloseIcon"]), [data-testid="close"]';
        for (let i = 0; i < maxAttempts; i++) {
            const closeBtn = this.page.locator(selector).first();
            const visible = await closeBtn.isVisible({ timeout: i === 0 ? 2000 : 800 }).catch(() => false);
            if (!visible) return;
            await closeBtn.click().catch(() => {});
            await this.page.waitForTimeout(500);
        }
    }

    async pageAlready(): Promise<void> {
        await this.page.waitForLoadState("domcontentloaded");
        await this.page.waitForTimeout(2000);
    }

    protected async findInPageOrFrames(probe: (src: Page | FrameLocator) => Locator, timeout = 30000): Promise<Page | FrameLocator> {
        const deadline = Date.now() + timeout;
        while (Date.now() < deadline) {
            // 1. main page
            if (
                (await probe(this.page)
                    .count()
                    .catch(() => 0)) > 0
            )
                return this.page;
            // 2. each iframe on the page
            const iframes = this.page.locator("iframe");
            const iframeCount = await iframes.count().catch(() => 0);
            for (let i = 0; i < iframeCount; i++) {
                const frame = iframes.nth(i).contentFrame();
                if (
                    (await probe(frame)
                        .count()
                        .catch(() => 0)) > 0
                )
                    return frame;
            }
            await this.page.waitForTimeout(200);
        }
        return this.page;
    }

    /** Build a CommonLocator scoped to a given page or frame, sharing the i18n resolver. */
    private locFor(source: Page | FrameLocator): CommonLocator {
        return new CommonLocator(source, (value) => TestDataLoader.resolve(value, this.locale ?? "", this.testDataCache));
    }

    protected async frameAwareLocator(build: (cl: CommonLocator) => Locator, timeout = 30000): Promise<Locator> {
        const deadline = Date.now() + timeout;
        while (Date.now() < deadline) {
            // Search the current root first, then each iframe.
            const sources: CommonLocator[] = [this.loc];
            const iframes = this.page.locator("iframe");
            const frameCount = await iframes.count().catch(() => 0);
            for (let i = 0; i < frameCount; i++) sources.push(this.locFor(iframes.nth(i).contentFrame()));

            let attached: Locator | null = null;
            for (const cl of sources) {
                const all = build(cl);
                const visible = all.filter({ visible: true });
                if ((await visible.count().catch(() => 0)) > 0) return visible;
                if (!attached && (await all.count().catch(() => 0)) > 0) attached = all;
            }
            if (attached) return attached;
            await this.page.waitForTimeout(200);
        }
        return build(this.loc);
    }

    private getStatusCheckFunction(status: string, locator: Locator): () => Promise<void> {
        let normalized = status.toLowerCase();
        let checks: Record<string, () => Promise<void>> = {
            visible: () => expect.soft(locator).toBeVisible({ timeout: 30000 }),
            hidden: () => expect.soft(locator).toBeHidden(),
            enabled: () => expect.soft(locator).toBeEnabled(),
            disabled: () => expect.soft(locator).toBeDisabled(),
            editable: () => expect.soft(locator).toBeEditable(),
            focused: () => expect.soft(locator).toBeFocused(),
            checked: () => expect.soft(locator).toBeChecked(),
            unchecked: () => expect.soft(locator).not.toBeChecked(),
        };
        let check = checks[normalized];
        if (!check) {
            throw new Error(`Invalid Status: ${status}`);
        }
        return check;
    }

    async verifyElementStatus(locator: Locator, status: string): Promise<void> {
        if (status.toLowerCase() !== "hidden") {
            await locator.waitFor({ state: "attached" });
        }
        let check = this.getStatusCheckFunction(status, locator);
        await check();
    }

    async fillInGeneralInputField(label: string, value: string | null): Promise<void> {
        if (value !== null) {
            const locator = await this.frameAwareLocator((cl) => cl.textbox(label));
            await locator.waitFor({ state: "visible" });
            await locator.fill("");
            await locator.fill(this.resolve(value));
            await this.page.waitForTimeout(1000);
            await locator.blur();
        }
    }

    async fillInExactInputField(label: string, value: string | null): Promise<void> {
        if (value !== null) {
            const locator = await this.frameAwareLocator((cl) => cl.textboxExact(label));
            await locator.waitFor({ state: "visible" });
            await locator.fill("");
            await locator.fill(this.resolve(value));
            await this.page.waitForTimeout(1000);
        }
    }

    async fillInTextArea(label: string, value: string | null): Promise<void> {
        if (value !== null) {
            const locator = await this.frameAwareLocator((cl) => cl.textarea(label));
            await locator.waitFor({ state: "visible" });
            await locator.fill("");
            await locator.fill(this.resolve(value));
            await this.page.waitForTimeout(1000);
            await locator.blur();
        }
    }

    async typeInputField(name: string, value: string): Promise<void> {
        let locator = this.loc.textbox(name);
        if (value !== null) {
            await locator.waitFor({ state: "visible" });
            await locator.click();
            await locator.pressSequentially(value, { delay: 120 });
            for (const digit of value) {
                await this.page.keyboard.press(digit);
            }
            await this.page.waitForTimeout(1000);
        }
    }

    async verifyTextFieldStatus(label: string, status: string): Promise<void> {
        const locator = await this.frameAwareLocator((cl) => cl.textbox(label));
        await this.verifyElementStatus(locator, status);
    }

    async verifyTextAreaStatus(label: string, status: string): Promise<void> {
        const locator = await this.frameAwareLocator((cl) => cl.textarea(label));
        await this.verifyElementStatus(locator, status);
    }

    /* ===================== GET TEXTFIELD VALUE ===================== */

    async getTextFieldValue(label: string): Promise<string> {
        let locator = this.loc.textbox(label);
        await locator.waitFor({ state: "visible" });
        return await locator.inputValue();
    }

    async getTextAreaValue(label: string): Promise<string> {
        let locator = this.loc.textarea(label);
        await locator.waitFor({ state: "visible" });
        return await locator.inputValue();
    }

    async verifyTextFieldValue(label: string, expected: string): Promise<void> {
        let actual = await this.getTextFieldValue(label);
        expect.soft(actual).toBe(expected);
    }

    async verifyTextAreaValue(label: string, expected: string): Promise<void> {
        let actual = await this.getTextAreaValue(label);
        expect.soft(actual).toBe(expected);
    }

    async clickOnBTNGeneral(name: string, index: number = 0): Promise<void> {
        await this.pageAlready();
        const locator = (await this.frameAwareLocator((cl) => cl.button(name))).nth(index);
        await locator.waitFor({ state: "visible" });
        await locator.click();
        await this.pageAlready();
    }

    async verifyButtonStatus(name: string, status: string): Promise<void> {
        await this.page.waitForTimeout(1000);
        const locator = (await this.frameAwareLocator((cl) => cl.button(name))).first();
        await this.verifyElementStatus(locator, status);
    }

    //#endregion
    //#region Radio
    async selectRadio(groupLabel: string, option: string): Promise<void> {
        const locator = this.loc.radio(groupLabel, option);
        await locator.waitFor({ state: "visible" });
        await locator.check();
    }

    async selectRadioByName(groupLabel: string): Promise<void> {
        const locator = this.loc.radioName(groupLabel).first();
        await locator.waitFor({ state: "visible" });
        await locator.check();
    }

    async verifyRadioStatus(groupLabel: string, option: string, status: string): Promise<void> {
        const locator = this.loc.radio(groupLabel, option);
        await this.verifyElementStatus(locator, status);
    }
    //#endregion

    //#region Checkbox
    async setCheckbox(label: string, checked: boolean): Promise<void> {
        const locator = this.loc.checkbox(label);
        await locator.waitFor({ state: "visible" });
        const isChecked = await locator.isChecked();
        if (isChecked !== checked) {
            if (checked) {
                await locator.check();
            } else {
                await locator.uncheck();
            }
        }
    }

    async verifyCheckboxStatus(label: string, status: string): Promise<void> {
        const locator = this.loc.checkbox(label);
        await this.verifyElementStatus(locator, status);
    }
    //#endregion

    //#region Toggle
    async setToggle(label: string, checked: boolean): Promise<void> {
        const locator = this.loc.toggle(label).first();
        await locator.waitFor({ state: "visible" });

        const testId = (await locator.getAttribute("data-testid")) || "";
        let isCurrentlyOn: boolean;

        if (testId.includes("toggle-")) {
            isCurrentlyOn = testId.includes("-on");
        } else {
            isCurrentlyOn = await locator.isChecked();
        }

        if (isCurrentlyOn !== checked) {
            await locator.click();
        }
    }

    private unsubscribeButton() {
        return this.page
            .locator("button")
            .filter({ hasText: /Unsubscribe|Berhenti berlangganan|ยกเลิกการรับ/i })
            .first();
    }

    async clickUnsubscribeIfShown(timeoutMs: number = 5000): Promise<void> {
        try {
            const btn = this.unsubscribeButton();
            if (await btn.isVisible({ timeout: timeoutMs })) {
                await btn.click();
            }
        } catch {
            /* button not shown — nothing to dismiss */
        }
    }

    async verifyToggleStatus(label: string, status: string): Promise<void> {
        const locator = this.loc.toggle(label).first();
        await locator.waitFor({ state: "visible" });

        const testId = (await locator.getAttribute("data-testid")) || "";
        const normalized = status.toLowerCase();

        if (testId.includes("toggle-")) {
            const isCurrentlyOn = testId.includes("-on");
            if (normalized === "checked" || normalized === "on") {
                expect.soft(isCurrentlyOn, `Toggle '${label}' should be checked`).toBe(true);
            } else if (normalized === "unchecked" || normalized === "off") {
                expect.soft(isCurrentlyOn, `Toggle '${label}' should be unchecked`).toBe(false);
            } else {
                await this.verifyElementStatus(locator, status);
            }
        } else {
            await this.verifyElementStatus(locator, status);
        }
    }
    //#endregion

    async verifyLinkState(link: string, state: string): Promise<void> {
        const locator = this.loc.linkCustom(link);
        const check = this.getStatusCheckFunction(state, locator);
        await check();
    }

    async verifyTitleState(title: string, state: string): Promise<void> {
        const locator = this.loc.title(title);
        const check = this.getStatusCheckFunction(state, locator);
        await check();
    }

    async verifyHeaderState(header: string, state: string): Promise<void> {
        const locator = this.loc.header(header);
        const check = this.getStatusCheckFunction(state, locator);
        await check();
    }

    async clickLink(link: string): Promise<void> {
        let locator = await this.loc.linkCustom(link);
        await locator.waitFor({ state: "visible" });
        await locator.click();
    }

    async verifyURL(expected: string): Promise<void> {
        await this.page.waitForURL(`**${expected}**`, { timeout: 10000 });
        const actUrl = new URL(this.page.url());
        expect.soft(actUrl.pathname).toContain(expected);
    }

    async verifyText(text: string, state: string): Promise<void> {
        const locator = (await this.frameAwareLocator((cl) => cl.containsText(text))).first();

        if (state === "visible") {
            await expect(locator).toBeVisible();
        } else if (state === "hidden") {
            await expect(locator).toBeHidden();
        } else if (state === "attached") {
            await expect(locator).toBeAttached();
        } else {
            throw new Error(`Unsupported state: ${state}`);
        }
    }

    async clickOnSection(label: string): Promise<void> {
        const locator = (await this.frameAwareLocator((cl) => cl.containsText(label))).first();
        await locator.waitFor({ state: "visible" });
        await locator.click();
        await this.pageAlready();
    }

    async clickOnExactSection(label: string): Promise<void> {
        const locator = (await this.frameAwareLocator((cl) => cl.text(label))).first();
        await locator.waitFor({ state: "visible" });
        await locator.click();
        await this.pageAlready();
    }

    async clickOnTab(name: string): Promise<void> {
        const locator = await this.frameAwareLocator((cl) => cl.tab(name));
        await locator.waitFor({ state: "visible" });
        await locator.click();
        await this.pageAlready();
    }

    async verifyTextExact(text: string, state: string): Promise<void> {
        const locator = (await this.frameAwareLocator((cl) => cl.text(text))).first();

        if (state === "visible") {
            await expect(locator).toBeVisible();
        } else if (state === "hidden") {
            await expect(locator).toBeHidden();
        } else if (state === "attached") {
            await expect(locator).toBeAttached();
        } else {
            throw new Error(`Unsupported state: ${state}`);
        }
    }
    //#endregion

    // data test id
    async verifyElementByDataTestId(testId: string, state: string): Promise<void> {
        const locator = this.loc.dataTestId(testId);
        const check = this.getStatusCheckFunction(state, locator);
        await check();
    }

    async clickElementByDataTestId(testId: string): Promise<void> {
        const locator = this.loc.dataTestId(testId);
        await locator.waitFor({ state: "visible" });
        await locator.click();
    }
    //#endregion

    // dropdown list
    async selectFirstDropdownOption(label: string): Promise<void> {
        const optionLocator = this.loc.ddlOption(label).first();
        await optionLocator.waitFor({ state: "visible" });
        await optionLocator.click();
    }

    async fillAndSelectFromDropdown(fieldName: string, value: string, optionLabel: string): Promise<void> {
        const inputLocator = this.loc.textbox(fieldName);
        const optionLocator = this.loc.ddlOption(optionLabel).first();
        const resolvedValue = this.resolve(value);
        const maxAttempts = 3;

        await inputLocator.waitFor({ state: "visible" });

        for (let attempt = 1; attempt <= maxAttempts; attempt++) {
            await inputLocator.fill("");
            await inputLocator.fill(resolvedValue);

            try {
                await optionLocator.waitFor({ state: "visible", timeout: 7000 });
                await optionLocator.click();
                return;
            } catch (e) {
                if (attempt === maxAttempts) throw e;
                await this.page.waitForTimeout(1500);
            }
        }
    }
    //#endregion

    // image
    async verifyImageByAltText(altText: string): Promise<void> {
        const locator = this.loc.imageAlt(altText);
        await locator.waitFor({ state: "visible" });
    }

    // class with text
    async verifyClassName(className: string, state: string): Promise<void> {
        const locator = this.loc.className(className).first();
        if (state === "visible") {
            await expect(locator).toBeVisible();
        } else if (state === "hidden") {
            await expect(locator).toBeHidden();
        } else if (state === "attached") {
            await expect(locator).toBeAttached();
        } else {
            throw new Error(`Unsupported state: ${state}`);
        }
    }

    async getTextByClassName(className: string): Promise<string> {
        const locator = this.loc.className(className).first();
        await locator.waitFor({ state: "visible" });
        return (await locator.textContent())?.trim() ?? "";
    }

    async verifyTextByClassName(className: string, expected: string): Promise<void> {
        const actual = await this.getTextByClassName(className);
        expect.soft(actual).toBe(expected);
    }

    async clickOnElementByClass(className: string, index?: number): Promise<void> {
        const locator = index !== undefined ? this.loc.className(className, index) : this.loc.className(className).first();
        await locator.waitFor({ state: "visible" });
        await locator.click();
        await this.pageAlready();
    }

    async clickOnElementByClassContains(partial: string): Promise<void> {
        const locator = this.loc.classNameContains(partial).first();
        await locator.waitFor({ state: "visible" });
        await locator.click();
        await this.pageAlready();
    }
}
