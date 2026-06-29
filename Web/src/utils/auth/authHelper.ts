import path from "path";
import fs from "fs";
import { BrowserContext, chromium, Page } from "@playwright/test";
import { config } from "../../support/config";
import { login, loginWithPhone } from "../../pages/login/loginPage";

export function getStoragePath(countryCode: string): string {
    return path.resolve(process.cwd(), `.auth/storageSession-${countryCode}.json`);
}
export function getStoragePathWithPhone(countryCode: string, phone: string): string {
    return path.resolve(process.cwd(), `.auth/storageSession-${countryCode}-${phone}.json`);
}
export type SessionStatus = "VALID" | "RELOGGED";
export async function verifySession(context: BrowserContext, page: Page, countryName: string, language: string): Promise<SessionStatus> {
    await page.goto(config.baseUrl, { waitUntil: "domcontentloaded" });
    const cookies = await context.cookies();
    const sessionCookie = cookies.find((c) => c.name === "bodega_session");
    const storagePath = getStoragePath(countryName);
    if (sessionCookie) {
        return "VALID";
    } else {
        if (fs.existsSync(storagePath)) {
            fs.unlinkSync(storagePath);
        }
        await context.clearCookies();
        await page.evaluate(() => localStorage.clear());
        await page.goto(config.baseUrl, { waitUntil: "domcontentloaded" });
        await login(page, countryName, language);
        await context.storageState({ path: storagePath });
        return "RELOGGED";
    }
}

export async function verifySessionWithPhone(context: BrowserContext, page: Page, countryName: string, language: string, phone: string): Promise<SessionStatus> {
    await page.goto(config.baseUrl, { waitUntil: "domcontentloaded" });
    const cookies = await context.cookies();
    const sessionCookie = cookies.find((c) => c.name === "bodega_session");
    const storagePath = getStoragePathWithPhone(countryName, phone);
    if (sessionCookie) {
        return "VALID";
    } else {
        if (fs.existsSync(storagePath)) {
            fs.unlinkSync(storagePath);
        }
        await context.clearCookies();
        await page.evaluate(() => localStorage.clear());
        await page.goto(config.baseUrl, { waitUntil: "domcontentloaded" });
        await loginWithPhone(page, countryName, language, phone);
        await context.storageState({ path: storagePath });
        return "RELOGGED";
    }
}
