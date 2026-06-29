@api
Feature: Clone discount
    # =================
    # TESt CASSE: https://yara.sharepoint.com/:x:/r/sites/DigitalValueChainSolutionsYAA-DVCSDigitalLabs/_layouts/15/Doc.aspx?sourcedoc=%7B587F1B4D-5613-4C78-91D7-C4458DF704B2%7D&file=FC%20Discount%20Enhancement%20TC%27s%20.xlsx&action=default&mobileredirect=true
    # ===============

    @CloneDiscountFromPlannedDiscount
    Scenario: Clone a discount from Planned discount
        # =========Get Planned discount==========
        Given I build dynamic headers with:
            | key      | value       |
            | tenantId | <tenant ID> |
        And I am "valid_token" authenticated on "discount_service" service
        And I build dynamic payload from "discount/getListDiscount/getListDiscount" with:
            | key         | value    |
            | currentDate | {{$now}} |
        When I send "POST" request to "adminGetListDiscounts" on "discount_service" service
        Then The response status should be 200
        And I extract from response:
            | variable          | path        |
            | discountId source | data[0]._id |

        # ==========Clone Planned discount==========
        And I build payload from "discount/cloneDiscount/cloneDiscount"
        And I set path params:
            | key | value                 |
            | id  | {{discountId source}} |
        When I send "POST" request to "cloneDiscount" on "discount_service" service
        Then The response status should be 200
        And The response should match json "discountService/cloneDiscount/cloneDiscount" with:
            | key             | value  |
            | data.discountId | IGNORE |
        And I extract from response:
            | variable         | path            |
            | discountIdTarget | data.discountId |

        # =========Verify the discount after Clone==========
        When I set path params:
            | key | value                |
            | id  | {{discountIdTarget}} |
        And I send "GET" request to "discountID" on "discount_service" service
        Then The response status should be 200
        And The response should contain data:
            | key         | value                |
            | data._id    | {{discountIdTarget}} |
            | status      | success              |
            | code        | 200                  |
            | data.status | Draft                |

        Examples:
            | tenant ID                            |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 |
            | 32c89363-b532-468a-8828-d2a72038c7c1 |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b |

    @CloneDiscountFromExpiredDiscount
    Scenario: Clone a discount from Expired discount
        # =========Get Planned discount==========
        Given I build dynamic headers with:
            | key      | value       |
            | tenantId | <tenant ID> |
        And I am "valid_token" authenticated on "discount_service" service
        And I build dynamic payload from "discount/getListDiscount/getListDiscount" with:
            | key         | value       |
            | currentDate | {{$now}}    |
            | status      | ["Expired"] |
        When I send "POST" request to "adminGetListDiscounts" on "discount_service" service
        Then The response status should be 200
        And I extract from response:
            | variable          | path        |
            | discountId source | data[0]._id |

        # ==========Clone Planned discount==========
        And I build payload from "discount/cloneDiscount/cloneDiscount"
        And I set path params:
            | key | value                 |
            | id  | {{discountId source}} |
        When I send "POST" request to "cloneDiscount" on "discount_service" service
        Then The response status should be 200
        And The response should match json "discountService/cloneDiscount/cloneDiscount" with:
            | key             | value  |
            | data.discountId | IGNORE |
        And I extract from response:
            | variable         | path            |
            | discountIdTarget | data.discountId |

        # =========Verify the discount after Clone==========
        When I set path params:
            | key | value                |
            | id  | {{discountIdTarget}} |
        And I send "GET" request to "discountID" on "discount_service" service
        Then The response status should be 200
        And The response should contain data:
            | key         | value                |
            | data._id    | {{discountIdTarget}} |
            | status      | success              |
            | code        | 200                  |
            | data.status | Draft                |

        Examples:
            | tenant ID                            |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 |
            | 32c89363-b532-468a-8828-d2a72038c7c1 |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b |

    @CloneDiscountFromActiveDiscount
    Scenario: Clone a discount from Active discount
        # =========Get Planned discount==========
        Given I build dynamic headers with:
            | key      | value       |
            | tenantId | <tenant ID> |
        And I am "valid_token" authenticated on "discount_service" service
        And I build dynamic payload from "discount/getListDiscount/getListDiscount" with:
            | key         | value      |
            | currentDate | {{$now}}   |
            | status      | ["Active"] |
        When I send "POST" request to "adminGetListDiscounts" on "discount_service" service
        Then The response status should be 200
        And I extract from response:
            | variable          | path        |
            | discountId source | data[0]._id |

        # ==========Clone Planned discount==========
        And I build payload from "discount/cloneDiscount/cloneDiscount"
        And I set path params:
            | key | value                 |
            | id  | {{discountId source}} |
        When I send "POST" request to "cloneDiscount" on "discount_service" service
        Then The response status should be 200
        And The response should match json "discountService/cloneDiscount/cloneDiscount" with:
            | key             | value  |
            | data.discountId | IGNORE |
        And I extract from response:
            | variable         | path            |
            | discountIdTarget | data.discountId |

        # =========Verify the discount after Clone==========
        When I set path params:
            | key | value                |
            | id  | {{discountIdTarget}} |
        And I send "GET" request to "discountID" on "discount_service" service
        Then The response status should be 200
        And The response should contain data:
            | key         | value                |
            | data._id    | {{discountIdTarget}} |
            | status      | success              |
            | code        | 200                  |
            | data.status | Draft                |

        Examples:
            | tenant ID                            |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 |
            | 32c89363-b532-468a-8828-d2a72038c7c1 |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b |

    @CloneDiscountFromDraftDiscount
    Scenario: Clone a discount from Draft discount
        # =========Get Planned discount==========
        Given I build dynamic headers with:
            | key      | value       |
            | tenantId | <tenant ID> |
        And I am "valid_token" authenticated on "discount_service" service
        And I build dynamic payload from "discount/getListDiscount/getListDiscount" with:
            | key         | value     |
            | currentDate | {{$now}}  |
            | status      | ["Draft"] |
        When I send "POST" request to "adminGetListDiscounts" on "discount_service" service
        Then The response status should be 200
        And I extract from response:
            | variable          | path        |
            | discountId source | data[0]._id |

        # ==========Clone Planned discount==========
        And I build payload from "discount/cloneDiscount/cloneDiscount"
        And I set path params:
            | key | value                 |
            | id  | {{discountId source}} |
        When I send "POST" request to "cloneDiscount" on "discount_service" service
        Then The response status should be 200
        And The response should match json "discountService/cloneDiscount/cloneDiscount" with:
            | key             | value  |
            | data.discountId | IGNORE |
        And I extract from response:
            | variable         | path            |
            | discountIdTarget | data.discountId |

        # =========Verify the discount after Clone==========
        When I set path params:
            | key | value                |
            | id  | {{discountIdTarget}} |
        And I send "GET" request to "discountID" on "discount_service" service
        Then The response status should be 200
        And The response should contain data:
            | key         | value                |
            | data._id    | {{discountIdTarget}} |
            | status      | success              |
            | code        | 200                  |
            | data.status | Draft                |

        Examples:
            | tenant ID                            |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 |
            | 32c89363-b532-468a-8828-d2a72038c7c1 |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b |

    @CloneDiscountWithInvalidToken
    Scenario: Clone a discount with Invalid token

        # ==========Clone discount with Invalid token==========
        Given I build dynamic headers with:
            | key      | value       |
            | tenantId | <tenant ID> |
        And I am "<invalid_token>" authenticated on "discount_service" service
        And I build payload from "discount/cloneDiscount/cloneDiscount"
        And I set path params:
            | key | value |
            | id  | id    |
        When I send "POST" request to "cloneDiscount" on "discount_service" service
        Then The response status should be 401
        And The response should match json "<response payload>"


        Examples:
            | tenant ID                            | invalid_token | response payload                          |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | invalid_token | discountService/invalidToken/invalidToken |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | no_token      | discountService/invalidToken/unauthorized |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | invalid_token | discountService/invalidToken/invalidToken |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | no_token      | discountService/invalidToken/unauthorized |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | invalid_token | discountService/invalidToken/invalidToken |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | no_token      | discountService/invalidToken/unauthorized |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | invalid_token | discountService/invalidToken/invalidToken |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | no_token      | discountService/invalidToken/unauthorized |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | invalid_token | discountService/invalidToken/invalidToken |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | no_token      | discountService/invalidToken/unauthorized |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | invalid_token | discountService/invalidToken/invalidToken |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | no_token      | discountService/invalidToken/unauthorized |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | invalid_token | discountService/invalidToken/invalidToken |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | no_token      | discountService/invalidToken/unauthorized |

    @CloneDiscountWithInvalidBuUserId
    Scenario: Clone a discount with Invalid BuUser ID
        # =========Get Planned discount==========
        Given I build dynamic headers with:
            | key      | value       |
            | tenantId | <tenant ID> |
        And I am "valid_token" authenticated on "discount_service" service
        And I build dynamic payload from "discount/getListDiscount/getListDiscount" with:
            | key         | value     |
            | currentDate | {{$now}}  |
            | status      | ["Draft"] |
        When I send "POST" request to "adminGetListDiscounts" on "discount_service" service
        Then The response status should be 200
        And I extract from response:
            | variable          | path        |
            | discountId source | data[0]._id |
        # ==========Clone discount with Invalid data==========
        And I build dynamic payload from "discount/cloneDiscount/cloneDiscount" with:
            | key      | value            |
            | buUserId | <buUserId value> |
        And I set path params:
            | key | value                 |
            | id  | {{discountId source}} |
        When I send "POST" request to "cloneDiscount" on "discount_service" service
        Then The response status should be 422
        And The response should match json "<response payload>"

        Examples:
            | tenant ID                            | buUserId value | response payload                                           |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | null           | discountService/cloneDiscount/cloneDiscountNullBuUserId    |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed |                | discountService/cloneDiscount/cloneDiscountEmptyBuUserId   |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | 1234           | discountService/cloneDiscount/cloneDiscountInvalidBuUserId |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | null           | discountService/cloneDiscount/cloneDiscountNullBuUserId    |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 |                | discountService/cloneDiscount/cloneDiscountEmptyBuUserId   |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | 1234           | discountService/cloneDiscount/cloneDiscountInvalidBuUserId |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | null           | discountService/cloneDiscount/cloneDiscountNullBuUserId    |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 |                | discountService/cloneDiscount/cloneDiscountEmptyBuUserId   |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | 1234           | discountService/cloneDiscount/cloneDiscountInvalidBuUserId |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | null           | discountService/cloneDiscount/cloneDiscountNullBuUserId    |
            | 32c89363-b532-468a-8828-d2a72038c7c1 |                | discountService/cloneDiscount/cloneDiscountEmptyBuUserId   |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | 1234           | discountService/cloneDiscount/cloneDiscountInvalidBuUserId |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | null           | discountService/cloneDiscount/cloneDiscountNullBuUserId    |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 |                | discountService/cloneDiscount/cloneDiscountEmptyBuUserId   |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | 1234           | discountService/cloneDiscount/cloneDiscountInvalidBuUserId |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | null           | discountService/cloneDiscount/cloneDiscountNullBuUserId    |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f |                | discountService/cloneDiscount/cloneDiscountEmptyBuUserId   |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | 1234           | discountService/cloneDiscount/cloneDiscountInvalidBuUserId |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | null           | discountService/cloneDiscount/cloneDiscountNullBuUserId    |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b |                | discountService/cloneDiscount/cloneDiscountEmptyBuUserId   |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | 1234           | discountService/cloneDiscount/cloneDiscountInvalidBuUserId |

    @CloneDiscountWithBuUserIdVersions
    # Version 1: f47ac10b-58cc-11ef-b864-0242ac120002
    # Version 2: 000003e8-58cc-21ef-8200-0242ac120002
    # Version 3: a3bb189e-8bf9-3888-9912-abbf80a54d42
    # Version 5: 2ed6657d-e927-568b-95e3-af9b995d9b5d
    Scenario: Clone a discount with Invalid BuUser ID
        # =========Get Planned discount==========
        Given I build dynamic headers with:
            | key      | value       |
            | tenantId | <tenant ID> |
        And I am "valid_token" authenticated on "discount_service" service
        And I build dynamic payload from "discount/getListDiscount/getListDiscount" with:
            | key         | value     |
            | currentDate | {{$now}}  |
            | status      | ["Draft"] |
        When I send "POST" request to "adminGetListDiscounts" on "discount_service" service
        Then The response status should be 200
        And I extract from response:
            | variable          | path        |
            | discountId source | data[0]._id |
        # ==========Clone discount with Invalid data==========
        And I build dynamic payload from "discount/cloneDiscount/cloneDiscount" with:
            | key      | value            |
            | buUserId | <buUserId value> |
        And I set path params:
            | key | value                 |
            | id  | {{discountId source}} |
        When I send "POST" request to "cloneDiscount" on "discount_service" service
        Then The response status should be 200
        And The response should match json "discountService/cloneDiscount/cloneDiscount" with:
            | key             | value  |
            | data.discountId | IGNORE |
        And I extract from response:
            | variable         | path            |
            | discountIdTarget | data.discountId |
        # =========Verify the discount after Clone==========
        When I set path params:
            | key | value                |
            | id  | {{discountIdTarget}} |
        And I send "GET" request to "discountID" on "discount_service" service
        Then The response status should be 200
        And The response should contain data:
            | key         | value                |
            | data._id    | {{discountIdTarget}} |
            | status      | success              |
            | code        | 200                  |
            | data.status | Draft                |


        Examples:
            | tenant ID                            | buUserId value                       |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | f47ac10b-58cc-11ef-b864-0242ac120002 |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | 000003e8-58cc-21ef-8200-0242ac120002 |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | a3bb189e-8bf9-3888-9912-abbf80a54d42 |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | f47ac10b-58cc-11ef-b864-0242ac120002 |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | a3bb189e-8bf9-3888-9912-abbf80a54d42 |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | f47ac10b-58cc-11ef-b864-0242ac120002 |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | a3bb189e-8bf9-3888-9912-abbf80a54d42 |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | f47ac10b-58cc-11ef-b864-0242ac120002 |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | a3bb189e-8bf9-3888-9912-abbf80a54d42 |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | f47ac10b-58cc-11ef-b864-0242ac120002 |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | a3bb189e-8bf9-3888-9912-abbf80a54d42 |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | f47ac10b-58cc-11ef-b864-0242ac120002 |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | a3bb189e-8bf9-3888-9912-abbf80a54d42 |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | f47ac10b-58cc-11ef-b864-0242ac120002 |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | 2ed6657d-e927-568b-95e3-af9b995d9b5d |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | a3bb189e-8bf9-3888-9912-abbf80a54d42 |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | 2ed6657d-e927-568b-95e3-af9b995d9b5d |

    @CloneDiscountWithInvalidDiscountId
    Scenario: Clone a discount with Invalid discount ID
        Given I build dynamic headers with:
            | key      | value       |
            | tenantId | <tenant ID> |
        And I am "valid_token" authenticated on "discount_service" service
        And I build dynamic payload from "discount/cloneDiscount/cloneDiscount" with:
            | key      | value            |
            | buUserId | <buUserId value> |
        And I set path params:
            | key | value               |
            | id  | <discountId source> |
        When I send "POST" request to "cloneDiscount" on "discount_service" service
        Then The response status should be 400
        And The response should match json "discountService/cloneDiscount/cloneDiscountNullDiscountId" with:
            | key     | value              |
            | message | <message response> |

        Examples:
            | tenant ID                            | buUserId value                       | discountId source | message response              |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | 242232bd-6435-4fc8-b76d-893cbfa68904 | null              | Discount null does not exist. |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | 242232bd-6435-4fc8-b76d-893cbfa68904 | 1234              | Discount 1234 does not exist. |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | f1731103-669c-41ae-be53-33fff69a6d3a | null              | Discount null does not exist. |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | f1731103-669c-41ae-be53-33fff69a6d3a | 1234              | Discount 1234 does not exist. |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | 335d51c0-78fe-4fe3-a680-4f0d53bbf949 | null              | Discount null does not exist. |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | 335d51c0-78fe-4fe3-a680-4f0d53bbf949 | 1234              | Discount 1234 does not exist. |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | 8f038f5f-5342-49c2-9afd-f51aff4f9c6a | null              | Discount null does not exist. |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | 8f038f5f-5342-49c2-9afd-f51aff4f9c6a | 1234              | Discount 1234 does not exist. |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | b062884c-3c9a-44c2-ab3b-d678b2670953 | null              | Discount null does not exist. |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | b062884c-3c9a-44c2-ab3b-d678b2670953 | 1234              | Discount 1234 does not exist. |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | 9962b6fb-219f-4020-9808-e02af6082b64 | null              | Discount null does not exist. |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | 9962b6fb-219f-4020-9808-e02af6082b64 | 1234              | Discount 1234 does not exist. |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | 3256ec8e-3c5c-445d-b155-9f9ce848b4b7 | null              | Discount null does not exist. |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | 3256ec8e-3c5c-445d-b155-9f9ce848b4b7 | 1234              | Discount 1234 does not exist. |
