import { OrderDetailResponse } from "./b2cTypes";

// B2C online-shop orders (incl. loyalty-campaign orders) live on the loyalty service.
// Both the retailer's order detail (GET) and fulfillment (POST) hit the same endpoint;
// the old marketplace endpoints (/orders, /farmer/orders) return 403 for these orders.
const YC_LOYALTY_SERVICE: Record<string, string> = {
    Indonesia: "https://yc-loyalty-id.preprod.apac.yaradigitallabs.io",
    Thailand: "https://yc-loyalty-th.preprod.apac.yaradigitallabs.io",
};

export class B2cMarketplaceClient {
    private baseUrl: string;

    constructor(
        private token: string,
        private country: string = "Indonesia",
    ) {
        const base = YC_LOYALTY_SERVICE[country];
        if (!base) throw new Error(`No online-shop base URL for country "${country}". Add to YC_LOYALTY_SERVICE in b2cClient.ts.`);
        this.baseUrl = base;
    }

    private headers(): Record<string, string> {
        return {
            Accept: "application/json",
            "Content-Type": "application/json",
            Authorization: `Bearer ${this.token}`,
            "x-app-platform": "web",
            "x-country-code": this.country,
        };
    }

    async getOrder(orderId: string): Promise<OrderDetailResponse> {
        const res = await fetch(`${this.baseUrl}/v1/online-shop/orders/${orderId}`, { headers: this.headers() });
        if (!res.ok) throw new Error(`getOrder(${orderId}) → HTTP ${res.status}\n${await res.text()}`);
        // The order object is returned at the top level (NOT wrapped in { data }).
        return (await res.json()) as OrderDetailResponse;
    }

    async fulfillOrder(orderId: string, payload: unknown): Promise<void> {
        const res = await fetch(`${this.baseUrl}/v1/online-shop/orders/${orderId}`, {
            method: "PUT",
            headers: this.headers(),
            body: JSON.stringify(payload),
        });
        if (!res.ok) throw new Error(`fulfillOrder(${orderId}) → HTTP ${res.status}\n${await res.text()}`);
    }
}
