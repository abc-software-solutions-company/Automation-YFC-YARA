@getHelpMyRequests
Feature: Get Help My Request flow
    Background:
    @gethelp-my-requests-overview
    Scenario: Verify the My requests page displays correctly
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User clicks on the exact "My requests" section
        Then User verifies the "My requests" text is "visible"
        And User verifies the "Search by topic name or ID" field is "visible"
        And User verifies the "Filter New" text is "visible"
        And User verifies the "Filter Open" text is "visible"
        And User verifies the "Filter Needs response" text is "visible"
        And User verifies the "Filter Solved" text is "visible"
        And User verifies the "Filter Closed" text is "visible"

        Examples:
            | Country   | Language |
            | Malaysia  | English  |
            | Thailand  |          |
            | Indonesia |          |
            | India     | English  |
            | Kenya     |          |
            | Tanzania  | English  |
            | VietNam   | English  |

    @gethelp-my-requests-search
    Scenario: Verify the user can submit a request and search it in My requests
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the exact "Submit new request" section
        Then User verifies the "Submit new request" text is "visible"
        When User enters "<First name>" into the "First name field" field
        And User enters "<Last name>" into the "Last name field" field
        And User selects "Agronomic enquiry" from the "Select topic field" dropdown in Get Help
        And User enters "Test Request" into the "Subject field" field
        And User enters "This is a test" into the "Describe your issue field" textarea
        And User clicks on the "Create request" button
        Then User verifies the "Feedback submitted!" text is "visible"
        And User saves the ticket ID in Get Help

        When User clicks on the "Back to home" button
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User clicks on the exact "My requests" section
        Then User verifies the "My requests" text is "visible"
        When User searches the saved ticket ID into the "Search by topic name or ID" field
        Then User verifies the saved ticket ID is visible in Get Help

        Examples:
            | Country   | Language | First name | Last name |
            | Malaysia  | English  | DiemMYY    | Test      |
            | Thailand  |          | DIEM       | TLD       |
            | Indonesia |          | Test       | IN        |
            | India     | English  | DiemIN     | Test      |
            | Tanzania  | English  | DiemTZ     | Test      |
            | VietNam   | English  | DiemVN     | Test      |

    @gethelp-my-requests-search-kenya
    Scenario: Verify Kenya user can submit a request and search it in My requests (with County field)
        Given User goes to dashboard page in the "Kenya" country with "" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the exact "Submit new request" section
        Then User verifies the "Submit new request" text is "visible"
        When User enters "DiemKE" into the "First name field" field
        And User enters "Test" into the "Last name field" field
        And User selects "Kenya (+254)" from the "County" dropdown in Get Help
        And User selects "Agronomic enquiry" from the "Select topic field" dropdown in Get Help
        And User enters "Test Request" into the "Subject field" field
        And User enters "This is a test" into the "Describe your issue field" textarea
        And User clicks on the "Create request" button
        Then User verifies the "Feedback submitted!" text is "visible"
        And User saves the ticket ID in Get Help

        When User clicks on the "Back to home" button
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User clicks on the exact "My requests" section
        Then User verifies the "My requests" text is "visible"
        When User searches the saved ticket ID into the "Search by topic name or ID" field
        Then User verifies the saved ticket ID is visible in Get Help

    @gethelp-my-requests-filter
    Scenario: Verify the user can filter requests by status
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the exact "My requests" section
        Then User verifies the "My requests" text is "visible"
        When User clicks on the exact "Filter New" section
        Then User verifies the "Filter New" text is "visible"

        Examples:
            | Country   | Language |
            | Malaysia  | English  |
            | Thailand  |          |
            | Indonesia |          |
            | India     | English  |
            | Kenya     |          |
            | Tanzania  | English  |
            | VietNam   | English  |

    @gethelp-my-requests-navigate-new-request
    Scenario: Verify the user can navigate to submit new request from My requests page
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User clicks on the exact "My requests" section
        Then User verifies the "My requests" text is "visible"
        When User clicks on the "+" icon button in Get Help
        Then User verifies the "Submit new request" text is "visible"

        Examples:
            | Country   | Language |
            | Malaysia  | English  |
            | Thailand  |          |
            | Indonesia |          |
            | India     | English  |
            | Kenya     |          |
            | Tanzania  | English  |
            | VietNam   | English  |
