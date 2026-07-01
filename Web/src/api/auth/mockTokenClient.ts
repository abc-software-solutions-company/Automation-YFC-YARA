// YC preprod-only OAuth backdoor: impersonates any user via `phone_number` param.
// Returns a JWT with that user's identity (farmer / retailer / etc.) accepted by marketplace + farmer services.
//
// All config is read from env vars (loaded from .env locally, or from CI secret/pipeline
// variables in CI/CD). See .env.example. MOCK_TOKEN_CLIENT_SECRET must never be committed.

function requireEnv(name: string): string {
    const value = process.env[name];
    if (!value) {
        throw new Error(`${name} not set. Add it to .env locally (see .env.example) or to your CI/CD pipeline variables.`);
    }
    return value;
}

const tokenCache = new Map<string, { token: string; expiresAt: number }>();

/**
 * Get a JWT impersonating the user with the given phone number.
 * Tokens cached in-memory until 60s before expiry.
 */
export async function getMockToken(phoneNumber: string): Promise<string> {
    const cached = tokenCache.get(phoneNumber);
    if (cached && cached.expiresAt > Date.now() + 60_000) return cached.token;

    const body = new URLSearchParams({
        grant_type: "client_credentials",
        client_id: requireEnv("MOCK_TOKEN_CLIENT_ID"),
        client_secret: requireEnv("MOCK_TOKEN_CLIENT_SECRET"),
        scope: requireEnv("MOCK_TOKEN_SCOPE"),
        phone_number: phoneNumber,
    });
    const res = await fetch(requireEnv("MOCK_TOKEN_URL"), {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body,
    });
    if (!res.ok) {
        throw new Error(`getMockToken(${phoneNumber}) → HTTP ${res.status}\n${await res.text()}`);
    }
    const data = (await res.json()) as { access_token: string; expires_in: number };
    tokenCache.set(phoneNumber, {
        token: data.access_token,
        expiresAt: Date.now() + data.expires_in * 1000,
    });
    return data.access_token;
}
