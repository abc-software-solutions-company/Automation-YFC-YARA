// import { getMockToken } from "../auth/mockTokenClient";
// import { B2cMarketplaceClient } from "./b2cClient";
// import { OrderDetailResponse } from "./b2cTypes";

// export function buildFulfillPayload(order: OrderDetailResponse): Record<string, unknown> {
//     const products = order.orderDetails.map((d) => ({
//         isEdited: false,
//         productId: d.productId,
//         orderedQuantity: d.orderedQuantity,
//         fulfilledQuantity: d.orderedQuantity,
//         mrp: d.mrp,
//         sellingPrice: d.sellingPrice,
//         productName: d.productName,
//         variantName: d.variantName,
//         productFamilyName: d.productFamilyName,
//         productSize: d.productSize,
//         isYaraProduct: d.isYaraProduct,
//         photo: d.photo,
//         metric: d.metric,
//         packagingType: d.packagingType,
//         volume: d.volume,
//         form: d.metric === "L" ? "liquid" : "solid",
//         error: false,
//         stockAvailable: 1000,
//     }));
//     const fulfilledMRP = products.reduce((sum, p) => sum + p.sellingPrice * p.orderedQuantity, 0);
//     return {
//         products,
//         action: "fulfill",
//         fulfilledMRP,
//         discount: 0,
//         sellerId: order.sellerId,
//         sellerShopId: order.sellerShopId,
//         paymentType: "Cash",
//         payerPhoneNumber: order.placedBy?.phoneNumber ?? "",
//         paybillOrTillNumber: "",
//         discountId: order.discountId,
//         couponId: order.couponId,
//         farmerDiscount: order.discountValue ?? 0,
//         ycProducts: products.map((p) => ({ productId: p.productId, QRList: [] })),
//         couponCode: order.couponCode,
//     };
// }

// export async function fulfillB2cOrderAsRetailer(opts: { orderId: string; retailerPhone: string; country?: string }): Promise<void> {
//     const token = await getMockToken(opts.retailerPhone);
//     const client = new B2cMarketplaceClient(token, opts.country);
//     const order = await client.getOrder(opts.orderId);
//     const payload = buildFulfillPayload(order);
//     await client.fulfillOrder(opts.orderId, payload);
// }
