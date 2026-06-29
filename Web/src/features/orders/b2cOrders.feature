@smokeorder
Feature: B2C order flow

    Background:
    @b2c_emptycart
    Scenario: Verify the shopping cart is empty
        Given User log in with phone number "<Phone number>" in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the element of class "cart icon"
        Then User verifies the "<Message>" text is "visible"
        Examples:
            | Phone number | Country  | Language | Message                    |
            | 6656841215   | Thailand |          | รถเข็นของคุณยังไม่มีสินค้า |
            | 6606600674   | India    | English  | Your cart is empty         |

    @b2c
    Scenario Outline: Farmer places order successfully for countries India, Keyna, Thailand, Malaysia, VietNam
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the element with class containing "header_addressSecondaryLabel"
        And User clicks on the "Change location" button
        And User enters "<Capital>" into the "Placeholder in location search box" field and selects from dropdown
        And User clicks on the "Confirm location" button
        When User clicks on "View all button" in the "Stores near you section" section
        And User enters "<Shop name>" into the "Search box" field
        And User presses the "Enter" key
        And User selects the "<Shop name>" shop
        And User adds products to cart:
            | Product    | Quantity |
            | <Product1> | <Qty1>   |
            | <Product2> | <Qty2>   |

        When User clicks on the element of class "cart icon"
        # Then User ensures discount state is "<Coupon state>"
        Then User verifies cart summary

        When User clicks on the "Place Order" button
        And User clicks on the "Yes, Confirm" button
        Then User should be redirected to order success page
        And User verifies the "<Place completed text>" text is "visible"
        Then Order number should be displayed on success page

        When User goes to "My orders" page
        Then The placed order should appear in Pending tab

        Examples:
            | Country  | Language | Capital      | Shop name       | Product1                  | Qty1 | Product2                  | Qty2 | Coupon state | Place completed text |
            | Thailand |          | Bangkok      | FC TH SubDealer | Product test auto 01      | 2    | Product test auto 02      | 10   | NONE         | ส่งคำสั่งซื้อสำเร็จ! |
            | India    | English  | Delhi        | AUTO SHOP IN    | Auto product test IN 2    | 3    | Auto product test IN 03   | 5    | NONE         | Order placed!        |
            | Kenya    |          | Nairobi      | yfc auto shop   | Product automation YFC 01 | 2    | Product automation YFC 02 | 4    | NONE         | Order placed!        |
            | Malaysia | English  | Kuala Lumpur | Diem bussiness  | Product auto YFC 01       | 2    | Product auto YFC 02       | 4    | NONE         | Order placed!        |
    # | Thailand |          | Bangkok      | FC TH SubDealer | Product test auto 01      | 2    | Product test auto 02      | 10   | AVAILABLE    | ส่งคำสั่งซื้อสำเร็จ! |
    # | Thailand |          | Bangkok      | FC TH SubDealer | Product test auto 01      | 2    | Product test auto 02      | 10   | APPLIED      | ส่งคำสั่งซื้อสำเร็จ! |
    # | India    | English  | Mumbai       | AUTO SHOP IN    | Auto product test IN 2    | 3    | Auto product test IN 03   | 5    | AVAILABLE    | Order placed!        |
    # | India    | English  | Mumbai       | AUTO SHOP IN    | Auto product test IN 2    | 3    | Auto product test IN 03   | 5    | APPLIED      | Order placed!        |
    # | Kenya    |          | Nairobi      | yfc auto shop   | Product automation YFC 01 | 2    | Product automation YFC 02 | 4    | AVAILABLE    | Order placed!        |
    # | Kenya    |          | Nairobi      | yfc auto shop   | Product automation YFC 01 | 2    | Product automation YFC 02 | 4    | APPLIED      | Order placed!        |
    # | Malaysia | English  | Kuala Lumpur | Diem bussiness  | Product auto YFC 01           | 2    | Product auto YFC 02      | 4    | AVAILABLE    | Order placed!        |
    # | Malaysia | English  | Kuala Lumpur | Diem bussiness  | Product auto YFC 01           | 2    | Product auto YFC 02      | 4    | APPLIED      | Order placed!        |

    @b2c_indonesia
    Scenario Outline: Farmer places order delivery successfully on the Indonesia country
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the element with class containing "header_addressSecondaryLabel"
        And User clicks on the "Change location" button
        And User enters "<Capital>" into the "Placeholder in location search box" field and selects from dropdown
        And User clicks on the "Confirm location" button
        When User clicks on "View all button" in the "Stores near you section" section
        And User enters "<Shop name>" into the "Search box" field
        And User presses the "Enter" key
        And User selects the "<Shop name>" shop
        And User adds products to cart:
            | Product    | Quantity |
            | <Product1> | <Qty1>   |
            | <Product2> | <Qty2>   |

        When User clicks on the element of class "cart icon"
        When User clicks on the "<Delivery option>" section
        # Then User ensures discount state is "<Coupon state>"

        When User clicks on the "Place Order" button
        And User clicks on the "Yes, Confirm" button
        Then User should be redirected to order success page
        And User verifies the "<Place completed text>" text is "visible"
        Then Order number should be displayed on success page

        When User goes to "My orders" page
        Then The placed order should appear in Pending tab

        Examples:
            | Country   | Language | Capital | Shop name  | Product1      | Qty1 | Product2    | Qty2 | Delivery option     | Coupon state | Place completed text |
            | Indonesia |          | Jakarta | ID VV Shop | CALCINIT (25) | 2    | PALMAE (50) | 3    | Pengambilan sendiri | NONE         | Pesanan dibuat!      |
            | Indonesia |          | Jakarta | ID VV Shop | CALCINIT (25) | 2    | PALMAE (50) | 3    | Dikenakan biaya     | NONE         | Pesanan dibuat!      |

    @b2c_tanzania
    Scenario Outline: Farmer places order on the Tanzania country successfully
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the element with class containing "header_addressSecondaryLabel"
        And User clicks on the "Change location" button
        And User enters "<Capital>" into the "Placeholder in location search box" field and selects from dropdown
        And User clicks on the "Confirm location" button
        When User clicks on "View all button" in the "Stores near you section" section
        And User enters "<Shop name>" into the "Search box" field
        And User presses the "Enter" key
        And User selects the "<Shop name>" shop

        When User selects the "<Product1>" product
        And User clicks on the "Add to Cart" button

        When User clicks on the element of class "cart icon"
        # Then User ensures discount state is "<Coupon state>"
        Then User verifies cart summary

        When User clicks on the "Place Order" button
        And User clicks on the "Yes, Confirm" button
        Then User should be redirected to order success page
        And User verifies the "<Place completed text>" text is "visible"
        Then Order number should be displayed on success page

        When User goes to "My orders" page
        Then The placed order should appear in Pending tab

        Examples:
            | Country  | Language | Capital | Shop name          | Product1   | Product2 | Coupon state | Place completed text |
            | Tanzania | English  | Dodoma  | FC Automation Shop | PowerBoost | Sulfan   | NONE         | Order placed!        |