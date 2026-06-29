@verifyRerwardCampaignPhysical
Feature: Account Tab - Reward campaign

    @verifyRewardCampaignNoReward
    Scenario: Verify reward campaign - no reward
        Given User log in with phone number "<Phone>" in the "<Country>" country with "" language
        When User goes to "Home" page
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        Then User verifies the "<Ongoing tab>" text is "visible"
        And User verifies the "<Reward tab>" text is "visible"

        When User clicks on the "<Reward tab>" tab
        Then User verifies the "<Content no reward>" text is "visible"

        Examples:
            | Phone      | Country   | Account tab | Reward farmercare menu | Ongoing tab               | Reward tab | Content no reward            |
            | random     | Indonesia | Akun        | Reward FarmCare        | Program berjalan          | Hadiah     | Belum ada hadiah             |
            | 7888852003 | Thailand  | บัญชี       | ภารกิจพิชิตรางวัล      | ภารกิจที่พร้อมให้เข้าร่วม | รางวัล     | รางวัลจะมีการอัปเดตเร็วๆ นี้ |


    @verifyRewardCampaignNoProgress
    Scenario Outline: Verify reward campaign - ongoing campaign with no progress
        Given User log in with phone number "<Phone>" in the "<Country>" country with "" language
        And Admin creates a reward campaign for user "<Phone>" with reward "<Reward>"

        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section

        # Campaign card on the list shows: status badge + admin-created campaign name
        Then User verifies the admin campaign is visible
        And User verifies the "<Status badge>" text is "visible"

        # Open campaign detail
        When User clicks on the admin campaign

        # Detail page sections
        Then User verifies the admin campaign is visible
        And User verifies the "<Status badge>" text is "visible"
        And User verifies the "<Description label>" text is "visible"
        And User verifies the "<Terms label>" text is "visible"
        And User verifies the "<Current progress label>" text is "visible"
        And User verifies the "<Conditions label>" text is "visible"
        And User verifies the "<Progress counter>" text is "visible"
        And User verifies the "<Reward label>" text is "visible"
        And User verifies the "<Milestone reward label>" text is "visible"
        And User verifies the "<Reward>" text is "visible"

        Examples:
            | Phone      | Country   | Reward           | Account tab | Reward farmercare menu | Status badge       | Description label | Terms label          | Current progress label | Conditions label | Progress counter | Reward label | Milestone reward label      |
            | random     | Indonesia | T - shirt (AUTO) | Akun        | Reward FarmCare        | Sedang berlangsung | Deskripsi:        | Syarat dan ketentuan | Status saat ini        | Persyaratan      | 0/2              | Hadiah       | Pencapaian hadiah 1         |
            | 3335445440 | Thailand  | T-shirt (Auto)   | บัญชี       | ภารกิจพิชิตรางวัล      | เข้าร่วมภารกิจเลย! | รายละเอียดภารกิจ: | ข้อกำหนดและเงื่อนไข  | ความคืบหน้าภารกิจ      | เงื่อนไขภารกิจ   | 0/2              | รางวัล       | รางวัลที่จะได้รับในภารกิจ 1 |

    @verifyRewardCampaign-earnReward
    Scenario Outline: Verify reward earned after farmer places 2 B2C orders
        Given User log in with phone number "<Phone>" in the "<Country>" country with "" language
        And Admin creates a reward campaign for user "<Phone>" with reward "<Reward>"

        # Verify campaign visible with 0 progress (counter = 0/2)
        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        And User clicks on the admin campaign
        Then User verifies the "<Progress counter>" text is "visible"

        # 1st B2C order
        When User goes to "Home" page
        When User dismisses popup if shown
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

        # Go to Home, dismiss progress-nudge popup ("Anda hampir dapat!"), then proceed
        # with order #2 directly — no second Goto Home (it would re-trigger the popup).
        When User goes to "Home" page
        When User dismisses popup if shown

        # 2nd B2C order — completes tracker goal (2/2) → reward earned
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
        And User waits for 10 seconds

        # Reward earned popup appears after 2nd order
        When User goes to "Home" page
        Then User verifies the "<Win message>" text is "visible"
        And User verifies the "<View reward button>" text is "visible"
        When User clicks on the "<View reward button>" button

        # "Lihat hadiah" redirects to Reward tab — verify reward + claim section + structure
        Then User verifies the "<Reward>" text is "visible"
        And User verifies the "<Reward status>" text is "visible"
        And User verifies the "<Claim badge>" text is "visible"
        And User verifies the "<Claim title>" text is "visible"
        And User verifies the "<Description label>" text is "visible"
        And User verifies the "<Terms label>" text is "visible"

        # Click claim card to open personal info form
        When User clicks on the "<Claim title>" section
        Then User verifies the "<Form header>" text is "visible"
        And User verifies the "<KTP section>" text is "visible"
        And User verifies the "<Shipping section>" text is "visible"
        And User verifies the "<Submit button>" text is "visible"

        # Fill claim form: KTP info
        When User enters "<Full name>" into the "<Name field>" field
        And User enters "<KTP number>" into the "<KTP field>" field
        And User uploads KTP document

        # Fill claim form: shipping address (cascading dropdowns + text fields)
        And User selects first option from "<Province field>" dropdown
        And User selects first option from "<City field>" dropdown
        And User selects first option from "<District field>" dropdown
        And User selects first option from "<Subdistrict field>" dropdown
        And User enters "<Postal code>" into the "<Postal code field>" field
        And User enters "<Street>" into the "<Street field>" field
        And User enters "<Block>" into the "<Block field>" field
        And User enters "<Phone last>" into the "<Phone field>" field

        # Submit — opens confirmation modal, then click confirm. Watch listener captures
        # submissionId from the BFF response in the background.
        When User starts watching for KTP submission
        And User clicks on the "<Submit button>" button
        And User clicks on the "<Submit confirm button>" button

        # After submit: form transitions to verification-pending review page
        Then User verifies the "<Verification status>" text is "visible"
        And User verifies the "<Full name>" text is "visible"
        And User verifies the "<KTP number>" text is "visible"

        Examples:
            | Phone  | Country   | Reward           | Account tab | Reward farmercare menu | Progress counter | Stores near you | View all button | Search placeholder | Shop name          | Retailer phone | Product1                 | Qty1 | Delivery option     | Coupon state | Checkout button            | Confirm button | Win message  | View reward button | Reward status | Claim badge          | Claim title       | Description label | Terms label          | Form header  | KTP section | Shipping section     | Submit button | Submit confirm button | Full name      | Name field   | KTP number       | KTP field | Province field | City field       | District field | Subdistrict field | Postal code | Postal code field | Street          | Street field                    | Block   | Block field                  | Phone last | Phone field  | Verification status        |
            | random | Indonesia | T - shirt (AUTO) | Akun        | Reward FarmCare        | 0/2              | Toko terdekat   | Lihat semua     | Cari               | DM AUTO FC SHOP ID | +915555531211  | Automation FC product 02 | 2    | Pengambilan sendiri | NONE         | Konfirmasi dan bayar nanti | Ya, konfirmasi | Misi selesai | Lihat hadiah       | Diterbitkan   | Informasi diperlukan | Klaim hadiah Anda | Deskripsi hadiah  | Syarat dan ketentuan | Data pribadi | KTP         | Informasi pengiriman | Kirim         | Konfirmasi            | Auto Test User | Nama lengkap | 1234567890123456 | Nomor KTP | Provinsi       | Kabupaten / Kota | Kecamatan      | Kelurahan / Desa  | 12345       | Kode pos          | Test Street 123 | Nama Jalan, gedung, nomor rumah | Block A | Contoh: Blok / unit, patokan | 8112345678 | Nomor ponsel | Verifikasi sedang diproses |

    @verifyRewardCampaign-earnReward-TH
    Scenario Outline: TH — earn reward and verify claim form submit button enables after fill (no submit)
        Given User log in with phone number "<Phone>" in the "<Country>" country with "" language
        And Admin creates a reward campaign for user "<Phone>" with reward "<Reward>"

        # 1st B2C order
        When User goes to "Home" page
        When User dismisses popup if shown
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

        # 2nd B2C order — completes tracker (2/2) → reward earned
        When User goes to "Home" page
        When User dismisses popup if shown
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
        And User waits for 10 seconds

        # Reward popup → click "ดูรางวัลที่คุณได้รับ" → Reward tab → click reward → reward detail
        When User goes to "Home" page
        Then User verifies the "<Win message>" text is "visible"
        When User clicks on the "<View reward button>" button
        Then User verifies the "<Reward>" text is "visible"
        When User clicks on the "<Reward>" section

        # TH claim card has no click handler on text — pencil edit SVG is the only click target
        When User opens claim form by edit icon for "<Claim title>"
        Then User verifies the "<Form header>" text is "visible"

        When User selects first option from "<Province field>" dropdown
        And User selects first option from "<District field>" dropdown
        And User selects first option from "<Subdistrict field>" dropdown
        And User enters "<Postal code>" into the "<Postal code field>" field
        And User enters "<Address>" into the "<Address field>" field

        Then User verify the "<Submit button>" button is "enabled"

        Examples:
            | Phone      | Country  | Reward         | View all button | Stores near you | Search placeholder | Shop name       | Retailer phone | Product1             | Qty1 | Checkout button          | Confirm button     | Win message         | View reward button   | Claim title                    | Form header          | Province field | District field | Subdistrict field | Postal code | Postal code field | Address          | Address field | Submit button |
            | 7888852001 | Thailand | T-shirt (Auto) | ดูทั้งหมด       | ร้านค้าใกล้คุณ  | ค้นหา              | FC TH SubDealer | +66600700116   | Product test auto 02 | 1    | ยืนยันและชำระเงินภายหลัง | ยืนยันคำขอสั่งซื้อ | ทำภารกิจสำเร็จแล้ว! | ดูรางวัลที่คุณได้รับ | โปรดกรอกที่อยู่จัดส่งของรางวัล | กรอกรายละเอียดของคุณ | จังหวัด        | เขต            | ตำบล/แขวง         | 10100       | รหัสไปรษณีย์      | Test address 123 | ที่อยู่       | ยืนยัน        |


    @verifyRewardCampaign-statusFlow-approved
    Scenario Outline: Admin approves KTP submission → user sees Terverifikasi banner
        Given User log in with phone number "<Phone>" in the "<Country>" country with "" language
        And Admin creates a reward campaign for user "<Phone>" with reward "<Reward>"

        # Earn the reward (place 2 orders + fulfill)
        When User goes to "Home" page
        When User dismisses popup if shown
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

        When User goes to "Home" page
        When User dismisses popup if shown

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
        And User waits for 10 seconds

        # Navigate to reward tab via Account (bypass popup CTA flakiness)
        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        And User clicks on the "<Reward tab>" button
        And User clicks on the "<Reward>" section

        # Open claim form, submit
        When User clicks on the "<Claim title>" section
        When User enters "<Full name>" into the "<Name field>" field
        And User enters "<KTP number>" into the "<KTP field>" field
        And User uploads KTP document
        And User selects first option from "<Province field>" dropdown
        And User selects first option from "<City field>" dropdown
        And User selects first option from "<District field>" dropdown
        And User selects first option from "<Subdistrict field>" dropdown
        And User enters "<Postal code>" into the "<Postal code field>" field
        And User enters "<Street>" into the "<Street field>" field
        And User enters "<Block>" into the "<Block field>" field
        And User enters "<Phone last>" into the "<Phone field>" field
        When User starts watching for KTP submission
        And User clicks on the "<Submit button>" button
        And User clicks on the "<Submit confirm button>" button

        # Pending banner immediately after submit
        Then User verifies the "<Pending banner>" text is "visible"

        # Admin approves submission via API
        When Admin "approves" the submitted KTP with ""

        # Reload user app → verify Terverifikasi banner
        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        And User clicks on the "<Reward tab>" button
        And User clicks on the "<Reward>" section

        Then User verifies the "<Verified badge>" text is "visible"
        And User verifies the "<Verified banner>" text is "visible"

        Examples:
            | Phone  | Country   | Reward           | Reward farmercare menu | Account tab | Reward tab | Stores near you | View all button | Search placeholder | Shop name          | Retailer phone | Product1                 | Qty1 | Checkout button            | Confirm button | Claim title       | Submit button | Submit confirm button | Full name      | Name field   | KTP number       | KTP field | Province field | City field       | District field | Subdistrict field | Postal code | Postal code field | Street          | Street field                    | Block   | Block field                  | Phone last | Phone field  | Pending banner             | Verified badge | Verified banner            |
            | random | Indonesia | T - shirt (AUTO) | Reward FarmCare        | Akun        | Hadiah     | Toko terdekat   | Lihat semua     | Cari               | DM AUTO FC SHOP ID | +915555531211  | Automation FC product 02 | 2    | Konfirmasi dan bayar nanti | Ya, konfirmasi | Klaim hadiah Anda | Kirim         | Konfirmasi            | Auto Test User | Nama lengkap | 1234567890123456 | Nomor KTP | Provinsi       | Kabupaten / Kota | Kecamatan      | Kelurahan / Desa  | 12345       | Kode pos          | Test Street 123 | Nama Jalan, gedung, nomor rumah | Block A | Contoh: Blok / unit, patokan | 8112345678 | Nomor ponsel | Verifikasi sedang diproses | Terverifikasi  | Data pribadi terverifikasi |


    @verifyRewardCampaign-statusFlow-rejected
    Scenario Outline: Admin rejects KTP submission → user sees Ditolak banner with NIK cleared
        Given User log in with phone number "<Phone>" in the "<Country>" country with "" language
        And Admin creates a reward campaign for user "<Phone>" with reward "<Reward>"

        When User goes to "Home" page
        When User dismisses popup if shown
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

        When User goes to "Home" page
        When User dismisses popup if shown

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

        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        And User clicks on the "<Reward tab>" button
        And User clicks on the "<Reward>" section

        When User clicks on the "<Claim title>" section
        When User enters "<Full name>" into the "<Name field>" field
        And User enters "<KTP number>" into the "<KTP field>" field
        And User uploads KTP document
        And User selects first option from "<Province field>" dropdown
        And User selects first option from "<City field>" dropdown
        And User selects first option from "<District field>" dropdown
        And User selects first option from "<Subdistrict field>" dropdown
        And User enters "<Postal code>" into the "<Postal code field>" field
        And User enters "<Street>" into the "<Street field>" field
        And User enters "<Block>" into the "<Block field>" field
        And User enters "<Phone last>" into the "<Phone field>" field
        When User starts watching for KTP submission
        And User clicks on the "<Submit button>" button
        And User clicks on the "<Submit confirm button>" button

        # Admin rejects with reason "unclear_wrong_id_document"
        When Admin "rejects" the submitted KTP with "unclear_wrong_id_document"

        # Reload user app → verify Ditolak banner + NIK preserved? (cleared per English DOM)
        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        And User clicks on the "<Reward tab>" button
        And User clicks on the "<Reward>" section

        Then User verifies the "<Rejected badge>" text is "visible"
        And User verifies the "<Rejected banner fragment>" text is "visible"

        Examples:
            | Phone  | Country   | Reward           | Reward farmercare menu | Account tab | Reward tab | Stores near you | View all button | Search placeholder | Shop name          | Retailer phone | Product1                 | Qty1 | Checkout button            | Confirm button | Claim title       | Submit button | Submit confirm button | Full name      | Name field   | KTP number       | KTP field | Province field | City field       | District field | Subdistrict field | Postal code | Postal code field | Street          | Street field                    | Block   | Block field                  | Phone last | Phone field  | Rejected badge | Rejected banner fragment |
            | random | Indonesia | T - shirt (AUTO) | Reward FarmCare        | Akun        | Hadiah     | Toko terdekat   | Lihat semua     | Cari               | AUTOMATION FC SHOP | +915641110010  | Automation FC product 02 | 2    | Konfirmasi dan bayar nanti | Ya, konfirmasi | Klaim hadiah Anda | Kirim         | Konfirmasi            | Auto Test User | Nama lengkap | 1234567890123456 | Nomor KTP | Provinsi       | Kabupaten / Kota | Kecamatan      | Kelurahan / Desa  | 12345       | Kode pos          | Test Street 123 | Nama Jalan, gedung, nomor rumah | Block A | Contoh: Blok / unit, patokan | 8112345678 | Nomor ponsel | Ditolak        | Verifikasi gagal         |


    @verifyRewardCampaign-orderWithoutSKU-noProgress
    Scenario Outline: Order without qualifying SKU does NOT increase tracker progress
        Given User log in with phone number "<Phone>" in the "<Country>" country with "" language
        And Admin creates a reward campaign for user "<Phone>" with reward "<Reward>" with SKU operator "containsAll"

        # Pre-check: campaign at 0/2 before any order
        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        And User clicks on the admin campaign
        Then User verifies the "<Progress counter zero>" text is "visible"

        # Place B2C order with a product NOT in productVariantIds list
        When User goes to "Home" page
        When User dismisses popup if shown
        When User clicks on "<View all button>" in the "<Stores near you>" section
        And User enters "<Shop name>" into the "<Search placeholder>" field
        And User presses the "Enter" key
        And User selects the "<Shop name>" shop
        And User adds products to cart:
            | Product              | Quantity |
            | <Non-qualifying SKU> | <Qty>    |
        When User clicks on the element of class "cart icon"
        When User clicks on the "<Checkout button>" button
        And User clicks on the "<Confirm button>" button
        Then User should be redirected to order success page
        When Retailer "<Retailer phone>" fulfills the placed order

        # Re-check progress: still 0/2 because order did not match tracker condition
        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        And User clicks on the admin campaign
        Then User verifies the "<Progress counter zero>" text is "visible"

        Examples:
            | Phone      | Country   | Reward           | Account tab | Reward farmercare menu | Progress counter zero | Stores near you | View all button | Search placeholder | Shop name          | Retailer phone | Non-qualifying SKU   | Qty | Checkout button            | Confirm button     |
            | random     | Indonesia | T - shirt (AUTO) | Akun        | Reward FarmCare        | 0/2                   | Toko terdekat   | Lihat semua     | Cari               | AUTOMATION FC SHOP | +915641110010  | Product test auto 99 | 2   | Konfirmasi dan bayar nanti | Ya, konfirmasi     |
            | 7888852001 | Thailand  | T-shirt (Auto)   | บัญชี       | ภารกิจพิชิตรางวัล      | 0/2                   | ร้านค้าใกล้คุณ  | ดูทั้งหมด       | ค้นหา              | FC TH SubDealer    | +66600700116   | Product test auto 99 | 1   | ยืนยันและชำระเงินภายหลัง   | ยืนยันคำขอสั่งซื้อ |


    @verifyRewardCampaign-orderWithBothSKUs-incrementsProgress
    Scenario Outline: Order containing both SKU1 and SKU2 increments tracker progress
        Given User log in with phone number "<Phone>" in the "<Country>" country with "" language
        And Admin creates a reward campaign for user "<Phone>" with reward "<Reward>" with SKU operator "containsAll"

        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        And User clicks on the admin campaign
        Then User verifies the "<Progress counter zero>" text is "visible"

        # Place 1 B2C order with both SKU1 + SKU2 in the same cart
        When User goes to "Home" page
        When User dismisses popup if shown
        When User clicks on "<View all button>" in the "<Stores near you>" section
        And User enters "<Shop name>" into the "<Search placeholder>" field
        And User presses the "Enter" key
        And User selects the "<Shop name>" shop
        And User adds products to cart:
            | Product | Quantity |
            | <SKU1>  | <Qty1>   |
            | <SKU2>  | <Qty2>   |
        When User clicks on the element of class "cart icon"
        When User clicks on the "<Checkout button>" button
        And User clicks on the "<Confirm button>" button
        Then User should be redirected to order success page
        When Retailer "<Retailer phone>" fulfills the placed order

        # Verify progress incremented to 1/2 — qualifying order matched tracker condition
        When User goes to "Home" page
        When User dismisses popup if shown
        And User clicks on the "<Account tab>" button
        And User clicks on the "<Reward farmercare menu>" section
        And User clicks on the admin campaign
        Then User verifies the "<Progress counter one>" text is "visible"

        Examples:
            | Phone      | Country   | Reward           | Account tab | Reward farmercare menu | Progress counter zero | Progress counter one | Stores near you | View all button | Search placeholder | Shop name          | Retailer phone | SKU1                     | Qty1 | SKU2                     | Qty2 | Checkout button            | Confirm button     |
            | random     | Indonesia | T - shirt (AUTO) | Akun        | Reward FarmCare        | 0/2                   | 1/2                  | Toko terdekat   | Lihat semua     | Cari               | AUTOMATION FC SHOP | +915641110010  | Automation FC product 02 | 2    | Automation FC product 01 | 2    | Konfirmasi dan bayar nanti | Ya, konfirmasi     |
            | 7888852001 | Thailand  | T-shirt (Auto)   | บัญชี       | ภารกิจพิชิตรางวัล      | 0/2                   | 1/2                  | ร้านค้าใกล้คุณ  | ดูทั้งหมด       | ค้นหา              | FC TH SubDealer    | +66600700116   | Product test auto 02     | 1    | Product test auto 01     | 1    | ยืนยันและชำระเงินภายหลัง   | ยืนยันคำขอสั่งซื้อ |
