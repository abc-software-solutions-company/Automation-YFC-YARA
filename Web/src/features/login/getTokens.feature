Feature: Dashboard Page

    Background:

    @GetFCTokenID
    Scenario: Verify user can open the Sign up / Login page
        Given User goes to landing page
        When User selects on the 'Indonesia' country and select English
        And User clicks on the "Sign up / Login button" button
        When User clicks on the "Country code" section
        And User clicks on the element of data-testid "India (+91)"
        And User enters "<phoneNumber>" into the "Mobile number" field
        When User clicks on the "Send code via SMS" button
        And User types the otp of the "<otpPhoneNumber>" phone number
        And User clicks on the "Confirm" button
        Then I capture token and save to "tokenFCID.csv"

        Examples:
            | phoneNumber | otpPhoneNumber |
            | 7122216483  | +917122216483  |