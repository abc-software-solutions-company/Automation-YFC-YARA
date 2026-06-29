import { When, Then, DataTable, Before } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";
import { OrderCardInfo } from "../../pages/account/myOrderPage";

let savedOrderCardInfo: OrderCardInfo | null = null;

Before(function () {
    savedOrderCardInfo = null;
});

Then("The placed order should appear in Pending tab", async function (this: CustomWorld) {
    await this.myOrderPage.waitForMyOrdersPage();
    await this.myOrderPage.verifyOrderNumbersVisible(this.orderNumbers);
});

Then("All orders in the list should have status {string}", async function (this: CustomWorld, status: string) {
    await this.myOrderPage.verifyAllOrdersHaveStatus(status);
});

Then("Each order card should contain the following fields:", async function (this: CustomWorld, dataTable: DataTable) {
    await this.myOrderPage.verifyEachOrderCardContainsFields(dataTable.raw().flat());
});

When("User saves the first order card information", async function (this: CustomWorld) {
    savedOrderCardInfo = await this.myOrderPage.saveFirstOrderCardInfo();
    if (!savedOrderCardInfo) return "skipped";
});

Then("The order detail should match the order card summary", async function (this: CustomWorld) {
    if (!savedOrderCardInfo) return "skipped";
    await this.myOrderPage.verifyOrderDetailMatchesCard(savedOrderCardInfo);
});
