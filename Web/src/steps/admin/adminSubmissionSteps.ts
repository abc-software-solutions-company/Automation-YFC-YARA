import { Given } from "@cucumber/cucumber";
import { CustomWorld } from "../../support/world";
import { actOnSubmittedKTP } from "./adminSubmissionFlow";

// Single parametric step. `status` ∈ {approves, rejects}. `reason` only used for reject;
// can be empty (default reason is sent in that case).
Given(
    "Admin {string} the submitted KTP with {string}",
    async function (this: CustomWorld, status: string, reason: string) {
        await actOnSubmittedKTP(this, status, reason);
    },
);
