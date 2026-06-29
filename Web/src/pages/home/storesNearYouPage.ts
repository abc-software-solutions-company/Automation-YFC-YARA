import { expect, Page } from "@playwright/test";
import { BasePage } from "../core/basePage";

export class StoresNearYouPage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    storeCard = (name: string) => this.page.locator(`xpath=//div/div/p[contains(text(), "${name}")]`);

    async grantGeolocationPermission() {
        await this.page.context().grantPermissions(["geolocation"]);
    }

    async setGeolocation(lat: number, lng: number) {
        await this.page.context().setGeolocation({
            latitude: lat,
            longitude: lng,
        });
    }

    async verifyDistance(name: string, min: number, max: number) {
        const text = await this.storeCard(name).innerText();

        const km = parseFloat(text.match(/(\d+(\.\d+)?)\s*km/)?.[1] || "0");

        expect(km).toBeGreaterThanOrEqual(min);
        expect(km).toBeLessThanOrEqual(max);
    }
}
