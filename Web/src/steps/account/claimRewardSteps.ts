import { When } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";

When("User uploads KTP document", async function (this: CustomWorld) {
    await this.claimRewardPage.uploadKTPDocument();
});

When("User starts watching for KTP submission", function (this: CustomWorld) {
    this.claimRewardPage.watchForSubmissionId((id) => {
        this.submissionId = id;
    });
});

When("User selects first option from {string} dropdown", async function (this: CustomWorld, label: string) {
    await this.claimRewardPage.selectFirstDropdownOption(label);
});

When("User opens claim form by edit icon for {string}", async function (this: CustomWorld, claimText: string) {
    await this.claimRewardPage.openClaimFormByEditIcon(claimText);
});
