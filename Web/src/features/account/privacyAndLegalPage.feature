@privacyAndLegal
Feature: Privacy And Legal  in My Profile
    Background:

    Scenario Outline: user should be able to view the privacy and legal section in my profile
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User clicks on the "<Account>" button
        And User clicks on the "Privacy and legal" section

        And User verify the "Privacy and legal" header is "visible"
        And User verify the "Communication" text exactly is "visible"
        And User verify the "Marketing communications" text exactly is "visible"
        And User clicks on the "Marketing communications" section

        And User verify the "Manage communications" header is "visible"
        And User verify the "Manage your communication preferences" text exactly is "visible"
        And User verify the "Communications and advertising" text exactly is "visible"
        And User "on" the "Communications and advertising" toggle
        And User verifies the "Description of Communications and advertising" text is "visible"
        And User clicks on the "What will I receive?" section

        And User verify the "What will I receive" header is "visible"
        And User verify the link "customer support" should be "visible"
        And User goes to "privacy-and-legal" page

        And User verify the "Privacy" text exactly is "visible"
        And User clicks on the "Digital Farming Terms" section
        And User verify the "Digital Farming Terms" text exactly is "visible"

        And User clicks on the element of data-testid "close"

        And User clicks on the "Privacy Policy" section
        And User verify the "Privacy Policy" text exactly is "visible"

        And User clicks on the element of data-testid "close"

        Examples:
            | Country   | Language | Account |
            | India     | English  | Account |
            | Kenya     | English  | Account |
            | Indonesia | Bahasa   | Akun    |
            | Thailand  | Thai     | บัญชี   |
            | VietNam   | English  | Account |
            | Tanzania  | English  | Account |
            | Malaysia  | English  | Account |
