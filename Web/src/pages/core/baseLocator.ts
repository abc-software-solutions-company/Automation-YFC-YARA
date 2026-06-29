import { Page, Locator, FrameLocator } from "@playwright/test";

export class CommonLocator {
    private _resolve: (value: string) => string;
    constructor(
        private page: Page | FrameLocator,
        resolve?: (value: string) => string,
    ) {
        this._resolve = resolve ?? ((value) => value);
    }

    resolve(value: string): string {
        return this._resolve(value);
    }

    /* ===================== INPUT / TEXTBOX ===================== */
    textbox = (name: string) => {
        const r = this._resolve(name);
        return this.page
            .getByRole("textbox", { name: r })
            .or(this.page.getByLabel(r))
            .or(this.page.getByPlaceholder(r))
            .or(this.page.locator(`[data-testid*="${r}"]`).locator("input, textarea, [role='textbox']"))
            .or(this.page.locator(`input[data-testid*="${r}"], textarea[data-testid*="${r}"]`))
            .or(this.page.locator(`xpath=//span[contains(normalize-space(.),'${r}')]/input[1]`))
            .or(this.page.locator(`xpath=//input[@placeholder="${r}"]`));
    };
    textboxExact = (name: string) => {
        const r = this._resolve(name);
        return this.page
            .getByRole("textbox", { name: r, exact: true })
            .or(this.page.getByPlaceholder(r, { exact: true }))
            .or(this.page.getByLabel(r, { exact: true }));
    };
    textarea = (name: string) => {
        const r = this._resolve(name);
        return this.page
            .getByRole("textbox", { name: r })
            .or(this.page.getByLabel(r))
            .or(this.page.getByPlaceholder(r))
            .or(this.page.locator(`[data-testid*="${r}"]`).locator("textarea, [role='textbox']"))
            .or(this.page.locator(`textarea[data-testid*="${r}"], [role='textbox'][data-testid*="${name}"]`))
            .or(this.page.locator(`xpath=//input[@placeholder="${r}"]`));
    };

    /* ===================== BUTTON ===================== */
    button = (name: string) => {
        const r = this._resolve(name);
        return this.page.getByRole("button", { name: r }).or(this.page.locator("button", { hasText: r }));
        // .or(this.page.getByText(r, { exact: true }));
    };

    /* ===================== DROPDOWN / SELECT ===================== */
    combobox = (name: string) => {
        const r = this._resolve(name);
        return this.page
            .getByRole("combobox", { name: r })
            .or(this.page.getByLabel(r))
            .or(this.page.getByText(r))
            .or(this.page.locator(`xpath=//div[contains(text(), "${r}")]`));
    }; // update later on

    ddlOption = (name: string) => {
        const r = this._resolve(name);
        return this.page
            .getByRole("option", { name: r })
            .or(this.page.getByText(r, { exact: true }))
            .or(this.page.locator(`xpath=//button[contains(text(), "${r}")]`));
    };

    comboboxByLabel = (label: string) => {
        const r = this._resolve(label);
        return this.page.locator(`label:has-text("${r}")`).locator("..").locator('button[role="combobox"]');
    };

    optionByName = (name: string) => {
        const r = this._resolve(name);
        return this.page.getByRole("option", { name: r }).or(this.page.locator(`[role="option"]:has-text("${r}")`));
    };
    /* ===================== RADIO ===================== */
    radioName = (name: string) => {
        const r = this._resolve(name);
        return this.page.getByRole("radio", { name: r }).or(this.page.getByLabel(r));
    };

    radio = (name: string, option: string) => this.page.locator(""); // update later on
    /* ===================== CHECKBOX ===================== */
    checkbox = (name: string) => {
        const r = this._resolve(name);
        return this.page.getByRole("checkbox", { name: r }).or(this.page.getByLabel(r));
    };

    /* ===================== TOGGLE / SWITCH ===================== */
    toggle = (name: string) => {
        const r = this._resolve(name);
        return this.page
            .getByRole("switch", { name: r })
            .or(this.page.getByLabel(r))
            .or(this.page.locator("div").filter({ hasText: r }).locator('svg[data-testid^="toggle-"]'))
            .or(
                this.page
                    .locator("div")
                    .filter({ has: this.page.getByText(r, { exact: true }) })
                    .locator('svg[data-testid^="toggle-"]'),
            );
    };
    /* ===================== MODAL / DIALOG ===================== */
    dialog = (title: string) => {
        const r = this._resolve(title);
        return this.page.getByRole("dialog", { name: r });
    };

    dialogButton = (title: string, button: string) => this.dialog(title).getByRole("button", { name: button });

    /* ===================== ERROR / VALIDATION ===================== */
    alert = (text: string) => this.page.getByRole("alert").filter({ hasText: text }).or(this.page.getByText(text));

    fieldError = (fieldName: string) => this.page.getByLabel(fieldName).locator("..").getByRole("alert");

    /* ===================== TABLE ===================== */
    row = (text: string) => this.page.getByRole("row", { name: text });

    cell = (rowText: string, column: string) => this.row(rowText).getByRole("cell", { name: column });

    /* ===================== TEXT ===================== */
    text = (text: string) => {
        const r = this._resolve(text);
        return this.page.getByText(r, { exact: true });
    };

    containsText = (text: string) => {
        const r = this._resolve(text);
        return this.page.getByText(r);
    };

    /* ===================== LINK ===================== */
    linkCustom = (text: string) =>
        this.page
            .getByRole("link", { name: text })
            .or(this.page.getByRole("button", { name: text }))
            .or(this.page.locator("//span[contains(@class,'link')]", { hasText: text }));

    /* ===================== TAB ===================== */
    tab = (name: string) => this.page.getByRole("tab", { name: new RegExp(name) });

    /* ===================== LINK ===================== */
    title = (text: string) => this.page.getByRole("heading", { name: text, level: 6 });

    /* ===================== HEADER ===================== */
    header = (text: string) => {
        const r = this._resolve(text);
        return this.page.getByRole("heading", { name: r, level: 1 }).or(this.page.locator('[data-testid="headertext"]', { hasText: r }));
    };

    /* ===================== DATA TEST ID ===================== */
    dataTestId = (text: string) => {
        const r = this._resolve(text);
        return this.page.locator(`[data-testid="${r}"]`);
    };

    /* ===================== IMAGE alt ===================== */
    imageAlt = (altText: string) => this.page.getByAltText(altText);

    /* ===================== FILE INPUT ===================== */
    fileInput = () => this.page.locator('input[type="file"]');

    /* ===================== PARAGRAPH ===================== */
    paragraphText = () => this.page.locator("p.text-sm.font-bold, p.mb-2.text-sm");

    /* ===================== CLASS ===================== */
    className = (className: string, index?: number) => {
        const r = this._resolve(className);
        const locator = this.page.locator(`[class*="${r}"]`);
        return typeof index === "number" ? locator.nth(index) : locator;
    };

    classWithText = (className: string, text: string) => {
        const r = this._resolve(className);
        return this.page.locator(`.${r}`, { hasText: text });
    };

    classNameContains = (partial: string) => {
        const r = this._resolve(partial);
        return this.page.locator(`[class*="${r}"]`);
    };
}
