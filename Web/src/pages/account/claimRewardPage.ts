import { FrameLocator, Locator, Page, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";
import { SAMPLE_KTP_PATH } from "../../support/config";

const S3_URL = /\.s3[.-]/i;

export class ClaimRewardPage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    //#region Locators
    private static readonly KTP_INPUT = "input#id-document";
    // TH custom dropdown menu — options are MUI radio labels inside the open menu container
    private static readonly TH_DROPDOWN_OPTION = '[class*="CustomDropdown_dropdownMenu"] label.MuiFormControlLabel-root';

    // Indonesia MUI claim form dropdown: <label>X</label> + <button role="combobox">
    private static indoComboboxXP = (label: string) =>
        `xpath=(//label[starts-with(normalize-space(.), "${label}")]/parent::*//button[@role="combobox"])[1]`;

    // Thailand custom dropdown toggle: <div class="CustomDropdown_dropdownToggle..."> containing a labelled div with field text
    private static thDropdownToggleXP = (label: string) =>
        `xpath=//div[contains(@class, "CustomDropdown_dropdownToggle") and .//div[normalize-space(.)="${label}"]]`;

    // TH claim CTA pencil: only svg.cursor-pointer (NOT the back-arrow div which also has cursor-pointer)
    private claimEditPencil(source: Page | FrameLocator, claimText: string): Locator {
        return source
            .locator("div")
            .filter({ hasText: claimText })
            .filter({ has: source.locator("svg.cursor-pointer") })
            .first()
            .locator("svg.cursor-pointer")
            .first();
    }
    //#endregion

    /**
     * Resolve a selector against either the main page or any child iframe (the claim form
     * lives in a `dgl-farmer-loyalty` iframe). Returns the source that matched, or null.
     */
    private async findInAnyFrame(selector: string): Promise<{ source: Page | FrameLocator } | null> {
        if ((await this.page.locator(selector).count().catch(() => 0)) > 0) return { source: this.page };
        const iframes = this.page.locator("iframe");
        const count = await iframes.count().catch(() => 0);
        for (let i = 0; i < count; i++) {
            const fl = iframes.nth(i).contentFrame();
            if ((await fl.locator(selector).count().catch(() => 0)) > 0) return { source: fl };
        }
        return null;
    }

    /**
     * Click the pencil/edit icon inside the claim CTA card to open the claim form.
     * TH UI: card text has no click handler — only the svg.cursor-pointer (pencil) navigates.
     */
    async openClaimFormByEditIcon(claimText: string): Promise<void> {
        const source = await this.findInPageOrFrames((s) => this.claimEditPencil(s, claimText));
        const pencil = this.claimEditPencil(source, claimText);
        await pencil.waitFor({ state: "visible", timeout: 10000 });
        await pencil.click();
        await this.page.waitForTimeout(2000);
        await this.page.waitForLoadState("domcontentloaded").catch(() => {});
    }

    async uploadKTPDocument(filePath: string = SAMPLE_KTP_PATH): Promise<void> {
        const found = await this.findInAnyFrame(ClaimRewardPage.KTP_INPUT);
        if (!found) throw new Error(`KTP file input (${ClaimRewardPage.KTP_INPUT}) not found in any frame`);
        await found.source.locator(ClaimRewardPage.KTP_INPUT).setInputFiles(filePath);
        await this.page.waitForTimeout(2000);
    }

    /** Cascading dropdowns on the claim form. Supports Indonesia MUI combobox + Thailand CustomDropdown. */
    async selectFirstDropdownOption(label: string): Promise<void> {
        const indoXP = ClaimRewardPage.indoComboboxXP(label);
        const indoFound = await this.findInAnyFrame(indoXP);
        if (indoFound) {
            const source = indoFound.source;
            const combobox = source.locator(indoXP);
            await expect(combobox).toBeEnabled({ timeout: 30000 });
            await combobox.click();
            const firstOption = source.getByRole("option").first();
            await firstOption.waitFor({ state: "visible", timeout: 10000 });
            await firstOption.click();
            await this.page.waitForTimeout(1500);
            return;
        }

        const thXP = ClaimRewardPage.thDropdownToggleXP(label);
        const thFound = await this.findInAnyFrame(thXP);
        if (thFound) {
            const source = thFound.source;
            const toggle = source.locator(thXP);
            await toggle.waitFor({ state: "visible", timeout: 30000 });
            // Cascading delay: each dropdown waits on the previous selection's API
            // to populate options before becoming truly clickable.
            await this.page.waitForTimeout(2000);
            await toggle.click();
            const firstOption = source.locator(ClaimRewardPage.TH_DROPDOWN_OPTION).first();
            await firstOption.waitFor({ state: "visible", timeout: 30000 });
            await firstOption.click();
            await this.page.waitForTimeout(2000);
            return;
        }

        throw new Error(`Dropdown for "${label}" not found (tried Indonesia <label>+combobox and Thailand CustomDropdown patterns)`);
    }

    /**
     * Background listener: captures the submissionId from the GET document-submission response
     * fired after the user clicks Konfirmasi. Register BEFORE clicking Konfirmasi.
     * The POST submit returns only `{success, message}` — id is only available via the GET that
     * the iframe fires immediately after.
     */
    watchForSubmissionId(onCapture: (id: string) => void): void {
        let captured = false;
        this.page.on("response", async (resp) => {
            if (captured) return;
            const url = resp.url();
            if (!/document-submission/i.test(url) || /presign-url/i.test(url)) return;
            if (S3_URL.test(url)) return;
            try {
                const body = (await resp.json()) as { id?: string };
                if (body.id) {
                    captured = true;
                    onCapture(body.id);
                    console.log(`✓ Captured submissionId ${body.id}`);
                }
            } catch {
                /* swallow non-JSON or already-consumed bodies */
            }
        });
    }
}
