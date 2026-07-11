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
        Then User verifies the "<Shop name>" text is "visible"
        And User clicks on the element of data-testid "plus more icon" 4 times
        When User goes to "Discount" page
        Then User verifies the "<couponCode>" text is "visible"
        And User verifies the "<couponName>" text is "visible"
        And User verifies the "<discount>" text is "visible"

        Examples:
            | Country   | Language | Shop name  | Add to Cart            | Product name | View cart               | couponCode      | couponName                      | discount |
            | Indonesia |          | LinhshopId | Tambahkan ke keranjang | COMPLEX      | Lihat keranjang belanja | LISA24UNrO7ak6G | unique packaging config Product | 25%      |


    # Scenario - generic code + measuring unit + config product conditions (volume = 5, discount min = 25IDR, order value = 250IDR,CONFIG Product - 2 - 100IDR)
    @discountOrderLevelGenericCartPage
    Scenario Outline: Verify apply discount Generic in cart page
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        Then User clicks on the "Store tab" button
        And User enters "<Shop name>" into the "Search box" field
        And User clicks on the "<Shop name>" section
        And User clicks on "<Add to Cart>" button in the "<Product name>" section
        And User clicks on the "<View cart>" button
        Then User verifies the "<Shop name>" text is "visible"
        And User clicks on the element of data-testid "plus more icon" 5 times
        When User goes to "Discount" page
        Then User verifies the "<couponCode>" text is "visible"
        And User verifies the "<couponName>" text is "visible"
        And User verifies the "<discount>" text is "visible"

        Examples:
            | Country   | Language | Shop name  | Add to Cart            | Product name | View cart               | couponCode | couponName                       | discount |
            | Indonesia |          | LinhshopId | Tambahkan ke keranjang | COMPLEX      | Lihat keranjang belanja | LISA24PU   | generic measuring config Product | Rp 25    |
