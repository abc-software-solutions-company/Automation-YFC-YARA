Feature:  Verify coupon show home page

    @verifyDiscountOrderLevelUnique
    Scenario Outline: Verify discount Order Level Flow with unique code + packaging unit
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User clicks on the element of data-testid "couponsList"
        And User clicks on "Lihat semua" in the "Kupon" section
        Then User verifies coupon card with code "<couponCode>", name "<couponName>" and discount "<discount>"

        Examples:
            | Country   | Language | couponCode      | couponName                      | discount |
            | Indonesia |          | LISA24UNrO7ak6G | unique packaging config Product | 25%      |

    @verifyDiscountOrderLevelGeneric
    Scenario Outline: Verify discount Order Level Flow with generic code + measuring unit
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User clicks on the element of data-testid "couponsList"
        And User clicks on "Lihat semua" in the "Kupon" section
        Then User verifies coupon card with code "<couponCode>", name "<couponName>" and discount "<discount>"

        Examples:
            | Country   | Language | couponCode | couponName                       | discount |
            | Indonesia |          | LISA24PU   | generic measuring config Product | Rp 25    |

