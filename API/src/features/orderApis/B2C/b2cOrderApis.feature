@api
Feature: API create a B2C order

    @b2cOrderApisValidTokenAndDataB2C1
    Scenario: B2C order in all country: The order applies coupon, YC approves the order
        Given I am 'valid_token' authenticated on 'marketplace_service' service for '<countryCode>' country
        And I build dynamic payload from '<orderPayloadFormat>' with:
            | key                             | value |
            | orderDetails[0].orderedQuantity | 2     |
        When I send 'POST' request to 'orders' on '<serviceName>' service
        Then The response status should be 201
        Then I extract from response:
            | variable | path         |
            | orderId  | data.orderId |

        # Get the couponCode
        Given I set path params:
            | key | value       |
            | id  | {{orderId}} |
        And I build dynamic query params with:
            | key    | value |
            | format | json  |
        When I send 'GET' request to 'ordersQrCode' on '<serviceName>' service
        Then The response status should be 200
        Then I extract from response:
            | variable   | path       |
            | couponCode | couponCode |

        # YC (retailer) fulfills order -- third parties
        # Get jwt_token
        And I build payload from '<aclTokenPayloadFormat>'
        When I send 'POST' request to 'aclToken' on '<serviceName>' service
        Then I extract from response:
            | variable | path       |
            | jwtToken | data.token |
        # Retailer fulfils order
        Given I am "valid_token" authenticated on "<marketplace_service_yc_token>" service with the phone number "<seller phone number>"
        And I build dynamic payload from "<fulfillPayloadFormat>" with:
            | key        | value          |
            | couponCode | {{couponCode}} |
        And I set path params:
            | key | value       |
            | id  | {{orderId}} |
        Given I build dynamic headers with:
            | key               | value               |
            | jwt-authorization | Bearer {{jwtToken}} |
        When I send "PATCH" request to "orderID" on "<serviceName>" service
        Then The response status should be 200

        # Verify the order after fulfills - seller
        Given I set path params:
            | key | value       |
            | id  | {{orderId}} |
        When I send 'GET' request to 'orderID' on '<serviceName>' service
        Then The response status should be 200
        And The response should match json "<getOrderIDResponseYC>" with:
            | key                     | value          |
            | data.orderNumber        | IGNORE         |
            # | data.orderDate          | IGNORE         |
            | data.orderId            | <orderId>      |
            | data.createdAt          | IGNORE         |
            | data.transactionDate    | IGNORE         |
            | data.couponCode         | {{couponCode}} |
            | data.fulfilledAt        | IGNORE         |
            | data.placedBy.language  | IGNORE         |
            | data.cancellationReason | IGNORE         |

        # Verify the order after fulfills - buyer (context)
        Given I am 'valid_token' authenticated on 'marketplace_service' service for '<countryCode>' country
        Given I set path params:
            | key | value       |
            | id  | {{orderId}} |
        When I send 'GET' request to 'getOrderID' on '<serviceName>' service
        Then The response status should be 200
        And The response should match json "<getOrderIDResponse>" with:
            | key              | value  |
            | data.orderNumber | IGNORE |
            | data.orderDate   | IGNORE |
            | data.language    | IGNORE |
            | data.fulfilledAt | IGNORE |


        Examples:
            | countryCode | orderPayloadFormat            | serviceName            | marketplace_service_yc_token    | fulfillPayloadFormat            | seller phone number | getOrderIDResponse            | getOrderIDResponseYC            | orderId     | aclTokenPayloadFormat               |
            | in          | order/normalOrder/b2cOrdersIN | in_marketplace_service | in_marketplace_service_yc_token | order/normalOrder/b2cFulfillsIN | 915555511801        | orders/getOrderDetail/orderIN | orders/getOrderDetail/orderYCIN | {{orderId}} | aclToken/aclTokenShopID915443332223 |
            | id          | order/normalOrder/b2cOrdersID | id_marketplace_service | id_marketplace_service_yc_token | order/normalOrder/b2cFulfillsID | 915555544001        | orders/getOrderDetail/orderID | orders/getOrderDetail/orderYCID | {{orderId}} | aclToken/aclTokenShopID915555544001 |
            | th          | order/normalOrder/b2cOrdersTH | th_marketplace_service | th_marketplace_service_yc_token | order/normalOrder/b2cFulfillsTH | 66855890332         | orders/getOrderDetail/orderTH | orders/getOrderDetail/orderYCTH | {{orderId}} | aclToken/aclTokenShopID915443332224 |

    @b2cOrderApisInvalidAndNoToken
    Scenario: B2C order in all country: The order applies coupon, YC approves the order
        Given I am '<token>' authenticated on 'marketplace_service' service for '<countryCode>' country
        And I build dynamic payload from '<orderPayloadFormat>' with:
            | key                             | value |
            | orderDetails[0].orderedQuantity | 2     |
        When I send 'POST' request to 'orders' on '<serviceName>' service
        Then The response status should be 401
        Then The response should match json '<response data>'

        Examples:
            | countryCode | token         | orderPayloadFormat            | serviceName            | response data                    |
            | in          | invalid_token | order/normalOrder/b2cOrdersIN | in_marketplace_service | orders/invalidToken/invalidToken |
            | in          | no_token      | order/normalOrder/b2cOrdersIN | in_marketplace_service | orders/invalidToken/invalidToken |
            | id          | invalid_token | order/normalOrder/b2cOrdersID | id_marketplace_service | orders/invalidToken/invalidToken |
            | id          | no_token      | order/normalOrder/b2cOrdersID | id_marketplace_service | orders/invalidToken/invalidToken |
            | th          | invalid_token | order/normalOrder/b2cOrdersTH | th_marketplace_service | orders/invalidToken/invalidToken |
            | th          | no_token      | order/normalOrder/b2cOrdersTH | th_marketplace_service | orders/invalidToken/invalidToken |


    @b2cOrderApisValidTokenAndDataAccessControl-NoACL
    Scenario: B2C order in all country: The order applies coupon, YC approves the order
        Given I am 'valid_token' authenticated on 'marketplace_service' service for '<countryCode>' country
        And I build dynamic payload from '<orderPayloadFormat>' with:
            | key                             | value |
            | orderDetails[0].orderedQuantity | 2     |
        When I send 'POST' request to 'orders' on '<serviceName>' service
        Then The response status should be 201
        Then I extract from response:
            | variable | path         |
            | orderId  | data.orderId |

        # Get the couponCode
        Given I set path params:
            | key | value       |
            | id  | {{orderId}} |
        And I build dynamic query params with:
            | key    | value |
            | format | json  |
        When I send 'GET' request to 'ordersQrCode' on '<serviceName>' service
        Then The response status should be 200
        Then I extract from response:
            | variable   | path       |
            | couponCode | couponCode |

        # YC (retailer) fulfills order -- third parties
        # Retailer fulfils order
        Given I am "valid_token" authenticated on "<marketplace_service_yc_token>" service with the phone number "<seller phone number>"
        And I build dynamic payload from "<fulfillPayloadFormat>" with:
            | key        | value          |
            | couponCode | {{couponCode}} |
        And I set path params:
            | key | value       |
            | id  | {{orderId}} |
        When I send "PATCH" request to "orderID" on "<serviceName>" service
        Then The response status should be 403
        And The response should match json "aclToken/forbidden"


        Examples:
            | countryCode | orderPayloadFormat            | serviceName            | marketplace_service_yc_token    | fulfillPayloadFormat            | seller phone number | orderId     | aclTokenPayloadFormat               |
            | in          | order/normalOrder/b2cOrdersIN | in_marketplace_service | in_marketplace_service_yc_token | order/normalOrder/b2cFulfillsIN | 915555511801        | {{orderId}} | aclToken/aclTokenShopID915443332223 |
            | id          | order/normalOrder/b2cOrdersID | id_marketplace_service | id_marketplace_service_yc_token | order/normalOrder/b2cFulfillsID | 915555544001        | {{orderId}} | aclToken/aclTokenShopID915555544001 |
            | th          | order/normalOrder/b2cOrdersTH | th_marketplace_service | th_marketplace_service_yc_token | order/normalOrder/b2cFulfillsTH | 66855890332         | {{orderId}} | aclToken/aclTokenShopID915443332224 |



