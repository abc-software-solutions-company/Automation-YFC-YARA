import { When, Then } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";

When("User selects {string} from the {string} dropdown in Get Help", async function (this: CustomWorld, option: string, label: string) {
    await this.getHelpPage.selectDropdown(label, option);
});

When("User clicks on the {string} icon button in Get Help", async function (this: CustomWorld, name: string) {
    await this.getHelpPage.clickIconButton(name);
});

When("User uploads {string} file in Get Help", async function (this: CustomWorld, filePath: string) {
    await this.getHelpPage.uploadFile(filePath);
});

Then("User saves the ticket ID in Get Help", async function (this: CustomWorld) {
    this.ticketId = await this.getHelpPage.getTicketId();
});

Then("User searches the saved ticket ID into the {string} field", async function (this: CustomWorld, field: string) {
    await this.basePage.fillInGeneralInputField(field, this.ticketId!);
    await this.page.keyboard.press("Enter");
    await this.page.waitForTimeout(3000);
});

Then("User verifies the saved ticket ID is visible in Get Help", async function (this: CustomWorld) {
    await this.page.waitForTimeout(3000);
    await this.getHelpPage.verifyTicketId(this.ticketId!);
});
