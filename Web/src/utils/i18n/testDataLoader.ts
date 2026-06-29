import fs from "fs";
import path from "path";
import { Page } from "@playwright/test";
import { textAliases } from "./textAliases";

export type TestDataStore = Record<string, Record<string, string>>;

function loadFile(filePath: string, cache: Record<string, TestDataStore>): TestDataStore {
    if (!cache[filePath]) {
        const fullPath = path.join(process.cwd(), "src/data", `${filePath}.json`);
        cache[filePath] = JSON.parse(fs.readFileSync(fullPath, "utf-8"));
    }
    return cache[filePath];
}

export class TestDataLoader {
    static captureLocale(page: Page): string | undefined {
        const locale = page.url().split("/")[3];
        return locale;
    }

    static resolve(value: string, locale: string, cache: Record<string, TestDataStore>): string {
        if (value.startsWith("http://") || value.startsWith("https://")) return value;

        // check data in the Alis first
        const aliasKey = textAliases[value];
        // if key doesn't exist in the Aliases, use the original value as the key to resolve the text
        if (!aliasKey) {
            return value;
        }
        // if the alias value doesn't contain a dot, it's not an i18n key, return it directly
        if (!aliasKey.includes(".")) {
            return aliasKey;
        }
        // else
        const normalizedKey = aliasKey.includes("/") ? aliasKey : `i18n/${aliasKey}`;

        const match = normalizedKey.match(/^(.+)\/([^/]+)\.([^.]+)$/);
        if (!match) return aliasKey;

        let [, filePath, group, field] = match;

        if (filePath === "i18n") {
            if (!locale) throw new Error(`Locale not set — cannot resolve i18n key "${value}"`);
            const langCode = locale.split("-")[0];

            const resolved = loadFile(`i18n/${langCode}`, cache)[group]?.[field];
            if (resolved) return resolved;

            // fallback to en.json
            const fallback = loadFile("i18n/en", cache)[group]?.[field];
            if (!fallback) throw new Error(`i18n key "${value}" not found in "${langCode}" or "en"`);
            return fallback;
        }

        const data = loadFile(filePath, cache);
        const resolved = data[group]?.[field];
        if (!resolved) throw new Error(`Key "${value}" not found`);
        return resolved;
    }
}
