@getHelpCreateRequest
Feature: Get Help Create Request flow
    Background:
    @gethelp-submit-request
    Scenario: Verify that the user can create a new request successfully
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the "Submit new request" section
        Then User verifies the "Submit new request" text is "visible"

        When User enters "<First name>" into the "First name field" field
        And User enters "<Last name>" into the "Last name field" field
        And User selects "Agronomic enquiry" from the "Select topic field" dropdown in Get Help
        And User enters "<Crops>" into the "Crops field" field
        And User enters "Test Request" into the "Subject field" field
        And User enters "This is a test" into the "Describe your issue field" textarea
        And User enters "iPhone 15" into the "Phone model or OS field" field
        And User clicks on the "Create request" button
        Then User verifies the "Feedback submitted!" text is "visible"
        And User verifies the "Support ticket ID:" text is "visible"
        And User verifies the "Your feedback has been submitted." text is "visible"
        And User verifies the "Back to home" text is "visible"

        Examples:
            | Country   | Language | First name | Last name | Crops                   |
            | Malaysia  | English  | DiemMYY    | Test      | Leafy Vegetable, Durian |
            | Thailand  |          | DIEM       | TLD       | มะเขือเทศ, ส้มโอ        |
            | Indonesia |          | Test       | IN        | Kacang Panjang          |
            | India     | English  | DiemIN     | Test      | Rice                    |
            | Tanzania  | English  | DiemTZ     | Test      | Maize                   |
            | VietNam   | English  | DiemVN     | Test      | Rice                    |

    @gethelp-submit-request-kenya
    Scenario: Verify that Kenya user can create a new request successfully (with County field)
        Given User goes to dashboard page in the "Kenya" country with "" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the "Submit new request" section
        Then User verifies the "Submit new request" text is "visible"

        When User enters "DiemKE" into the "First name field" field
        And User enters "Test" into the "Last name field" field
        And User selects "Kenya (+254)" from the "County" dropdown in Get Help
        And User selects "Agronomic enquiry" from the "Select topic field" dropdown in Get Help
        And User enters "Maize" into the "Crops field" field
        And User enters "Test Request" into the "Subject field" field
        And User enters "This is a test" into the "Describe your issue field" textarea
        And User enters "iPhone 15" into the "Phone model or OS field" field
        And User clicks on the "Create request" button
        Then User verifies the "Feedback submitted!" text is "visible"
        And User verifies the "Support ticket ID:" text is "visible"
        And User verifies the "Your feedback has been submitted." text is "visible"
        And User verifies the "Back to home" text is "visible"

    @gethelp-submit-request-all-empty
    Scenario: Verify the Create request button is disabled when all required fields are empty
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the "Submit new request" section
        Then User verifies the "Submit new request" text is "visible"
        And User verify the "Create request" button is "disabled"

        Examples:
            | Country   | Language |
            | Malaysia  | English  |
            | Thailand  |          |
            | Indonesia |          |
            | India     | English  |
            | Kenya     |          |
            | Tanzania  | English  |
            | VietNam   | English  |

    @gethelp-upload-wrong-file-type
    Scenario: Verify error message when uploading wrong file type
        Given User goes to dashboard page in the "Malaysia" country with "English" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the "Submit new request" section
        Then User verifies the "Submit new request" text is "visible"
        When User uploads "src/data/zendesk/test.txt" file in Get Help
        Then User verifies the "File type not supported. Accepted types: image/*, application/pdf" text is "visible"

    @gethelp-upload-oversize-file
    Scenario: Verify error message when uploading file larger than 5MB
        Given User goes to dashboard page in the "Malaysia" country with "English" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the "Submit new request" section
        Then User verifies the "Submit new request" text is "visible"
        When User uploads "src/data/zendesk/image10mb.jpg" file in Get Help
        Then User verifies the "File size cannot exceed 5 MB" text is "visible"
