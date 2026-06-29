import { Before, After, BeforeAll, AfterAll } from "@cucumber/cucumber";
import { setDefaultTimeout } from "@cucumber/cucumber";
import { chromium, Browser } from "@playwright/test";
import { CustomWorld } from "./world";

setDefaultTimeout(120 * 1000);

Before(async function (this: CustomWorld) {
    // 1. Launch browser per scenario
    this.browser = await chromium.launch({
        headless: false,
    });
});

After(async function (this: CustomWorld) {
    if (this.page) {
        await this.page.close();
    }
    if (this.context) {
        await this.context.close();
    }
    if (this.browser) {
        await this.browser.close();
    }
});
