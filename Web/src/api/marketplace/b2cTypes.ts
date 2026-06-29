export interface OrderLineItem {
    productId: string;
    orderedQuantity: number;
    mrp: number;
    sellingPrice: number;
    productName: string;
    variantName: string;
    productFamilyName: string;
    productSize: string;
    isYaraProduct: boolean;
    photo?: string;
    metric: string;
    packagingType: string;
    volume: number;
}

export interface OrderDetailResponse {
    orderId: string;
    OrderStatus: string;
    sellerId: string;
    sellerShopId: string;
    couponCode?: string;
    couponId?: string;
    discountId?: string;
    discountValue?: number;
    placedBy?: { phoneNumber?: string };
    orderDetails: OrderLineItem[];
}
