Feature: Verify coupon show cart page

    # Scenario - unique code + packaging unit + config product conditions (volume = 4, discount min = 25%, max = 30IDR, order value = 200IDR,CONFIG Product - 2 - 100IDR)
    @discountOrderLevelUniqueCartPage
    Scenario Outline:  Verify apply discount Unique in cart page
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        Then User clicks on the "Store tab" button
        And User enters "<Shop name>" into the "Search box" field
        And User clicks on the "<Shop name>" section
        And User clicks on "<Add to Cart>" button in the "<Product name>" section
        And User clicks on the "<View cart>" button
        Then User verifies the "Cart items" text is "visible"
        And User clicks on the element of data-testid "plus more icon" 4 times

        And User ensures coupon is applied with code "<couponCode>", name "<couponName>", discount "<discount>" and coupon id "1f84a506-cd8b-43af-8099-460b4d9a1fd5"

        Examples:
            | Country   | Language | Shop name  | Add to Cart            | Product name | View cart               | couponCode      | couponName                      | discount |
            | Indonesia | Bahasa   | LinhshopId | Tambahkan ke keranjang | COMPLEX      | Lihat keranjang belanja | LISA24UNrO7ak6G | unique packaging config Product | 25%      |


    # Scenario - generic code + measuring unit + config product conditions (volume = 5, discount min = 25IDR, order value = 250IDR,CONFIG Product - 2 - 100IDR)
    @discountOrderLevelGenericCartPage
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

        Examples:
            | Country   | Language | Shop name  | Add to Cart            | Product name | View cart               | couponCode | couponName                       | discount |
            | Indonesia | Bahasa   | LinhshopId | Tambahkan ke keranjang | COMPLEX      | Lihat keranjang belanja | LISA24PU   | generic measuring config Product | Rp 25    |
