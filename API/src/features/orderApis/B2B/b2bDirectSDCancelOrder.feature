@api
Feature: API create a B2B Direct order

    @b2bDirectCancelOrder
    Scenario: B2B Direct Sub dealer cancels order
        # Create the B2b direct order
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
        # Cancel the b2b direct order
        And I set path params:
            | key | value       |
            | id  | {{orderId}} |
        And I build payload from 'order/b2bDirect/b2bDirectSubDealerCancelOrder'
        When I send 'PATCH' request to 'b2bDirectlOrderAction' on 'th_marketplace_service_yc_token' service
        Then The response status should be 200

        # Verify the order after cancel - sub dealer
        # Generate jwt_token for sub dealer
        Given I build dynamic payload from 'aclToken/aclTokenShopID915443332223' with:
            | key         | value                                |
            | buyerId     | c1963b61-18c2-43a0-b1d2-93635ee5c4ce |
            | buyerShopId | be065c87-87ce-4824-a821-97395b72d0f3 |
        And I send 'POST' request to 'aclToken' on 'th_marketplace_service_yc_token' service
        Then I extract from response:
            | variable | path       |
            | jwtToken | data.token |

        # Verify order in Sub dealer side: Buyer
        When I wait for 10 seconds
        And I set path params:
            | key | value       |
            | id  | {{orderId}} |
        Given I build dynamic headers with:
            | key               | value               |
            | jwt-authorization | Bearer {{jwtToken}} |
        When I send 'GET' request to 'orderID' on 'th_marketplace_service_yc_token' service
        Then The response status should be 200
        And The response should match json "orders/b2bDirect/b2bDirectOrder" with:
            | key                     | value                       |
            | data.orderId            | {{orderId}}                 |
            | data.rejectedBy         | BUYER                       |
            | data.OrderStatus        | CANCELLED                   |
            | data.cancellationReason | Incorrect Order Information |
            | data.orderNumber        | IGNORE                      |
            | data.createdAt          | IGNORE                      |
            | data.transactionDate    | IGNORE                      |

        # Cancel order that already cancelled
        And I set path params:
            | key | value       |
            | id  | {{orderId}} |
        And I build payload from 'order/b2bDirect/b2bDirectSubDealerCancelOrder'
        When I send 'PATCH' request to 'b2bDirectlOrderAction' on 'th_marketplace_service_yc_token' service
        Then The response status should be 409
        And The response should match json "orders/b2bDirect/orderCancelledByBuyer"

    @b2bDirectCancelOrderInvalidToken
    Scenario: B2B Direct Sub dealer cancels order with invalid token
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

    @b2bDirectCancelOrderIdInvalid
    # OrderId is not a UUID
    # OrderId is a UUID but not exist in the system
    # OrderId is a UUID but exist in the system but not belong to the sub dealer
    # OrderId is a UUID but exist in the system but already fulfilled
    # OrderId is a UUID but exist in the system but already cancelled by buyer
    # OrderId is a UUID but exist in the system but already rejected by seller
    # OrderId is a UUID but exist in the system but already accepted by seller
    Scenario: B2B Direct Sub dealer cancels order with invalid orderId
        Given I am "valid_token" authenticated on "th_marketplace_service_yc_token" service with the phone number "915555500076"
        And I set path params:
            | key | value       |
            | id  | <invalidId> |
        And I build payload from 'order/b2bDirect/b2bDirectSubDealerCancelOrder'
        When I send 'PATCH' request to 'b2bDirectlOrderAction' on 'th_marketplace_service_yc_token' service
        Then The response status should be <status>
        And The response should match json "<response>"

        Examples:
            | invalidId                            | response                               | status |
            | 123                                  | responseError/messageObject            | 400    |
            | 00000000-0000-0000-0000-000000000000 | responseError/notFound                 | 404    |
            | 57d6d114-5ec5-46eb-977f-5a0548f01c93 | responseError/forbidden                | 403    |
            | fddcf3c9-1644-487d-95bf-5307693a5fa4 | responseError/badRequest               | 400    |
            | 11b0055b-3736-41cc-9b07-5e9e019e03f9 | orders/b2bDirect/orderCancelledByBuyer | 409    |
            | c210a3ad-a6b2-48ba-9012-ada26ed21f7b | orders/b2bDirect/orderCancelBySeller   | 409    |
            | c1963b61-18c2-43a0-b1d2-93635ee5c4ce | responseError/notFound                 | 404    |
