export const ApiEndpoints = {
    // Discount endponts
    createDiscount: "/discounts/create",
    discount: "/discounts",
    discountID: "/discounts/:id",
    cloneDiscount: "/discounts/:id/clone",
    adminGetListDiscounts: "/discounts",

    // Order endpoints
    orders: "/orders",
    ordersQrCode: "/orders/:id/qrcode",
    orderID: "/orders/:id",
    assistedOrderMP: "/orders/assistedOrder",
    assistedOrderLS: "/v1/online-shop/orders/assistedOrder",
    getOrderID: "orders/:id/context",
    b2bDirectOrder: "/ros/orders",
    b2bDirectlOrderAction: "/ros/orders/:id",

    // FL endpoints
    farmerDocumentSubmission: "/farmer-document-submission",

    // ACL token
    aclToken: "acl/test-token",
} as const;

export type ApiEndpointKey = keyof typeof ApiEndpoints;
