@api
Feature: API create a B2B Direct order

    @b2bDirectOrderApisValidTokenAndData
    Scenario: B2B Direct order in TH country
        # ------------- Created order ---------
        Given I am "valid_token" authenticated on "th_marketplace_service_yc_token" service with the phone number "915555500076"
        And I build dynamic payload from 'order/b2bDirect/b2bDirectOrder' with:
            | key                       | value         |
            | order.correlationId       | {{$uuid}}     |
            | order.metaInfo.pickupDate | {{$tomorrow}} |
        When I send 'POST' request to 'b2bDirectOrder' on 'th_marketplace_service_yc_token' service
        Then The response status should be 201
        Then I extract from response:
            | variable | path         |
            | orderId  | data.orderId |

        # ----------- Verify the order ---------
        # Verify order in Sub dealer side: Buyer
        # Get jwt_token for buyer
        Given I build dynamic payload from 'aclToken/aclTokenShopID915443332223' with:
            | key         | value                                |
            | buyerId     | c1963b61-18c2-43a0-b1d2-93635ee5c4ce |
            | buyerShopId | be065c87-87ce-4824-a821-97395b72d0f3 |
        When I send 'POST' request to 'aclToken' on 'th_marketplace_service_yc_token' service
        Then I extract from response:
            | variable | path       |
            | jwtToken | data.token |
        # Verify order in Sub dealer side: Buyer
        And I set path params:
            | key | value       |
            | id  | {{orderId}} |
        Given I build dynamic headers with:
            | key               | value               |
            | jwt-authorization | Bearer {{jwtToken}} |

        When I send 'GET' request to 'orderID' on 'th_marketplace_service_yc_token' service
        Then The response status should be 200
        And The response should match json "orders/b2bDirect/b2bDirectOrder" with:
            | key                  | value       |
            | data.orderId         | {{orderId}} |
            | data.orderNumber     | IGNORE      |
            | data.createdAt       | IGNORE      |
            | data.transactionDate | IGNORE      |

    @b2bDirectOrderApisInValidToken
    Scenario: B2B Direct order in TH country
        Given I am "<invalid_token>" authenticated on "th_marketplace_service_yc_token" service with the phone number "915555500076"
        And I build dynamic payload from 'order/b2bDirect/b2bDirectOrder' with:
            | key                       | value         |
            | order.correlationId       | {{$uuid}}     |
            | order.metaInfo.pickupDate | {{$tomorrow}} |
        When I send 'POST' request to 'b2bDirectOrder' on 'th_marketplace_service_yc_token' service
        Then The response status should be 401
        And The response should match json "<response>"

        Examples:
            | invalid_token | response                         |
            | invalid_token | orders/invalidToken/invalidToken |
            | no_token      | orders/invalidToken/invalidToken |

@b2bDirectOrderApisInValidToken




