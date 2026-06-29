@loginPage
Feature: Login Page

    Background:

    @login
    Scenario: Verify country code and default code
        Given User goes to landing page
        When User clicks on the "<Country>" country
        And  User clicks on the "<CTA button>" button
        Then The "<Country code>" dropdown should have "<Default>" selected by default
        Then The "<Country code>" dropdown should have the following "<Phone code options>" options:

        Examples:
            | Country   | CTA button              | Country code | Default       | Phone code options                    |
            | Kenya     | Sign up / Login         | Country code | +254 Kenya    | India+91, Singapore+65 ,Kenya+254     |
            | Indonesia | Daftar / Login          | Kode negara  | +62 Indonesia | India+91, Singapura+65 ,Indonesia+62  |
            | Thailand  | ลงทะเบียน / เข้าสู่ระบบ | รหัสประเทศ   | +66 ประเทศไทย | อินเดีย+91, สิงคโปร์+65 ,ประเทศไทย+66 |

    @login
    Scenario: Login by OTP with valid phone number for all countries without language
        Given User goes to landing page
        When User clicks on the "<Country>" country
        And  User clicks on the "<CTA button>" button
        And User selects "<Phone Code>" option on the "<Country code>" dropdown
        And User enters "<Number>" into the "<Phone field>" field
        And The following buttons should be "enabled": "<Login Buttons>"
        And User clicks on the "<SMS button>" button
        And User types the otp of the "<Phone number>" phone number
        And User clicks on the "<Confirm>" button
        Then Navigate to "marketing-consent" page or "incomplete-profile" or "home" page

        Examples:
            | Country   | CTA button              | Country code | Phone Code | Number     | Phone number  | Phone field     | Login Buttons                                       | SMS button             | Confirm    |
            | Kenya     | Sign up / Login         | Country code | +254       | 123456789  | +254123456789 | Mobile number   | Send code via WhatsApp, Send code via SMS           | Send code via SMS      | Confirm    |
            | Indonesia | Daftar / Login          | Kode negara  | +62        | 123456789  | +62123456789  | Nomor telepon   | Kirim kode melalui WhatsApp, Kirim kode melalui SMS | Kirim kode melalui SMS | Konfirmasi |
            | Thailand  | ลงทะเบียน / เข้าสู่ระบบ | รหัสประเทศ   | +91        | 3335445440 | +913335445440 | หมายเลขโทรศัพท์ | ดำเนินการต่อ                                        | ดำเนินการต่อ           | ยืนยัน     |

    @login
    Scenario: Login by OTP with valid phone number for all countries with language
        Given User goes to landing page
        When User clicks on the "<Country>" country
        And User selects the "<Language>" language
        And User clicks on the "Next" button
        And User clicks on the "<CTA button>" button
        And User selects "<Phone Code>" option on the "<Country code>" dropdown
        And User enters "<Phone Number>" into the "<Phone field>" field
        And The following buttons should be "enabled": "<Login Buttons>"
        And User clicks on the "<SMS button>" button
        And User types the otp of the "<Phone number>" phone number
        And User clicks on the "<Confirm>" button
        Then Navigate to "marketing-consent" page or "incomplete-profile" or "home" page

        Examples:
            | Country  | Language      | CTA button         | Country code   | Phone Code | Phone Number | Phone number  | Phone field           | Login Buttons                                         | SMS button              | Confirm    |
            | India    | English       | Sign up / Login    | Country code   | +91        | 5454545454   | +915454545454 | Mobile number         | Send code via WhatsApp, Send code via SMS             | Send code via SMS       | Confirm    |
            | Tanzania | Swahili       | Jisajili / Ingia   | Msimbo wa nchi | +255       | 123456789    | +255123456789 | Nambari ya simu       | Tuma msimbo kupitia WhatsApp, Tuma msimbo kupitia SMS | Tuma msimbo kupitia SMS | Thibitisha |
            | VietNam  | English       | Sign up / Login    | Country code   | +91        | 5656565656   | +915656565656 | Mobile number         | Continue                                              | Continue                | Confirm    |
            | Malaysia | Bahasa Melayu | Daftar / Log masuk | Kod negara     | +60        | 125402255    | +60125402255  | Nombor telefon bimbit | Hantar kod melalui SMS                                |                         | Thibitisha |
            | Malaysia | English       | Sign up / Login    | Country code   | +60        | 125402255    | +60125402255  | Mobile number         | Send code via SMS                                     | Continue                | Confirm    |

    @login
    Scenario: Verify TnC and PP links for all countries without language
        Given User goes to landing page
        When User clicks on the "<Country>" country
        And User clicks on the "<CTA button>" button
        Then User verify the link "<TnC>" should be "visible"
        And User verify the title "<Title TnC>" should be "visible"
        And User verify the link "<PP>" should be "visible"
        And User verify the title "<Title PP>" should be "visible"
        Examples:
            | Country   | CTA button              | TnC                 | Title TnC                               | PP                    | Title PP                                       |
            | Kenya     | Sign up / Login         | Terms & Conditions  | Yara Digital Farming Terms              | Privacy Policy        | Yara Digital Farming Privacy Policy (Kenya)    |
            | Indonesia | Daftar / Login          | Syarat & Ketentuan  | Ketentuan Yara Digital Farming          | Kebijakan Privasi     | Kebijakan Privasi                              |
            | Thailand  | ลงทะเบียน / เข้าสู่ระบบ | ข้อกำหนดและเงื่อนไข | ข้อกำหนดการให้บริการของดิจิทัลฟาร์มมิ่ง | นโยบายความเป็นส่วนตัว | นโยบายความเป็นส่วนตัวของ ยารา ดิจิทัลฟาร์มมิ่ง |
    @login
    Scenario: Verify TnC and PP links for all countries with language
        Given User goes to landing page
        When User clicks on the "<Country>" country
        And User selects the "<Language>" language
        And User clicks on the "Next" button
        And User clicks on the "<CTA button>" button
        Then User verify the link "<TnC>" should be "visible"
        And User verify the title "<Title TnC>" should be "visible"
        And User verify the link "<PP>" should be "visible"
        And User verify the title "<Title PP>" should be "visible"
        Examples:
            | Country  | Language      | CTA button         | TnC                | Title TnC                                  | PP              | Title PP                                         |
            | India    | English       | Sign up / Login    | Terms & Conditions | Yara FarmCare - Terms of Use               | Privacy Policy  | YARA’S PRIVACY POLICY                            |
            | Tanzania | Swahili       | Jisajili / Ingia   | Sheria na Masharti | Masharti ya Kilimo cha Kidigitali cha Yara | Sera ya Faragha | Sera ya Faragha ya Ukulima wa Kidijitali wa Yara |
            | VietNam  | English       | Sign up / Login    | Terms & Conditions | Yara Digital Farming Terms                 | Privacy Policy  | Yara Digital Farming Privacy Policy              |
            | Malaysia | English       | Sign up / Login    | Terms & Conditions | Yara Digital Farming Terms                 | Privacy Policy  | Yara Digital Farming Privacy Policy (Kenya)      |
            | Malaysia | Bahasa Melayu | Daftar / Log masuk | Terma & Syarat     | Yara Digital Farming Terms                 | Dasar Privasi   | Yara Digital Farming Privacy Policy              |
