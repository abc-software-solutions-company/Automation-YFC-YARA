import { Page } from "@playwright/test";

export async function captureTokenFromConsentBundle(page: Page): Promise<string> {
    const request = await page.waitForRequest((req) => req.url().includes("/consent-bundle") && !!req.headers()["authorization"], { timeout: 15000 });

    const authHeader = request.headers()["authorization"];

    if (!authHeader) {
        throw new Error("Authorization header not found");
    }

    return authHeader.replace("Bearer ", "");
}
