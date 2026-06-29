import { CustomWorld } from "../../support/world";
import { LoyaltyAdminClient, loyaltyAdminClientFor } from "../../api/loyaltyAdmin/loyaltyAdminClient";
import { adminCountryFor } from "../../api/loyaltyAdmin/config";
import { RejectReasonCode, SubmissionStatus } from "../../api/loyaltyAdmin/submissionClient";

const APPROVE_ALIASES = new Set(["approves", "approve", "approved"]);
const REJECT_ALIASES = new Set(["rejects", "reject", "rejected"]);
const DEFAULT_REJECT_REASON: RejectReasonCode = "unclear_wrong_id_document";

// `document_uploaded` is the immediate post-submit state — a backend "Watermark system" worker
// transitions it to `pending` within ~30-60s (only for valid images: ≥1000x600px JPEG).
// Admin BFF approve/reject reject any record still at `document_uploaded`.
const NON_REVIEWABLE: SubmissionStatus = "document_uploaded";
const POLL_TIMEOUT_MS = 180_000;
const POLL_INTERVAL_MS = 5_000;

function getSubmissionId(world: CustomWorld): string {
    if (!world.submissionId) {
        throw new Error(
            "Admin submission step: no submissionId in world. Run 'User starts watching for KTP submission' before clicking Konfirmasi.",
        );
    }
    return world.submissionId;
}

async function waitUntilReviewable(api: LoyaltyAdminClient, id: string): Promise<SubmissionStatus> {
    const start = Date.now();
    const deadline = start + POLL_TIMEOUT_MS;
    let lastStatus: SubmissionStatus = NON_REVIEWABLE;
    let attempt = 0;
    while (Date.now() < deadline) {
        attempt++;
        const submission = await api.getSubmission(id);
        lastStatus = submission.status;
        const elapsed = ((Date.now() - start) / 1000).toFixed(0);
        console.log(`  [poll #${attempt} +${elapsed}s] submission ${id} status="${lastStatus}" updated_by="${submission.updated_by ?? "<none>"}"`);
        if (lastStatus !== NON_REVIEWABLE) return lastStatus;
        await new Promise((r) => setTimeout(r, POLL_INTERVAL_MS));
    }
    throw new Error(
        `Submission ${id} stuck at status "${lastStatus}" after ${POLL_TIMEOUT_MS / 1000}s — Watermark worker did not transition the record. Likely caused by an invalid KTP image (too small / wrong format / fails OCR).`,
    );
}

export async function actOnSubmittedKTP(world: CustomWorld, status: string, reason: string): Promise<void> {
    const id = getSubmissionId(world);
    const api = loyaltyAdminClientFor(adminCountryFor(world));
    const reviewableStatus = await waitUntilReviewable(api, id);
    console.log(`✓ Submission ${id} reached reviewable status "${reviewableStatus}"`);
    const action = status.toLowerCase();
    if (APPROVE_ALIASES.has(action)) {
        await api.approveSubmission(id);
        console.log(`✓ Approved farmer-document-submission ${id}`);
        return;
    }
    if (REJECT_ALIASES.has(action)) {
        const code = (reason || DEFAULT_REJECT_REASON) as RejectReasonCode;
        await api.rejectSubmission(id, code);
        console.log(`✓ Rejected farmer-document-submission ${id} (reason=${code})`);
        return;
    }
    throw new Error(`Unsupported admin status "${status}". Expected "approves" or "rejects".`);
}
