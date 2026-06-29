import { Page } from "@playwright/test";
import { BasePage } from "../core/basePage";

export class SearchPage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    //#region Locators
    // Results
    productCards = () => this.loc.classNameContains("product search card");
    searchResult = (name: string) => this.productCards().filter({ hasText: name }).first().locator("a");
    //#endregion

    async clickSearchResult(productName: string): Promise<void> {
        await this.searchResult(productName).click();
        await this.pageAlready();
    }
}
