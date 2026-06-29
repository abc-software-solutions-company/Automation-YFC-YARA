Feature: Shop information

    @shopInformation-Malaysia
    Scenario Outline: Verify shop information - MY

        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the element with class containing "address location dropdown"
        And User clicks on the "Change location" button
        And User enters "<Capital>" into the "Placeholder in location search box" field and selects from dropdown
        And User clicks on the "Confirm location" button
        When User clicks on "View all button" in the "Stores near you section" section
        And User enters "<Shop name>" into the "Search box" field
        And User presses the "Enter" key
        And User selects the "<Shop name>" shop
        And User clicks on the "Open shop information" button
        Then User verifies the "Shop info" text is "visible"
        And User verifies the "<Person in charge>" text is "visible"
        And User verifies the "<Shop name>" text is "visible"
        And User verifies the "<Registration number>" text is "visible"
        And User verifies the "<Phone number>" text is "visible"
        And User verifies the "<Email>" text is "visible"

        Examples:
            | Country  | Language | Capital      | Shop name      | Person in charge | Registration number | Phone number | Email                |
            | Malaysia | English  | Kuala Lumpur | Diem bussiness | Dime UAT         | 039702701800        | +60123345669 | diem.nguyen@yara.com |