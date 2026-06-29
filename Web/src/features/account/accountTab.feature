Feature: Account Tab
    @verifyAccountOptionsList
    Scenario: Verify account options list
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User clicks on the "<Account>" button
        Then I verify account options for "<AccountOptions>"

        Examples:
            | Country   | Account | AccountOptions                                                                                 |
            | Kenya     | Account | My profile, My orders, Language, Privacy and legal, Get help                                   |
            | India     | Account | My profile, My orders, Scan product,Language, Privacy and legal, Get help                      |
            | Tanzania  | Account | My profile, My orders, Language, Privacy and legal, Get help                                   |
            | VietNam   | Account | My profile, My orders, Language, Privacy and legal, Get help                                   |
            | Malaysia  | Account | My profile, My orders, Language, Privacy and legal, Get help                                   |
            | Indonesia | Akun    | Profil saya, Pesanan saya, Reward FarmCare, Bahasa,  Privasi dan hukum, Dapatkan bantuan       |
            | Thailand  | บัญชี   | ข้อมูลของฉัน, คำสั่งของฉัน, ภารกิจพิชิตรางวัล, ภาษา, ความเป็นส่วนตัวและกฎหมาย, ขอความช่วยเหลือ |

