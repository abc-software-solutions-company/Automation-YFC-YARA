@api
Feature: Create discount
    @createDiscount12
    Scenario: Admin creates discount - Order level
        Given I build dynamic headers with:
            | key      | value       |
            | tenantId | <tenant Id> |
        And I am 'valid_token' authenticated on 'discount_service' service
        And I generate random 4char4digit as "couponCodeValue"
        And I build dynamic payload from "<request payload>" with:
            | key                             | value                |
            | couponCode                      | {{couponCodeValue}}  |
            | startDate                       | {{$now+1h+1m}}       |
            | endDate                         | {{$now+2h+1m}}       |
            | orderLevel.minimumOrderQty.unit | <unit on payload>    |
            | name                            | Discount Level       |
            | discountAppliedFor              | <discountAppliedFor> |
            | discountLevels                  | <discountLevels>     |
        When I send "POST" request to "createDiscount" on "discount_service" service
        Then The response status should be 201
        Then The response should match json "<response file>"
        Examples:
            | tenant Id                            | request payload                                    | response file                                 | discountAppliedFor                   | discountLevels                       | unit on payload |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | discount/createDiscount/createDiscountOrderLevelID | discountService/createDiscount/createDiscount | 2b263df6-1ce4-4b8f-b0f8-dbcaf13841f3 | 82bdb97f-480a-48c7-9ea0-13a37f5be38c | KG_OR_L         |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | discount/createDiscount/createDiscountOrderLevelID | discountService/createDiscount/createDiscount | 2b263df6-1ce4-4b8f-b0f8-dbcaf13841f3 | 82bdb97f-480a-48c7-9ea0-13a37f5be38c | PACKAGING_UNIT  |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | discount/createDiscount/createDiscountOrderLevel   | discountService/createDiscount/createDiscount | 92403b97-73ba-4670-8a78-a87d2d6e21a3 | c5df2d39-ad34-4f65-8b69-b6ed6f18bde6 | KG_OR_L         |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | discount/createDiscount/createDiscountOrderLevel   | discountService/createDiscount/createDiscount | 92403b97-73ba-4670-8a78-a87d2d6e21a3 | c5df2d39-ad34-4f65-8b69-b6ed6f18bde6 | PACKAGING_UNIT  |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | discount/createDiscount/createDiscountOrderLevel   | discountService/createDiscount/createDiscount | 19696a18-9ab8-4a88-ac9c-1bcad8b597ba | ca28d6a3-fc38-41b6-b93f-e7d894b6fd70 | KG_OR_L         |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | discount/createDiscount/createDiscountOrderLevel   | discountService/createDiscount/createDiscount | 19696a18-9ab8-4a88-ac9c-1bcad8b597ba | ca28d6a3-fc38-41b6-b93f-e7d894b6fd70 | PACKAGING_UNIT  |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | discount/createDiscount/createDiscountOrderLevel   | discountService/createDiscount/createDiscount | d146f48a-f318-491b-9639-be8bd43875b8 | 8040350b-71ea-40da-ad3a-7af1f291aa5f | KG_OR_L         |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | discount/createDiscount/createDiscountOrderLevel   | discountService/createDiscount/createDiscount | d146f48a-f318-491b-9639-be8bd43875b8 | 8040350b-71ea-40da-ad3a-7af1f291aa5f | PACKAGING_UNIT  |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | discount/createDiscount/createDiscountOrderLevel   | discountService/createDiscount/createDiscount | 99c1c51d-4da4-4ead-bc29-0c1e1029cc14 | 37343468-506e-4fd4-9d6e-32ed606d8a53 | KG_OR_L         |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | discount/createDiscount/createDiscountOrderLevel   | discountService/createDiscount/createDiscount | 99c1c51d-4da4-4ead-bc29-0c1e1029cc14 | 37343468-506e-4fd4-9d6e-32ed606d8a53 | PACKAGING_UNIT  |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | discount/createDiscount/createDiscountOrderLevelMY | discountService/createDiscount/createDiscount | 8be10e3b-dcb2-4a9e-b68d-666faaf8711a | 0e5bceea-655a-48ed-ad67-43d4fdc634b4 | KG_OR_L         |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | discount/createDiscount/createDiscountOrderLevelMY | discountService/createDiscount/createDiscount | 8be10e3b-dcb2-4a9e-b68d-666faaf8711a | 0e5bceea-655a-48ed-ad67-43d4fdc634b4 | PACKAGING_UNIT  |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | discount/createDiscount/createDiscountOrderLevel   | discountService/createDiscount/createDiscount | e234208d-7411-4e58-9a14-8d5201b8a2cc | 2426a28d-6088-4d74-9751-499b5516d884 | KG_OR_L         |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | discount/createDiscount/createDiscountOrderLevel   | discountService/createDiscount/createDiscount | e234208d-7411-4e58-9a14-8d5201b8a2cc | 2426a28d-6088-4d74-9751-499b5516d884 | PACKAGING_UNIT  |

    @createDiscount2
    Scenario: Admin creates discount - Order level and Product condition
        Given I build dynamic headers with:
            | key      | value       |
            | tenantId | <tenant Id> |
        And I am 'valid_token' authenticated on 'discount_service' service
        And I generate random 4char4digit as "couponCodeValue"
        And I build dynamic payload from "<request payload>" with:
            | key                                  | value                           |
            | couponCode                           | {{couponCodeValue}}             |
            | startDate                            | {{$now+1h+1m}}                  |
            | endDate                              | {{$now+2h+1m}}                  |
            | orderLevel.minimumOrderQty.unit      | <unit on payload>               |
            | name                                 | Order level - Product condition |
            | discountAppliedFor                   | <discountAppliedFor>            |
            | discountLevels                       | <discountLevels>                |
            | products[0].productVariantId         | <variant ID>                    |
            | products[1].productVariantId         | <variant ID 2>                  |
            | orderLevel.discountValueAndType.type | <discount type>                 |
        When I send "POST" request to "createDiscount" on "discount_service" service
        Then The response status should be 201
        Then The response should match json "<response file>"
        Examples:
            | tenant Id                            | request payload                                                    | response file                                 | variant ID                           | variant ID 2                         | discountAppliedFor                   | discountLevels                       | unit on payload | discount type |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | discount/createDiscount/createDiscountOrderLevelProductConditionID | discountService/createDiscount/createDiscount | 61d48abb-3a0e-4f23-819f-0958c18f398d | ff2a6e8e-b12c-485f-a664-472676cb825e | 2b263df6-1ce4-4b8f-b0f8-dbcaf13841f3 | 82bdb97f-480a-48c7-9ea0-13a37f5be38c | KG_OR_L         | Fixed         |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | discount/createDiscount/createDiscountOrderLevelProductConditionID | discountService/createDiscount/createDiscount | 61d48abb-3a0e-4f23-819f-0958c18f398d | ff2a6e8e-b12c-485f-a664-472676cb825e | 2b263df6-1ce4-4b8f-b0f8-dbcaf13841f3 | 82bdb97f-480a-48c7-9ea0-13a37f5be38c | PACKAGING_UNIT  | Percentage    |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | discount/createDiscount/createDiscountOrderLevelProductCondition   | discountService/createDiscount/createDiscount | 272cd6da-6a45-4b2d-969c-dc8289ea05e6 | 125423c8-7648-421d-87b3-53ae62f898f4 | 92403b97-73ba-4670-8a78-a87d2d6e21a3 | c5df2d39-ad34-4f65-8b69-b6ed6f18bde6 | KG_OR_L         | Fixed         |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | discount/createDiscount/createDiscountOrderLevelProductCondition   | discountService/createDiscount/createDiscount | 272cd6da-6a45-4b2d-969c-dc8289ea05e6 | 125423c8-7648-421d-87b3-53ae62f898f4 | 92403b97-73ba-4670-8a78-a87d2d6e21a3 | c5df2d39-ad34-4f65-8b69-b6ed6f18bde6 | PACKAGING_UNIT  | Percentage    |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | discount/createDiscount/createDiscountOrderLevelProductConditionIN | discountService/createDiscount/createDiscount | 15b64766-80eb-4cfa-b831-51c63bc3360f | ec67961f-c03f-4a8e-9ac9-0bedf0cc1b73 | 19696a18-9ab8-4a88-ac9c-1bcad8b597ba | ca28d6a3-fc38-41b6-b93f-e7d894b6fd70 | KG_OR_L         | Fixed         |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | discount/createDiscount/createDiscountOrderLevelProductConditionIN | discountService/createDiscount/createDiscount | 15b64766-80eb-4cfa-b831-51c63bc3360f | ec67961f-c03f-4a8e-9ac9-0bedf0cc1b73 | 19696a18-9ab8-4a88-ac9c-1bcad8b597ba | ca28d6a3-fc38-41b6-b93f-e7d894b6fd70 | PACKAGING_UNIT  | Fixed         |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | discount/createDiscount/createDiscountOrderLevelProductConditionIN | discountService/createDiscount/createDiscount | 15b64766-80eb-4cfa-b831-51c63bc3360f | ec67961f-c03f-4a8e-9ac9-0bedf0cc1b73 | 19696a18-9ab8-4a88-ac9c-1bcad8b597ba | ca28d6a3-fc38-41b6-b93f-e7d894b6fd70 | PACKAGING_UNIT  | Percentage    |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | discount/createDiscount/createDiscountOrderLevelProductConditionTH | discountService/createDiscount/createDiscount | YARA_MILA_10_10_30#BAG_50KG          | YARA_MILA_25_7_7#BAG_50KG            | d146f48a-f318-491b-9639-be8bd43875b8 | 8040350b-71ea-40da-ad3a-7af1f291aa5f | KG_OR_L         | Fixed         |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | discount/createDiscount/createDiscountOrderLevelProductConditionTH | discountService/createDiscount/createDiscount | YARA_MILA_10_10_30#BAG_50KG          | YARA_MILA_25_7_7#BAG_50KG            | d146f48a-f318-491b-9639-be8bd43875b8 | 8040350b-71ea-40da-ad3a-7af1f291aa5f | PACKAGING_UNIT  | Fixed         |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | discount/createDiscount/createDiscountOrderLevelProductConditionTH | discountService/createDiscount/createDiscount | YARA_MILA_10_10_30#BAG_50KG          | YARA_MILA_25_7_7#BAG_50KG            | d146f48a-f318-491b-9639-be8bd43875b8 | 8040350b-71ea-40da-ad3a-7af1f291aa5f | PACKAGING_UNIT  | Percentage    |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | discount/createDiscount/createDiscountOrderLevelProductCondition   | discountService/createDiscount/createDiscount | b68c41fb-734a-4532-b598-307f88ebf45f | 6b9db2df-3f48-4940-a670-239290c69089 | 99c1c51d-4da4-4ead-bc29-0c1e1029cc14 | 37343468-506e-4fd4-9d6e-32ed606d8a53 | KG_OR_L         | Fixed         |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | discount/createDiscount/createDiscountOrderLevelProductCondition   | discountService/createDiscount/createDiscount | b68c41fb-734a-4532-b598-307f88ebf45f | 6b9db2df-3f48-4940-a670-239290c69089 | 99c1c51d-4da4-4ead-bc29-0c1e1029cc14 | 37343468-506e-4fd4-9d6e-32ed606d8a53 | PACKAGING_UNIT  | Percentage    |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | discount/createDiscount/createDiscountOrderLevelProductConditionMY | discountService/createDiscount/createDiscount | 3db518be-5905-465a-b9c8-2596717eaea7 | ddb6343e-6664-40cc-9082-0b56df058421 | 8be10e3b-dcb2-4a9e-b68d-666faaf8711a | 0e5bceea-655a-48ed-ad67-43d4fdc634b4 | KG_OR_L         | Fixed         |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | discount/createDiscount/createDiscountOrderLevelProductConditionMY | discountService/createDiscount/createDiscount | 3db518be-5905-465a-b9c8-2596717eaea7 | ddb6343e-6664-40cc-9082-0b56df058421 | 8be10e3b-dcb2-4a9e-b68d-666faaf8711a | 0e5bceea-655a-48ed-ad67-43d4fdc634b4 | PACKAGING_UNIT  | Percentage    |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | discount/createDiscount/createDiscountOrderLevelProductCondition   | discountService/createDiscount/createDiscount | f0778df9-7883-4ddf-b0d4-308c7d6d312c | 5ff12839-8fea-4a7e-9937-c4a62d908f72 | e234208d-7411-4e58-9a14-8d5201b8a2cc | 2426a28d-6088-4d74-9751-499b5516d884 | KG_OR_L         | Fixed         |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | discount/createDiscount/createDiscountOrderLevelProductCondition   | discountService/createDiscount/createDiscount | f0778df9-7883-4ddf-b0d4-308c7d6d312c | 5ff12839-8fea-4a7e-9937-c4a62d908f72 | e234208d-7411-4e58-9a14-8d5201b8a2cc | 2426a28d-6088-4d74-9751-499b5516d884 | PACKAGING_UNIT  | Percentage    |

    @createDiscount3
    Scenario: Admin creates discount - Product level
        Given I build dynamic headers with:
            | key      | value       |
            | tenantId | <tenant Id> |
        And I am 'valid_token' authenticated on 'discount_service' service
        And I generate random 4char4digit as "couponCodeValue"
        And I build dynamic payload from "<request payload>" with:
            | key                                     | value                           |
            | couponCode                              | {{couponCodeValue}}             |
            | startDate                               | {{$now+1h+1m}}                  |
            | endDate                                 | {{$now+2h+1m}}                  |
            | products.minimumSkuOrderQtyAndUnit.unit | <unit on payload>               |
            | name                                    | Order level - Product condition |
            | discountAppliedFor                      | <discountAppliedFor>            |
            | discountLevels                          | <discountLevels>                |
            | products[0].productVariantId            | <variant ID>                    |
            | products[1].productVariantId            | <variant ID 2>                  |
        When I send "POST" request to "createDiscount" on "discount_service" service
        Then The response status should be 201
        Then The response should match json "<response file>"
        Examples:
            | tenant Id                            | request payload                                      | response file                                 | variant ID                           | variant ID 2                         | discountAppliedFor                   | discountLevels                       | unit on payload |
            | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed | discount/createDiscount/createDiscountProductLevelID | discountService/createDiscount/createDiscount | 61d48abb-3a0e-4f23-819f-0958c18f398d | ff2a6e8e-b12c-485f-a664-472676cb825e | dcb04c31-fca3-4d39-a1eb-29437730848e | 5647c301-b280-468b-b187-f05b69bf224e | PACKAGING_UNIT  |
            | 3080adbb-1127-4101-b0b3-47e0a747f0e2 | discount/createDiscount/createDiscountProductLevel   | discountService/createDiscount/createDiscount | 272cd6da-6a45-4b2d-969c-dc8289ea05e6 | 125423c8-7648-421d-87b3-53ae62f898f4 | 7f47efe7-d833-48cf-8f83-e3e8607764c4 | 7e963136-5b94-46ed-93f3-537ce050d704 | PACKAGING_UNIT  |
            | ee92fab8-985f-4b0b-931d-d1d19151be45 | discount/createDiscount/createDiscountProductLevel   | discountService/createDiscount/createDiscount | 15b64766-80eb-4cfa-b831-51c63bc3360f | ec67961f-c03f-4a8e-9ac9-0bedf0cc1b73 | 2cb4a334-e9fc-498f-b56a-e7ff004ba747 | 5adeebed-b508-436f-b532-3d6fbfb2e091 | PACKAGING_UNIT  |
            | 32c89363-b532-468a-8828-d2a72038c7c1 | discount/createDiscount/createDiscountProductLevel   | discountService/createDiscount/createDiscount | YARA_MILA_10_10_30#BAG_50KG          | YARA_MILA_25_7_7#BAG_50KG            | c87a510a-c390-46da-9303-313d95ce1357 | 86437e2c-f104-4f11-bc2a-837bc07d8a2f | PACKAGING_UNIT  |
            | 281f8a07-4b13-465e-8b04-426ee8fd3430 | discount/createDiscount/createDiscountProductLevel   | discountService/createDiscount/createDiscount | b68c41fb-734a-4532-b598-307f88ebf45f | 6b9db2df-3f48-4940-a670-239290c69089 | a8b03abc-07ed-4d88-97b8-87733fc473d9 | 39ad3d1e-e5d6-4dfc-adc4-059fb1809df5 | PACKAGING_UNIT  |
            | 8761a2d8-b4be-4ae8-b3e5-033dbce5ab5f | discount/createDiscount/createDiscountProductLevel   | discountService/createDiscount/createDiscount | 3db518be-5905-465a-b9c8-2596717eaea7 | ddb6343e-6664-40cc-9082-0b56df058421 | 152c3c7f-970b-4fd8-924b-d56db2e0865c | 25f571df-8c0d-474a-a77c-60c2563151f2 | PACKAGING_UNIT  |
            | d6d6a632-b66f-4894-a27e-3aef6d5c387b | discount/createDiscount/createDiscountProductLevel   | discountService/createDiscount/createDiscount | f0778df9-7883-4ddf-b0d4-308c7d6d312c | 5ff12839-8fea-4a7e-9937-c4a62d908f72 | 4db2c121-6ce8-4ec0-bf2e-54d78499bb4e | da1258cb-881b-42a0-978f-f2a5a99cc7ae | PACKAGING_UNIT  |

    @createDiscount4
    Scenario: Admin creates discount
        Given I build dynamic headers with:
            | key      | value                                |
            | tenantId | 4d1c5d95-5895-48b4-b6f9-74dd3dfc20ed |
        And I am '<invalid token>' authenticated on 'discount_service' service
        And I generate random 4char4digit as "couponCodeValue"
        And I build dynamic payload from "discount/createDiscount/createDiscountOrderLevel" with:
            | key        | value               |
            | couponCode | {{couponCodeValue}} |
            | startDate  | {{$now+1h+1m}}      |
        When I send "POST" request to "createDiscount" on "discount_service" service
        Then The response status should be 401
        Then The response should match json "<response file>"
        Examples:
            | invalid token | response file                             |
            | invalid_token | discountService/invalidToken/invalidToken |
            | no_token      | discountService/invalidToken/unauthorized |
