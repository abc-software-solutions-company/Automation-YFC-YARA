Feature: Access System
    Background:

    @AccessSystem
    Scenario: Verify that the user can access System without login
        Given User goes to landing page
        When User selects on the '<Country>' country and select English
        Then User verify the "<ContinueAsGuestButton>" button is "enabled"
        When User clicks on the "<ContinueAsGuestButton>" button
        Then User verify the "<AddLocationHeader>" text exactly is "visible"
        And User verify the "<Confirm Location button>" button is "enabled"
        When User clicks on the element of data-testid "HighlightOffOutlinedIcon"
        And User enters "<Capital>" into the "<Search box>" field
        And User selects the "<Capital>" option from the dropdown
        And User clicks on the "<Confirm Location button>" button
        Then User verify the "<Browse by crops>" text exactly is "visible"
        And User verify the "<Stores near you>" text exactly is "visible"
        And User verify the "<Yara fertiliser family>" text exactly is "visible"
        When User clicks on the "<Stores>" button
        Then User verify the "<All stores>" header is "visible"
        When User clicks on the "<Products>" button
        Then User verify the "<Select by categories>" text exactly is "visible"
        When User clicks on the "<Account>" button
        Then User verifies the image with alt text "Yara FarmCare logo" is visible

        Examples:
            | Country   | ContinueAsGuestButton | AddLocationHeader | Confirm Location button | Capital      | Search box                                    | Browse by crops              | Stores near you | Yara fertiliser family | Stores  | Products  | Account | All stores     | Select by categories       |
            | India     | Continue as guest     | Add location      | Confirm location        | New Delhi    | Enter your area, pincode, etc.                | Browse by crops              | Stores near you | Yara fertiliser family | Stores  | Products  | Account | All stores     | Select by categories       |
            | Kenya     | Continue as guest     | Add location      | Confirm location        | Nairobi      | Enter your area, pincode, etc.                | Browse by crops              | Stores near you | Yara fertiliser family | Stores  | Products  | Account | All stores     | Select by categories       |
            | Indonesia | Lanjut sebagai tamu   | Tambahkan lokasi  | Konfirmasi lokasi       | Jakarta      | Masukkan area, kode pos, dll.                 | Jelajahi berdasarkan tanaman | Toko terdekat   | Kelompok pupuk Yara    | Toko    | Produk    | Akun    | Semua toko     | Pilih berdasarkan kategori |
            | Thailand  | ดำเนินการต่อในฐานะแขก | ใส่ที่อยู่ของคุณ  | ยืนยันตำแหน่งพื้นที่    | Bangkok      | บ้านเลขที่ ถนน ตำบล อำเภอ จังหวัด รหัสไปรณีย์ | ค้นหาตามชนิดพืช              | ร้านค้าใกล้คุณ  | กลุ่มปุ๋ยของยารา       | ร้านค้า | ผลิตภัณฑ์ | บัญชี   | ร้านค้าทั้งหมด | เลือกตามหมวดหมู่           |
            | VietNam   | Continue as guest     | Add location      | Confirm location        | Nha Trang    | Enter your area, pincode, etc.                | Browse by crops              | Stores near you | Yara fertiliser family | Stores  | Products  | Account | All stores     | Select by categories       |
            | Tanzania  | Continue as guest     | Add location      | Confirm location        | Dodoma       | Enter your area, pincode, etc.                | Browse by crops              | Stores near you | Yara fertiliser family | Stores  | Products  | Account | All stores     | Select by categories       |
            | Malaysia  | Continue as guest     | Add location      | Confirm location        | Kuala Lumpur | Enter your area, pincode, etc.                | Browse by crops              | Stores near you | Yara fertiliser family | Stores  | Products  | Account | All stores     | Select by categories       |

