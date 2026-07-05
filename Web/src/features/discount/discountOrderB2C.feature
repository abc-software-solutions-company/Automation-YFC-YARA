Feature: Verify coupon show cart page

    Background:
    @b2c_emptycart
    Scenario: Verify the shopping cart is empty
        Given User log in with phone number "<Phone number>" in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the element of class "cart icon"
        Then User verifies the "<Message>" text is "visible"
        Examples:
            | Country   | Language | Message                       |
            | Indonesia | Bahasa   | Keranjang belanja Anda kosong |

    # Scenario - unique code + packaging unit + config product conditions (volume = 4, discount min = 25%, max = 30IDR, order value = 200IDR,CONFIG Product - 2 - 100IDR)
    @discountOrderLevelB2CUnique
    Scenario Outline:  Verify apply discount Unique in cart page
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        Then User clicks on the "Store tab" button
        And User enters "<Shop name>" into the "Search box" field
        And User clicks on the "<Shop name>" section
        And User clicks on "<Add to Cart>" button in the "<Product name>" section
        And User clicks on the "<View cart>" button
        Then User verifies the "Cart items" text is "visible"
        And User clicks on the element of data-testid "plus more icon" 4 times
        And User clicks on the "<Delivery option>" section

        And User ensures coupon is applied with code "<couponCode>", name "<couponName>", discount "<discount>" and coupon id "1f84a506-cd8b-43af-8099-460b4d9a1fd5"

        And User clicks on the "Place Order" button
        Then User verifies the popup "confirmation order popup" is "visible"
        And User clicks on the "Yes, Confirm" button

        # Then User should be redirected to order success page
        # And User verifies the "<Place completed text>" text is "visible"
        # Then Order number should be displayed on success page

        And User verify the "<Back to Home>" header is "visible"

        Examples:
            | Country   | Language | Shop name  | Add to Cart            | Product name | View cart               | couponCode      | couponName                      | discount | Back to Home |
            | Indonesia | Bahasa   | LinhshopId | Tambahkan ke keranjang | COMPLEX      | Lihat keranjang belanja | LISA24UNrO7ak6G | unique packaging config Product | 25%      | Back to Home |


    # Scenario - generic code + measuring unit + config product conditions (volume = 5, discount min = 25IDR, order value = 250IDR,CONFIG Product - 2 - 100IDR)
    @discountOrderLevelB2CGeneric
    Scenario Outline: Verify apply discount Generic in cart page
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        Then User clicks on the "Store tab" button
        And User enters "<Shop name>" into the "Search box" field
        And User clicks on the "<Shop name>" section
        And User clicks on "<Add to Cart>" button in the "<Product name>" section
        And User clicks on the "<View cart>" button
        Then User verifies the "Cart items" text is "visible"
        And User clicks on the element of data-testid "plus more icon" 5 times

        And User ensures coupon is applied with code "<couponCode>", name "<couponName>", discount "<discount>" and coupon id "a8e8d067-3f37-4bd2-ae5e-ca355a67a521"

        And User clicks on the "Place Order" button
        Then User verifies the popup "confirmation order popup" is "visible"
        And User clicks on the "Yes, Confirm" button
        And User verify the "<Back to Home>" header is "visible"

        Examples:
            | Country   | Language | Shop name  | Add to Cart            | Product name | View cart               | couponCode | couponName                       | discount | Back to Home |
            | Indonesia | Bahasa   | LinhshopId | Tambahkan ke keranjang | COMPLEX      | Lihat keranjang belanja | LISA24PU   | generic measuring config Product | Rp 25    | Back to Home |
