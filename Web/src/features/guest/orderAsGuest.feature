Feature: Access System
    Background:

    @OrderAsGuest
    Scenario: Verify that the user can access System without login
        Given User goes to landing page
        When User selects on the '<Country>' country and select English
        When User clicks on the "Continue As Guest" button
        Then User verify the "Add location" text exactly is "visible"
        When User clicks on the element of data-testid "x icon"
        And User enters "<Capital>" into the "Placeholder in location search box" field
        And User selects the "<Capital>" option from the dropdown
        And User clicks on the "Confirm location" button
        Then User clicks on the "Store tab" button

        # filter the shop name
        And User enters "<Shop name>" into the "Search box" field
        And User clicks on the "<Shop name>" section

        # Select product
        And User clicks on the "<Product name>" section
        When User verify the "<Product detail page>" header is "visible"
        And User clicks on the element of data-testid "plus icon"
        And User clicks on the "Add to Cart" button
        And User verifies the "cart number" class contains value "1"

        # Go to cart page
        When User clicks on the element of class "cart number"
        And User clicks on the "Sign up / Login button" button
        Then User verifies the image with alt text "Yara FarmCare logo" is visible

        # Login
        Then User verify the "Send code via SMS" button is "<SMS button status>"
        And User verify the "Send code via WhatsApp" button is "<WA button status>"
        Then User verify the "continue" button is "<Continue button status>"
        And User verifies the "<Helper message>" text is "<message status>"
        When User clicks on the "Country code" section
        And User clicks on the element of data-testid "India (+91)"
        And User enters "<Number>" into the "Mobile number" field
        Then User verify the "Send code via SMS" button is "<SMS button status after>"
        And User verify the "Send code via WhatsApp" button is "<WA button status after>"
        Then User verify the "continue" button is "<Continue button status after>"
        When User clicks on the "<Send code via SMS>" button
        And User types the otp of the "<Phone number>" phone number
        And User clicks on the "Confirm" button


        # Verify cart page is visibl
        Then User verify the "<Cart item page>" header is "visible"
        And User verify the "Place Order" button is "visible"

        # Place order
        When User clicks on the "Place Order" button
        # Verify order confirmation popup
        Then User verifies the popup "confirmation order popup" is "visible"
        Then User clicks on the "Yes, Confirm" button
        # Verify the page after order is placed
        Then User verify the "<Back to Home>" header is "visible"

        Examples:
            | Country   | Capital      | Shop name          | Product name                       | Product detail page                         | Helper message                                            | Number     | Phone number  | Cart item page            | Back to Home       | SMS button status | WA button status | Continue button status | SMS button status after | WA button status after | Continue button status after | Send code via SMS | message status |
            | India     | Mumbai       | Automation shop 2  | Automation - Deltaspray (18:18:18) | YaraTera Automation - Deltaspray (18:18:18) | We'll send a code to verify your number                   | 5443332223 | +915443332223 | Cart items                | Back to Home       | disabled          | disabled         | hidden                 | enabled                 | enabled                | hidden                       | Send code via SMS | visible        |
            | Kenya     | Nairobi      | FC Automation Shop | WINNER                             | YaraMila WINNER                             | We'll send a code to verify your number                   | 5443332224 | +915443332224 | Cart items                | Back to Home       | disabled          | disabled         | hidden                 | enabled                 | enabled                | hidden                       | Send code via SMS | visible        |
            | Indonesia | Jakarta      | AUTOMATION FC SHOP | Automation FC product 01           | AUTOMATION FC Automation FC product 01      | Kami akan mengirimkan kode untuk memverifikasi nomor Anda | 5443332225 | +915443332225 | Item di keranjang belanja | Kembali ke Beranda | disabled          | disabled         | hidden                 | enabled                 | enabled                | hidden                       | Send code via SMS | visible        |
            | Tanzania  | Dodoma       | FC Automation Shop | PowerBoost                         | YaraVita PowerBoost                         | We'll send a code to verify your number                   | 5443332226 | +915443332226 | Cart items                | Back to Home       | disabled          | disabled         | hidden                 | enabled                 | enabled                | hidden                       | Send code via SMS | visible        |
            | Malaysia  | Kuala Lumpur | Diem bussiness     | 本条款适用于使用由 Yara            | Yara Mila 本条款适用于使用由 Yara           | We'll send a code to verify your number                   | 5443332227 | +915443332227 | Cart items                | Back to Home       | disabled          | disabled         | hidden                 | enabled                 | enabled                | hidden                       | Send code via SMS | visible        |
            | VietNam   | Nha Trang    | Bello Việt Nam     | YaraMila Winner                    | YaraMila YaraMila Winner                    | We'll send a code to verify your number                   | 5443332230 | +915443332230 | Cart items                | Back to Home       | hidden            | hidden           | disabled               | hidden                  | hidden                 | enabled                      | continue          | hidden         |
            | Thailand  | Bangkok      | FC Automation Shop | ยารามีร่า 12-11-18 คอมเพล็กซ์      | ยารามีร่า ยารามีร่า 12-11-18 คอมเพล็กซ์     | We'll send a code to verify your number                   | 5443332228 | +915443332228 | รายการรถเข็น              | กลับไปที่เมนูหลัก  | hidden            | hidden           | disabled               | hidden                  | hidden                 | enabled                      | continue          | hidden         |


    @OrderAsGuestDeliveryShopIDPickUp
    Scenario: Verify that the user can access System without login
        Given User goes to landing page
        When User selects on the 'Indonesia' country and select English
        When User clicks on the "Continue As Guest" button
        Then User verify the "Add location" text exactly is "visible"
        When User clicks on the element of data-testid "x icon"
        And User enters "Jakarta" into the "Placeholder in location search box" field
        And User selects the "Jakarta" option from the dropdown
        And User clicks on the "Confirm location" button
        Then User clicks on the "Store tab" button

        # filter the shop name
        And User enters "ID V Dist" into the "Search box" field
        And User clicks on the "ID V Dist" section

        # Select product
        And User clicks on the "TROPICOTE (25)" section
        When User verify the "YaraLiva TROPICOTE (25)" header is "visible"
        And User clicks on the element of data-testid "plus icon"
        And User clicks on the "Add to Cart" button
        And User verifies the "cart number" class contains value "1"

        # Go to cart page
        When User clicks on the element of class "cart number"
        And User clicks on the "Sign up / Login button" button
        Then User verifies the image with alt text "Yara FarmCare logo" is visible

        # Login
        Then User verify the "Send code via SMS" button is "disabled"
        And User verify the "Send code via WhatsApp" button is "disabled"
        And User verifies the "Kami akan mengirimkan kode untuk memverifikasi nomor Anda" text is "visible"
        When User clicks on the "Country code" section
        And User clicks on the element of data-testid "India (+91)"
        And User enters "<Number>" into the "Mobile number" field
        Then User verify the "Send code via SMS" button is "enabled"
        And User verify the "Send code via WhatsApp" button is "enabled"
        When User clicks on the "Send code via SMS" button
        And User types the otp of the "<Phone number>" phone number
        And User clicks on the "Confirm" button


        # Verify cart page is visible
        Then User verify the "<Cart item page>" header is "visible"
        And User verify the "Place Order" button is "disabled"

        # User choose a option pickup
        And User verifies the "Pengambilan sendiri" text is "visible"
        And User verifies the "Pengiriman" text is "visible"
        When User clicks on the "<shop option>" section
        And User verify the "Place Order" button is "<Place Order status>"

        # Place order
        When User clicks on the "Place Order" button
        # Verify order confirmation popup
        Then User verifies the popup "confirmation order popup" is "visible"
        Then User clicks on the "Yes, Confirm" button
        # Verify the page after order is placed
        Then User verify the "<Back to Home>" header is "visible"

        Examples:
            | shop option         | Place Order status | Number     | Phone number  | Cart item page            | Back to Home       |
            | Pengambilan sendiri | enabled            | 5443332231 | +915443332231 | Item di keranjang belanja | Kembali ke Beranda |

    @OrderAsGuestDeliveryShopIDDelivery
    Scenario: Verify that the user can access System without login
        Given User goes to landing page
        When User selects on the 'Indonesia' country and select English
        When User clicks on the "Continue As Guest" button
        Then User verify the "Add location" text exactly is "visible"
        When User clicks on the element of data-testid "x icon"
        And User enters "Jakarta" into the "Placeholder in location search box" field
        And User selects the "Jakarta" option from the dropdown
        And User clicks on the "Confirm location" button
        Then User clicks on the "Store tab" button

        # filter the shop name
        And User enters "ID V Dist" into the "Search box" field
        And User clicks on the "ID V Dist" section

        # Select product
        And User clicks on the "TROPICOTE (25)" section
        When User verify the "YaraLiva TROPICOTE (25)" header is "visible"
        And User clicks on the element of data-testid "plus icon"
        And User clicks on the "Add to Cart" button at index -1
        And User verifies the "cart number" class contains value "1"

        # Go to cart page
        When User clicks on the element of class "cart number"
        And User clicks on the "Sign up / Login button" button
        Then User verifies the image with alt text "Yara FarmCare logo" is visible

        # Login
        Then User verify the "Send code via SMS" button is "disabled"
        And User verify the "Send code via WhatsApp" button is "disabled"
        And User verifies the "Kami akan mengirimkan kode untuk memverifikasi nomor Anda" text is "visible"
        When User clicks on the "Country code" section
        And User clicks on the element of data-testid "India (+91)"
        And User enters "<Number>" into the "Mobile number" field
        Then User verify the "Send code via SMS" button is "enabled"
        And User verify the "Send code via WhatsApp" button is "enabled"
        When User clicks on the "Send code via SMS" button
        And User types the otp of the "<Phone number>" phone number
        And User clicks on the "Confirm" button

        # Verify cart page is visible
        Then User verify the "<Cart item page>" header is "visible"
        And User verify the "Place Order" button is "disabled"

        # User choose a option pickup
        And User verifies the "Pengambilan sendiri" text is "visible"
        And User verifies the "Pengiriman" text is "visible"
        When User clicks on the element of data-testid "delivery icon"
        And User clicks on the element of data-testid "address location icon"
        # User selects the address
        When User chooses the option 2 in the "address to delivery" section

        # Place order
        When User clicks on the "Place Order" button
        # Verify order confirmation popup
        Then User verifies the popup "confirmation order popup" is "visible"
        Then User clicks on the "Yes, Confirm" button
        # Verify the page after order is placed.
        Then User verify the "<Back to Home>" header is "visible"

        Examples:
            | shop option | Place Order status | Number     | Phone number  | Cart item page            | Back to Home       |
            | Pengiriman  | disabled           | 5443332231 | +915443332231 | Item di keranjang belanja | Kembali ke Beranda |

    @OrderAsGuestMOQShop
    Scenario: Verify that the user can access System without login
        Given User goes to landing page
        When User selects on the 'Kenya' country and select English
        When User clicks on the "Continue As Guest" button
        Then User verify the "Add location" text exactly is "visible"
        When User clicks on the element of data-testid "x icon"
        And User enters "Nairobi" into the "Placeholder in location search box" field
        And User selects the "Nairobi" option from the dropdown
        And User clicks on the "Confirm location" button
        Then User clicks on the "Store tab" button

        # filter the shop name
        And User enters "Nairobi retail yarajv" into the "Search box" field
        And User clicks on the "Nairobi retail yarajv" section
        Then User verifies the "Minimum order quantity:" text is "visible"
        And User verifies the "20bags for solid products or 10L for liquid products." text is "visible"

        # Select product
        And User clicks on the "PANNAR PAN 7M-81" section
        When User verify the "Corteva PANNAR PAN 7M-81" header is "visible"
        And User enters "19" into the "quantity input" field
        And User clicks on the "Add to Cart" button at index -1
        And User verifies the "cart number" class contains value "1"

        # Go to cart page
        When User clicks on the element of class "cart number"
        And User clicks on the "Sign up / Login button" button
        Then User verifies the image with alt text "Yara FarmCare logo" is visible

        # Login
        Then User verify the "Send code via SMS" button is "disabled"
        And User verify the "Send code via WhatsApp" button is "disabled"
        And User verifies the "We'll send a code to verify your number" text is "visible"
        When User clicks on the "Country code" section
        And User clicks on the element of data-testid "India (+91)"
        And User enters "<Number>" into the "Mobile number" field
        Then User verify the "Send code via SMS" button is "enabled"
        And User verify the "Send code via WhatsApp" button is "enabled"
        When User clicks on the "Send code via SMS" button
        And User types the otp of the "<Phone number>" phone number
        And User clicks on the "Confirm" button

        # Verify cart page is visible
        Then User verify the "<Cart item page>" header is "visible"
        And User verify the "Place Order" button is "disabled"
        Then User verifies the "Minimum quantity not met." text is "visible"
        And User verifies the "Add at least 20 bags of solid products or 10 L of liquid products to proceed." text is "visible"

        # Increate the quantity to 20
        When User clicks on the element of data-testid "plus more icon"
        And User verify the "Place Order" button is "enabled"

        # Place order
        When User clicks on the "Place Order" button
        # Verify order confirmation popup
        Then User verifies the popup "confirmation order popup" is "visible"
        Then User clicks on the "Yes, Confirm" button
        # Verify the page after order is placed.
        Then User verify the "<Back to Home>" header is "visible"

        Examples:
            | shop option | Place Order status | Number     | Phone number  | Cart item page | Back to Home |
            | Pengiriman  | disabled           | 5443332224 | +915443332224 | Cart items     | Back to Home |
