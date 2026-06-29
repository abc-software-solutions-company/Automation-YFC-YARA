Feature: Account Tab - Change Language options

    @verifyNavigationAndListLanguage
    Scenario: Verify navigation - Change Language options on account tab
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User clicks on the "<Account>" button
        And User clicks on the exact "<AboutYaraOption>" section
        Then User verifies URL "/profile/language"
        And User verify language list including "<Language List>"

        Examples:
            | Country   | Account | AboutYaraOption | Language List                                                       |
            | Kenya     | Account | Language        | English                                                             |
            | India     | Account | Language        | हिंदी, मराठी, English, తెలుగు, ਪੰਜਾਬੀ, বাংলা, ગુજરાતી, ಕನ್ನಡ, தமிழ் |
            | Tanzania  | Account | Language        | English, Kiswahili                                                  |
            | VietNam   | Account | Language        | English, Tiếng việt                                                 |
            | Malaysia  | Account | Language        | Bahasa Melayu  , English   , 简体中文                               |
            | Indonesia | Akun    | Bahasa          | Bahasa Indonesia   ,English                                         |
            | Thailand  | บัญชี   | ภาษา            | English, ไทย                                                        |

    @verifyChangeToOtherLanguage
    Scenario: Verify change to other language
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User clicks on the "<Account>" button
        And User clicks on the exact "<AboutYaraOption>" section
        And User select language "<Other Language>"
        And User clicks on the "<Save button>" button
        Then User verifies URL "<Path Language>"

        Examples:
            | Country   | Account | AboutYaraOption | Other Language | Save button | Path Language |
            | Tanzania  | Account | Language        | Kiswahili      | Done        | sw-tz/profile |
            | VietNam   | Account | Language        | Tiếng việt     | Done        | vi-vn/profile |
            | Malaysia  | Account | Language        | Bahasa Melayu  | Done        | ms-my/profile |
            | Indonesia | Akun    | Bahasa          | English        | Selesai     | en-id/profile |
            | Thailand  | บัญชี   | ภาษา            | English        | เสร็จสิ้น   | en-th/profile |

    @verifyChangeToOtherLanguageINcountry
    Scenario: Verify change to other language - IN Country
        Given User goes to dashboard page in the "India" country with "English" language
        When User clicks on the "Account" button
        And User clicks on the "Language" section
        And User select language "<Other Language>"
        And User clicks on the "Done" button
        Then User verifies URL "<Path Language>"

        Examples:
            | Other Language | Path Language |
            | हिंदी          | hi-in/profile |
            | मराठी          | mr-in/profile |
            | తెలుగు         | te-in/profile |
            | ਪੰਜਾਬੀ         | pa-in/profile |
            | বাংলা          | bn-in/profile |
            | ગુજરાતી        | gu-in/profile |
            | ಕನ್ನಡ          | kn-in/profile |
            | தமிழ்          | ta-in/profile |
