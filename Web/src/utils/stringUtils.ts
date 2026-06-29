export function splitString(text: string): string[] {
    return text
        .split(",")
        .map((t) => t.trim())
        .filter(Boolean);
}
