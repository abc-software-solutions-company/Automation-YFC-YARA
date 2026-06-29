import { Given, When, Then } from "@cucumber/cucumber";
import { CustomWorld } from "@support/world";

Given("User grants geolocation permission", async function (this: CustomWorld) {
    await this.storesNearYouPage.grantGeolocationPermission();
});

When("User sets browser geolocation to {float} and {float}", async function (this: CustomWorld, lat: number, lng: number) {
    this.currentLat = lat;
    this.currentLng = lng;

    await this.storesNearYouPage.setGeolocation(lat, lng);
});

Then("Store {string} distance should be between {int}km and {int}km", async function (this: CustomWorld, name: string, min: number, max: number) {
    await this.storesNearYouPage.verifyDistance(name, min, max);
});
