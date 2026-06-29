@myOrder
Feature: My Orders Page

    @myOrder_pageContent
    Scenario Outline: Verify My Orders page displays all required fields
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "My orders" page
        Then The page should contain the following fields:
            | <Title page>     |
            | <Pending tab>    |
            | <Past order tab> |

        Examples:
            | Country   | Language | Title page   | Pending tab | Past order tab       |
            | Malaysia  | English  | My orders    | Pending     | Past Orders          |
            | Thailand  |          | คำสั่งของฉัน | รอดำเนินการ | คําสั่งซื้อที่ผ่านมา |
            | VietNam   | English  | My orders    | Pending     | Past Orders          |
            | Kenya     |          | My orders    | Pending     | Past Orders          |
            | India     | English  | My orders    | Pending     | Past Orders          |
            | Tanzania  | English  | My orders    | Pending     | Past Orders          |
            | Indonesia |          | Pesanan saya | Tertunda    | Pesanan Sebelumnya   |

    @myOrder_pendingTab
    Scenario Outline: Verify orders in Pending tab all have Pending status
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "My orders" page
        And User clicks on the "Pending tab" button
        Then All orders in the list should have status "<Pending status>"

        Examples:
            | Country   | Language | Pending status |
            | Malaysia  | English  | Pending        |
            | Thailand  |          | รอดำเนินการ    |
            | VietNam   | English  | Pending        |
            | Kenya     |          | Pending        |
            | India     | English  | Pending        |
            | Tanzania  | English  | Pending        |
            | Indonesia |          | Tertunda       |

    @myOrder_pendingTab_orderCard
    Scenario Outline: Verify order card info in Pending tab
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "My orders" page
        And User clicks on the "Pending tab" button
        Then Each order card should contain the following fields:
            | <Amount paid label> |
            | <Order summary>     |
            | <View order button> |

        Examples:
            | Country   | Language | Amount paid label         | Order summary     | View order button |
            | Malaysia  | English  | Amount payable            | Order summary     | View order        |
            | Thailand  |          | จํานวนเงินที่ต้องชําระ    | สรุปคำสั่งซื้อ    | ดูคำสั่งซื้อ      |
            | VietNam   | English  | Amount payable            | Order summary     | View order        |
            | Kenya     |          | Amount payable            | Order summary     | View order        |
            | India     | English  | Amount payable            | Order summary     | View order        |
            | Tanzania  | English  | Amount payable            | Order summary     | View order        |
            | Indonesia |          | Jumlah yang harus dibayar | Ringkasan pesanan | Lihat pesanan     |

    @myOrder_pastOrdersTab
    Scenario Outline: Verify orders in Past Orders tab all have Delivered status
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "My orders" page
        And User clicks on the "Past order tab" button
        Then All orders in the list should have status "<Delivered status>"

        Examples:
            | Country   | Language | Delivered status |
            | Malaysia  | English  | Delivered        |
            | Thailand  |          | ส่งแล้ว          |
            | VietNam   | English  | Delivered        |
            | Kenya     |          | Delivered        |
            | India     | English  | Delivered        |
            | Tanzania  | English  | Delivered        |
            | Indonesia |          | Terkirim         |

    @myOrder_pastOrdersTab_orderCard
    Scenario Outline: Verify order card info in Past Orders tab
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "My orders" page
        And User clicks on the "Past order tab" button
        Then Each order card should contain the following fields:
            | <Amount paid label> |
            | <Order summary>     |
            | <View order button> |

        Examples:
            | Country   | Language | Amount paid label    | Order summary     | View order button |
            | Malaysia  | English  | Amount paid          | Order summary     | View order        |
            | Thailand  |          | จำนวนเงินที่ชำระแล้ว | สรุปคำสั่งซื้อ    | ดูคำสั่งซื้อ      |
            | VietNam   | English  | Amount paid          | Order summary     | View order        |
            | Kenya     |          | Amount paid          | Order summary     | View order        |
            | India     | English  | Amount paid          | Order summary     | View order        |
            | Tanzania  | English  | Amount paid          | Order summary     | View order        |
            | Indonesia |          | Jumlah yang dibayar  | Ringkasan pesanan | Lihat pesanan     |

    @myOrder_viewOrderDetail
    Scenario Outline: View order detail and verify info matches order card summary
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "My orders" page
        And User clicks on the "Past order tab" button
        And User saves the first order card information
        And User clicks on the "View order button" button
        Then The order detail should match the order card summary

        Examples:
            | Country   | Language |
            | Malaysia  | English  |
            | Thailand  |          |
            | VietNam   | English  |
            | Kenya     |          |
            | India     | English  |
            | Tanzania  | English  |
            | Indonesia |          |

    @myOrder_viewOrderDetail_content
    Scenario Outline: Verify order detail page displays all required sections
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "My orders" page
        And User clicks on the "Past order tab" button
        And User clicks on the "View order button" button
        Then The page should contain the following fields:
            | <Back to orders> |
            | <Item>           |
            | <Size>           |
            | <Qty>            |
            | <Shop Price>     |
            | <Payment Method> |
            | <Final total>    |

        Examples:
            | Country   | Language | Back to orders          | Item   | Size   | Qty    | Shop Price  | Payment Method    | Final total   |
            | Malaysia  | English  | Back to orders          | Item   | Size   | Qty    | Shop Price  | Payment Method    | Final total   |
            | Thailand  |          | ย้อนกลับไปที่คำสั่งซื้อ | สินค้า | ขนาด   | จำนวน  | ราคาที่ร้าน | วิธีการชำระเงิน   | ยอดรวมสุดท้าย |
            | VietNam   | English  | Back to orders          | Item   | Size   | Qty    | Shop Price  | Payment Method    | Final total   |
            | Kenya     |          | Back to orders          | Item   | Size   | Qty    | Shop Price  | Payment Method    | Final total   |
            | India     | English  | Back to orders          | Item   | Size   | Qty    | Shop Price  | Payment Method    | Final total   |
            | Tanzania  | English  | Back to orders          | Item   | Size   | Qty    | Shop Price  | Payment Method    | Final total   |
            | Indonesia |          | Kembali ke pesanan      | Item   | Ukuran | Jumlah | Harga toko  | Metode Pembayaran | Total akhir   |

    @myOrder_backNavigation
    Scenario Outline: User clicks back button to navigate away from My Orders
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "My orders" page
        And User goes back
        Then User verifies the "<Title page>" text is "hidden"

        Examples:
            | Country   | Language | Title page       |
            | Malaysia  | English  | My orders        |
            | Thailand  |          | คำสั่งซื้อของฉัน |
            | VietNam   | English  | My orders        |
            | Kenya     |          | My orders        |
            | India     | English  | My orders        |
            | Tanzania  | English  | My orders        |
            | Indonesia |          | Pesanan saya     |
