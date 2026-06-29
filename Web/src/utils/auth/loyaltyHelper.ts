import { Page } from "@playwright/test";

const USER_UUID_CLAIM = "http://farmweather/user-uuid";

function decodeJwtUserUuid(jwt: string): string | null {
    const parts = jwt.split(".");
    if (parts.length !== 3) return null;
    try {
        const payload = JSON.parse(Buffer.from(parts[1], "base64").toString("utf8"));
        const value = payload[USER_UUID_CLAIM];
        return typeof value === "string" ? value : null;
    } catch {
        return null;
    }
}

export async function extractLoyaltyIdFromSession(page: Page): Promise<string> {
    const storage = await page.evaluate(() => {
        const all: Record<string, string> = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            if (key) all[key] = localStorage.getItem(key) ?? "";
        }
        return all;
    });

    for (const value of Object.values(storage)) {
        if (!value.includes("eyJ")) continue;
        const jwt = value.startsWith("eyJ") ? value : value.match(/eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+/)?.[0];
        if (!jwt) continue;
        const id = decodeJwtUserUuid(jwt);
        if (id) return id;
    }

    const cookies = await page.context().cookies();
    for (const cookie of cookies) {
        if (!cookie.value.startsWith("eyJ")) continue;
        const id = decodeJwtUserUuid(cookie.value);
        if (id) return id;
    }

    throw new Error(`Could not extract loyalty_id (claim "${USER_UUID_CLAIM}") from session storage or cookies. Inspect localStorage/cookies after login to find the JWT.`);
}
