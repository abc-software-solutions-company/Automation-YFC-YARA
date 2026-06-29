@search
Feature: Search functionality

    @global-search1
    Scenario Outline: Search product from home page with valid and invalid text
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the element of class "search bar"
        And User enters "<Keyword>" into the "Search box" field exactly
        And User presses the "Enter" key
        Then User verifies the "<Expected text>" text is "<State>"

        Examples:
            | Country  | Language | Keyword        | Expected text                       | State   |
            | India    | English  | Stopit         | Search results for Stopit           | visible |
            | India    | English  | TTTTTTTTTTTTTT | Sorry, we couldn't find any results | visible |
            | Thailand |          | Yara           | โหลดผลการค้นหาสำหรับ Yara           | visible |

    @global-search2
    Scenario Outline: Navigate to product from global search results
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the element of class "search bar"
        And User enters "<Keyword>" into the "Search box" field exactly
        And User presses the "Enter" key
        And User clicks on the "<Product>" search result
        Then User should see the URL contains "/products/"

        Examples:
            | Country  | Language | Keyword | Product |
            | India    | English  | Stopit  | Stopit  |
            | Thailand |          | Yara    | Yara    |

    @global-search3
    Scenario Outline: Switch between search category tabs
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the element of class "search bar"
        And User enters "<Keyword>" into the "Search box" field exactly
        And User presses the "Enter" key
        And User clicks on the "<Tab>" tab
        Then User verifies the "<Expected text>" text is "visible"

        Examples:
            | Country | Language | Keyword | Tab      | Expected text |
            | India   | English  | Test    | Products | Products      |
            | India   | English  | Test    | services | Services      |

    @catalogue-search4
    Scenario Outline: Search product from shop detail page with catalogue search
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the element with class containing "header_addressSecondaryLabel"
        And User clicks on the "Change location" button
        And User enters "<Capital>" into the "Placeholder in location search box" field and selects from dropdown
        And User clicks on the "Confirm location" button
        When User clicks on "View all button" in the "Stores near you section" section
        And User enters "<Shop name>" into the "Search box" field
        And User presses the "Enter" key
        And User selects the "<Shop name>" shop
        And User enters "<Keyword>" into the "Search box" field exactly
        And User presses the "Enter" key
        Then User verifies the "<Expected text>" text is "<State>"

        Examples:
            | Country | Language | Capital | Shop name    | Keyword      | Expected text                       | State   |
            | India   | English  | Delhi   | AUTO SHOP IN | Stopit       | Products                            | visible |
            | India   | English  | Delhi   | AUTO SHOP IN | TTTTTTTTTTTT | Sorry, we couldn't find any results | visible |
