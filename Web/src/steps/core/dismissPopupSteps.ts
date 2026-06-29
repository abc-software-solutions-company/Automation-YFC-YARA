import { When } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";

When("User dismisses popup if shown", async function (this: CustomWorld) {
    await this.basePage.dismissPopupIfShown();
});
