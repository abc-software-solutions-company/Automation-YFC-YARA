export type RejectReasonCode = "unclear_wrong_id_document" | "expired_id_document" | "name_mismatch" | "id_number_mismatch";

export type SubmissionStatus = "document_uploaded" | "pending" | "verified" | "rejected";

export interface SubmissionDetail {
    id: string;
    yara_user_id: string;
    document_id: string;
    document_type: string;
    status: SubmissionStatus;
    metadata: { farmerName?: string; nationalId?: string; phoneNumber?: string };
    remark?: { code?: string; display_text?: string; language?: string };
    created_at: string;
    updated_at: string;
    updated_by?: string;
}
