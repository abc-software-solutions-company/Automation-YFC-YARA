import { Page, expect } from "@playwright/test";
import { BasePage } from "../core/basePage";

export class ShopPage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    //#region Locators
    productName = (name: string) => this.page.locator(`xpath=//div/div/p[contains(normalize-space(.),"${name}")]`);
    productCard = (name: string) => this.page.locator('[class*="ProductCard_card"]').filter({ hasText: name }).first();
    itemQuantity = this.page.getByTestId("itemQuantity");
    addIcon = this.page.getByTestId("AddIcon");
    addToCartBtn = this.page.getByTestId("addToCartBtn");
    //#endregion

    async selectProduct(name: string): Promise<void> {
        await this.pageAlready();
        let locator = this.productName(name);
        await locator.waitFor({ state: "visible" });
        await locator.click();
        await this.pageAlready();
    }

    async addProductToCart(productName: string, productQuantity: number): Promise<void> {
        await this.pageAlready();
        const card = this.productCard(productName);
        await card.waitFor({ state: "visible" });

        const quantityLocator = card.locator(this.itemQuantity);

        if (await quantityLocator.isVisible().catch(() => false)) {
            const currentQty = Number((await quantityLocator.textContent()) ?? "0");
            const addBtn = card.locator(this.addIcon);

            for (let i = currentQty; i < productQuantity; i++) {
                await addBtn.click();
            }
        } else {
            const addBtn = card.locator(this.addToCartBtn);
            await addBtn.click();

            if (productQuantity > 1) {
                const addIconBtn = card.locator(this.addIcon);

                for (let i = 1; i < productQuantity; i++) {
                    await addIconBtn.click();
                }
            }
        }

        // await expect(card.locator(this.itemQuantity)).toHaveText(productQuantity.toString());
    }
}
