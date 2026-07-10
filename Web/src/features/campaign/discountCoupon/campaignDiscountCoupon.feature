@verifyCampaignDiscount
Feature: Account Tab - Discount coupon campaign

    @verifyDiscountCouponCampaign-noProgress
    Scenario: Verify discount coupon campaign appears on Reward tab with 0 progress
        Given User log in with phone number "<Phone>" in the "<Country>" country with "" language
        And Admin creates a "<Reward kind>" campaign for user "<Phone>" with "<Coupon>"

        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        And User clicks on the admin campaign

        Then User verifies the "<Progress counter>" text is "visible"

        Examples:
            | Phone      | Country   | Reward kind   | Coupon           | Account tab | Reward farmercare menu | Progress counter |
            | random     | Indonesia | reward coupon | Discount AUTO ID | Akun        | Reward FarmCare        | 0/2              |
            | 3335445440 | Thailand  | reward coupon | Discount AUTO TH | บัญชี       | ภารกิจพิชิตรางวัล      | 0/2              |


    @verifyDiscountCouponCampaign-earnCoupon
    Scenario Outline: Verify coupon earned after farmer places 2 B2C orders
        Given User log in with phone number "<Phone>" in the "<Country>" country with "" language
        And Admin creates a "<Reward kind>" campaign for user "<Phone>" with "<Coupon>"

        # Verify campaign visible with 0 progress (counter = 0/2)
        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        And User clicks on the admin campaign
        Then User verifies the "<Progress counter>" text is "visible"

        # 1st B2C order
        When User goes to "Home" page
        When User clicks on "<View all button>" in the "<Stores near you>" section
        And User enters "<Shop name>" into the "<Search placeholder>" field
        And User presses the "Enter" key
        And User selects the "<Shop name>" shop
        And User adds products to cart:
            | Product    | Quantity |
            | <Product1> | <Qty1>   |
        When User clicks on the element of class "cart icon"
        When User clicks on the "<Checkout button>" button
        And User clicks on the "<Confirm button>" button
        Then User should be redirected to order success page
        When Retailer "<Retailer phone>" fulfills the placed order

        # Go to Home, dismiss progress-nudge popup ("Anda hampir dapat!"), then proceed with
        # order #2 directly — no second Goto Home (it would re-trigger the popup).
        When User goes to "Home" page
        When User dismisses popup if shown

        # 2nd B2C order — completes tracker goal (2/2) → coupon earned
        When User clicks on "<View all button>" in the "<Stores near you>" section
        And User enters "<Shop name>" into the "<Search placeholder>" field
        And User presses the "Enter" key
        And User selects the "<Shop name>" shop
        And User adds products to cart:
            | Product    | Quantity |
            | <Product1> | <Qty1>   |
        When User clicks on the element of class "cart icon"
        When User clicks on the "<Checkout button>" button
        And User clicks on the "<Confirm button>" button
        Then User should be redirected to order success page
        When Retailer "<Retailer phone>" fulfills the placed order

        # Coupon earned popup appears after 2nd order — popup body chứa "kupon diskon"
        When User goes to "Home" page
        Then User verifies the "<Win message>" text is "visible"
        And User verifies the "<Win body fragment>" text is "visible"
        And User verifies the "<Detail reward button>" text is "visible"
        When User clicks on the "<Detail reward button>" button
        And User waits for 30 seconds

        # "Detail hadiah" redirects to Reward detail page — verify coupon structure:
        # status badge "Aktif", expiry label, redemption code label, CTA button "Ke Toko FarmCare".
        Then User verifies the "<Coupon status>" text is "visible"
        And User verifies the "<Expiry label>" text is "visible"
        And User verifies the "<Redemption code label>" text is "visible"
        And User verifies the "<Store CTA button>" text is "visible"

        Examples:
            | Phone      | Country   | Reward kind   | Coupon           | Account tab | Reward farmercare menu | Progress counter | Stores near you | View all button | Search placeholder | Shop name          | Retailer phone | Product1                 | Qty1 | Checkout button            | Confirm button     | Win message         | Win body fragment | Detail reward button | Coupon status     | Expiry label        | Redemption code label                       | Store CTA button                      |
            | random     | Indonesia | reward coupon | Discount AUTO ID | Akun        | Reward FarmCare        | 0/2              | Toko terdekat   | Lihat semua     | Cari               | AUTOMATION FC SHOP | +915641110010  | Automation FC product 02 | 2    | Konfirmasi dan bayar nanti | Ya, konfirmasi     | Misi selesai        | kupon diskon      | Detail hadiah        | Aktif             | Tanggal kedaluwarsa | Kode penukaran Anda                         | Ke Toko FarmCare                      |
            | 7888852001 | Thailand  | reward coupon | Discount AUTO TH | บัญชี       | ภารกิจพิชิตรางวัล      | 0/2              | ร้านค้าใกล้คุณ  | ดูทั้งหมด       | ค้นหา              | FC TH SubDealer    | +66600700116   | Product test auto 02     | 1    | ยืนยันและชำระเงินภายหลัง   | ยืนยันคำขอสั่งซื้อ | ทำภารกิจสำเร็จแล้ว! | คูปองส่วนลด       | ดูรายละเอียดรางวัล   | ส่วนลดพร้อมใช้งาน | หมดอายุวันที่       | รหัสเพื่อแลกรับส่วนลดบนร้านค้ายาราฟาร์มแคร์ | ดูผลิตภัณฑ์ที่ร้านค้ายาราฟาร์มแคร์เลย |
