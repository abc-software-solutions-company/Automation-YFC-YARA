Feature: Onboarding Page

    Background:
    @locale
    Scenario: Verify the list of countries
        Given User goes to landing page
        Then User verify the list of countries:
            | Country   |
            | India     |
            | Indonesia |
            | Kenya     |
            | Thailand  |
            | Tanzania  |
            | VietNam   |
            | Malaysia  |
    @locale
    Scenario Outline: Navigate after selecting country
        Given User goes to landing page
        When User clicks on the "<Country>" country
        Then User verify the "<Button>" button is "<State>"

        Examples:
            | Country   | Button                  | State    |
            | India     | Next                    | Disabled |
            | VietNam   | Next                    | Enabled  |
            | Indonesia | Daftar / Login          | Enabled  |
            | Kenya     | Sign up / Login         | Enabled  |
            | Thailand  | ลงทะเบียน / เข้าสู่ระบบ | Enabled  |
            | Tanzania  | Next                    | Disabled |
            | Malaysia  | Next                    | Enabled  |
    @locale
    Scenario Outline: Verify the list of countries and language
        Given User goes to landing page
        When  User clicks on the "<Country>" country
        And   User verify the languages "<Language>"

        Examples:
            | Country  | Language                                                            |
            | India    | Hindi,Marathi,English,Telugu,Punjabi,Bengali,Gujarati,Kannada,Tamil |
            | VietNam  | English,Vietnamese                                                  |
            | Malaysia | English,Bahasa Melayu,简体中文                                      |