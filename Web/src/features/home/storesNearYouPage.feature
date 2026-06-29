Feature: Stores Near You Page

    @verifyStoresNearYouPage
    Scenario Outline: Verify stores within 100km radius are visible
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        And User grants geolocation permission
        When User sets browser geolocation to <Latitude> and <Longitude>
        And User clicks on the element of data-testid "KeyboardArrowDownOutlinedIcon"
        And User clicks on the element of data-testid "cta-1"
        And User clicks on the "<Find Me>" section
        And User clicks on the "<Confirm Location>" button
        And User waits for 3 seconds
        And User verify the "<Name Shop>" text exactly is "visible"
        And Store "<Name Shop>" distance should be between 0km and 100km

        Examples:
            | Country  | Language | Latitude | Longitude | Change Location       | Find Me              | Confirm Location     | Name Shop |
            | Thailand | th       | 14.68    | 100.05    | เปลี่ยนตำแหน่งที่ตั้ง | ค้นหาตำแหน่งปัจจุบัน | ยืนยันตำแหน่งพื้นที่ | April6    |
            | Thailand | th       | 15.13    | 100.05    | เปลี่ยนตำแหน่งที่ตั้ง | ค้นหาตำแหน่งปัจจุบัน | ยืนยันตำแหน่งพื้นที่ | April6    |
            | Thailand | th       | 14.68    | 100.979   | เปลี่ยนตำแหน่งที่ตั้ง | ค้นหาตำแหน่งปัจจุบัน | ยืนยันตำแหน่งพื้นที่ | April6    |


    @verifyStoresNearYouPage
    Scenario Outline: Verify stores beyond 100km radius are hidden
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        And User grants geolocation permission
        When User sets browser geolocation to <Latitude> and <Longitude>
        And User clicks on the element of data-testid "KeyboardArrowDownOutlinedIcon"
        And User clicks on the element of data-testid "cta-1"
        And User clicks on the "<Find Me>" section
        And User clicks on the "<Confirm Location>" button
        And User waits for 3 seconds
        And User verify the "<Name Shop>" text exactly is "hidden"

        Examples:
            | Country  | Language | Latitude | Longitude | Change Location       | Find Me              | Confirm Location     | Name Shop |
            | Thailand | th       | 15.68    | 100.05    | เปลี่ยนตำแหน่งที่ตั้ง | ค้นหาตำแหน่งปัจจุบัน | ยืนยันตำแหน่งพื้นที่ | April6    |
            | Thailand | th       | 14.68    | 100.981   | เปลี่ยนตำแหน่งที่ตั้ง | ค้นหาตำแหน่งปัจจุบัน | ยืนยันตำแหน่งพื้นที่ | April6    |