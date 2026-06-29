@getHelpFAQ
Feature: Get Help flow
    Background:
    @gethelp-overview
    Scenario: Verify the frequently asked questions view correctly
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the exact "Frequently asked questions" section
        Then User verifies the "<Store item>" text is "<Store item status>"
        And User verifies the "<Services item>" text is "<Services item status>"
        And User verifies the "<Support item>" text is "<Support item status>"

        Examples:
            | Country   | Language | Store item | Store item status | Services item | Services item status | Support item | Support item status |
            | India     | English  | Store      | visible           | Services      | visible              | Support      | visible             |
            | Indonesia |          | Toko       | visible           | Pengetahuan   | visible              | Dukungan     | visible             |
            | Kenya     |          | Shop       | visible           | Services      | visible              | Support      | visible             |
            | Malaysia  | English  | Shop       | hidden            | Services      | hidden               | Support      | visible             |
            | Tanzania  | English  | Duka       | visible           | Maarifa       | visible              | Msaada       | visible             |
            | Thailand  |          | ร้านค้า    | visible           | Maarifa       | hidden               | การสนับสนุน  | visible             |
            | VietNam   | English  | Shop       | visible           | Services      | hidden               | Support      | visible             |

    @gethelp-store
    Scenario: Verify the store item can work as well on the frequently asked questions
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the exact "Frequently asked questions" section
        And User clicks on the exact "<Store item>" section
        And User enters "Invalid" into the "Search by topic name" field
        Then User verifies the "No results" text is "visible"

        When User clicks on the exact "<Order item>" section
        Then User verifies the "<Placing an order>" text is "visible"
        And User verifies the "<Missed orders>" text is "visible"
        And User verifies the "<Past orders>" text is "visible"

        When User clicks on the exact "<Placing an order>" section
        Then User verifies the "<How do I place an order on Store?>" text is "visible"
        And User verifies the "<How do I select a retail shop?>" text is "visible"
        And User verifies the "<What happens after I confirm my booking?>" text is "visible"

        When User goes back
        And User clicks on the exact "<Missed orders>" section
        Then User verifies the "<What happens if I miss the pick-up date and time?>" text is "visible"
        Then User verifies the "<How can I reschedule if I miss the pick-up date and time?>" text is "visible"

        When User goes back
        And User clicks on the exact "<Past orders>" section
        Then User verifies the "<How do I check on my past orders?>" text is "visible"

        Examples:
            | Country   | Language | Store item | Order item | Placing an order    | Missed orders         | Past orders        | How do I place an order on Store? | How do I select a retail shop?     | What happens after I confirm my booking?            | What happens if I miss the pick-up date and time?      | How can I reschedule if I miss the pick-up date and time?                        | How do I check on my past orders?                 |
            | India     | English  | Store      | Orders     | Placing an order    | Missed orders         | Past orders        | How do I place an order on Store? | How do I select a retail shop?     | What happens after I confirm my booking?            | What happens if I miss the pick-up date and time?      | How can I reschedule if I miss the pick-up date and time?                        | How do I check on my past orders?                 |
            | Indonesia |          | Toko       | Pesanan    | Melakukan pemesanan | Pesanan yang terlewat | Pesanan sebelumnya | Bagaimana cara memesan di Toko?   | Bagaimana cara memilih toko ritel? | Apa jadinya setelah saya mengonfirmasi pemesanan?   | Apa jadinya jika tanggal dan jam pengambilan terlewat? | Bagaimana cara menjadwal ulang jika tanggal dan jam pengambilan terlewat?        | Bagaimana cara memeriksa pesanan saya sebelumnya? |
            | Kenya     |          | Shop       | Orders     | Placing an order    | Missed orders         | Past orders        | How do I place an order on Shop?  | How do I select a retail shop?     | What happens after I confirm my booking?            | What happens if I miss the pick-up date and time?      | How can I reschedule if I miss the pick-up date and time?                        | How do I check on my past orders?                 |
            | Tanzania  | English  | Duka       | Agizo      | Kuweka agizo        | Maagizo yaliyokosa    | Maagizo ya zamani  | Ninawezaje kuagiza kwenye Duka    | Je, ninachaguaje duka la rejareja? | Je, nini kitatokea baada ya kuthibitisha oda yangu? | Nini kitatokea nikikosa tarehe na saa ya kuchukua?     | Je, ninawezaje kupanga upya iwapo nitapitisha tarehe na saa ya kuichukua?        | Ninaangaliaje oda zangu za awali?                 |
            | Thailand  |          | ร้านค้า    | คำสั่งซื้อ | วางคำสั่งซื้อ       | ออเดอร์พลาด           | ออเดอร์ที่ผ่านมา   | สั่งซื้อทางร้านยังไงคะ?           | ฉันจะเลือกร้านค้าปลีกได้อย่างไร    | หลังจากที่ยืนยันการจองแล้วจะเป็นอย่างไรต่อไป        | จะเกิดอะไรขึ้นหากฉันพลาดวันและเวลาที่จะต้องไปรับสินค้า | ฉันจะเปลี่ยนกำหนดการได้อย่างไรหากไม่ได้ไปรับสินค้าในวันและเวลาที่ต้องไปรับสินค้า | ฉันจะตรวจสอบคำสั่งซื้อที่ผ่านมาของฉันได้อย่างไร   |
            | VietNam   |          | Shop       | Orders     | Placing an order    | Missed orders         | Past orders        | How do I place an order on Shop?  | How do I select a retail shop?     | What happens after I confirm my booking?            | What happens if I miss the pick-up date and time?      | How can I reschedule if I miss the pick-up date and time?                        | How do I check on my past orders?                 |


    @gethelp-store-payment-kenya
    Scenario: Verify the store payment item can work as well on the frequently asked questions
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the exact "Frequently asked questions" section
        And User clicks on the exact "<Store item>" section
        And User clicks on the exact "<Payment item>" section
        Then User verifies the "<Payment Methods>" text is "visible"
        And User verifies the "<Payment Process>" text is "visible"
        And User verifies the "<Refunds and Cancellations>" text is "visible"
        And User verifies the "<Security / Safety>" text is "visible"
        And User verifies the "<Customer Support>" text is "visible"

        When User clicks on the exact "<Payment Methods>" section
        Then User verifies the "<What payment methods do you accept?>" text is "visible"
        And User verifies the "<Is it possible to use a different phone number to make payments on M-PESA?>" text is "visible"

        When User goes back
        And User clicks on the exact "<Payment Process>" section
        Then User verifies the "<How can I make a payment using M-PESA on Yara FarmCare?>" text is "visible"
        Then User verifies the "<Can I use more than one payment method for a single order?>" text is "visible"
        Then User verifies the "<Will I receive a confirmation if my payment is successful?>" text is "visible"
        Then User verifies the "<How long does it take for my M-PESA payment to be processed?>" text is "visible"

        When User goes back
        And User clicks on the exact "<Refunds and Cancellations>" section
        Then User verifies the "<How long does it take to process a refund?>" text is "visible"
        And User verifies the "<Can I cancel my order?>" text is "visible"

        When User goes back
        And User clicks on the exact "<Security / Safety>" section
        Then User verifies the "<Is ordering online secure?>" text is "visible"
        And User verifies the "<How can I view my purchase history?>" text is "visible"

        When User goes back
        And User clicks on the exact "<Customer Support>" section
        Then User verifies the "<How can I contact customer support?>" text is "visible"

        Examples:
            | Country | Language | Store item | Payment item | Payment Methods | Payment Process | Refunds and Cancellations | Security / Safety | Customer Support | What payment methods do you accept? | Is it possible to use a different phone number to make payments on M-PESA? | How can I make a payment using M-PESA on Yara FarmCare? | Can I use more than one payment method for a single order? | Will I receive a confirmation if my payment is successful? | How long does it take for my M-PESA payment to be processed? | How long does it take to process a refund? | Can I cancel my order? | Is ordering online secure? | How can I view my purchase history? | How can I contact customer support? |
            | Kenya   |          | Shop       | Payment      | Payment Methods | Payment Process | Refunds and Cancellations | Security / Safety | Customer Support | What payment methods do you accept? | Is it possible to use a different phone number to make payments on M-PESA? | How can I make a payment using M-PESA on Yara FarmCare? | Can I use more than one payment method for a single order? | Will I receive a confirmation if my payment is successful? | How long does it take for my M-PESA payment to be processed? | How long does it take to process a refund? | Can I cancel my order? | Is ordering online secure? | How can I view my purchase history? | How can I contact customer support? |

    @gethelp-store-credit-Tanzania
    Scenario: Verify the store credit item can work as well on the frequently asked questions
        Given User goes to dashboard page in the "Tanzania" country with "English" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the "Frequently asked questions" section
        And User clicks on the exact "Duka" section
        And User clicks on the exact "Agizo" section
        And User clicks on the exact "Mkopo" section
        Then User verifies the "Kutumia Ufadhili wa Pembejeo" text is "visible"
        And User verifies the "Nitajuaje kama ufadhili wangu wa pembejeo umeidhinishwa?" text is "visible"
        And User verifies the "Mikopo ya ufadhili wa pembejeo iliyoidhinishwa yote" text is "visible"
        And User verifies the "Mikopo ya ufadhli wa pembejeo iliyoidhinishwa kiasi" text is "visible"
        And User verifies the "Mikopo ya ufadhili wa pembejeo iliyokataliwa" text is "visible"

    @gethelp-services
    Scenario: Verify the service item can work as well on the frequently asked questions (IN)
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the exact "Frequently asked questions" section
        And User clicks on the exact "<Service item>" section
        And User enters "Invalid" into the "Search by topic name" field
        Then User verifies the "No results" text is "visible"

        When User clicks on the exact "<Soil testing item>" section
        Then User verifies the "<About Soil testing>" text is "visible"
        And User verifies the "<Soil Sample Process>" text is "visible"
        And User verifies the "<Soil Testing Report>" text is "visible"
        And User verifies the "<Support>" text is "visible"

        When User clicks on the exact "<About Soil testing>" section
        Then User verifies the "<What are the benefits of soil testing?>" text is "visible"
        And User verifies the "<What are the benefits of soil testing?>" text is "visible"
        And User verifies the "<Why do we need soil testing?>" text is "visible"
        And User verifies the "<What languages do we support for soil testing?>" text is "visible"

        When User goes back
        And User clicks on the exact "<Soil Sample Process>" section
        Then User verifies the "<What is the soil testing process?>" text is "visible"
        And User verifies the "<What equipment or tools do I need to collect the soil sample?>" text is "visible"
        And User verifies the "<How do I collect the soil sample?>" text is "visible"
        And User verifies the "<How do I submit the soil sample?>" text is "visible"
        And User verifies the "<When is the best time to collect the soil sample?>" text is "visible"
        And User verifies the "<How often should I do a soil test for my farm?>" text is "visible"

        When User goes back
        And User clicks on the exact "<Soil Testing Report>" section
        Then User verifies the "<How long does it take to get the soil testing report back from the lab?>" text is "visible"
        And User verifies the "<How can I better understand my soil testing report?>" text is "visible"
        And User verifies the "<My neighbour or friend who is growing the same crop as me. Can they use my soil test report that I have done for their farm?>" text is "visible"

        When User goes back
        And User clicks on the exact "<Support>" section
        Then User verifies the "<I need help. Where or who can I contact for more support?>" text is "visible"

        Examples:
            | Country | Language | Service item | Soil testing item | About Soil testing | Soil Sample Process | Soil Testing Report | Support | What are the benefits of soil testing? | Why do we need soil testing? | What languages do we support for soil testing? | What is the soil testing process? | What equipment or tools do I need to collect the soil sample? | How do I collect the soil sample? | How do I submit the soil sample? | When is the best time to collect the soil sample? | How often should I do a soil test for my farm? | How long does it take to get the soil testing report back from the lab? | How can I better understand my soil testing report? | My neighbour or friend who is growing the same crop as me. Can they use my soil test report that I have done for their farm? | I need help. Where or who can I contact for more support? |
            | India   | English  | Services     | Soil testing      | About Soil testing | Soil Sample Process | Soil Testing Report | Support | What are the benefits of soil testing? | Why do we need soil testing? | What languages do we support for soil testing? | What is the soil testing process? | What equipment or tools do I need to collect the soil sample? | How do I collect the soil sample? | How do I submit the soil sample? | When is the best time to collect the soil sample? | How often should I do a soil test for my farm? | How long does it take to get the soil testing report back from the lab? | How can I better understand my soil testing report? | My neighbour or friend who is growing the same crop as me. Can they use my soil test report that I have done for their farm? | I need help. Where or who can I contact for more support? |
            | Kenya   |          | Services     | Soil testing      | About Soil testing | Soil Sample Process | Soil Testing Report | Support | What are the benefits of soil testing? | Why do we need soil testing? | What languages do we support for soil testing? | What is the soil testing process? | What equipment or tools do I need to collect the soil sample? | How do I collect the soil sample? | How do I submit the soil sample? | When is the best time to collect the soil sample? | How often should I do a soil test for my farm? | How long does it take to get the soil testing report back from the lab? | How can I better understand my soil testing report? | My neighbour or friend who is growing the same crop as me. Can they use my soil test report that I have done for their farm? | I need help. Where or who can I contact for more support? |

    @gethelp-services-fert
    Scenario: Verify the service item can work as well on the frequently asked questions (ID)
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the exact "Frequently asked questions" section
        And User clicks on the exact "<Service item>" section
        And User enters "Invalid" into the "Search by topic name" field
        Then User verifies the "No results" text is "visible"

        And User clicks on the exact "<Support>" section
        Then User verifies the "<I need help. Where or who can I contact for more support?>" text is "visible"

        Examples:
            | Country   | Language | Service item | Support   | I need help. Where or who can I contact for more support? |
            | Indonesia |          | Pengetahuan  | Panduan   | Memahami Kalkulator Pemupukan: Manfaat dan Dasar          |
            | Tanzania  | English  | Maarifa      | Waelekezi | Kuelewa Kikokotoo cha Mbolea: Faida na Misingi            |

    @gethelp-support
    Scenario: Verify the support item can work as well on the frequently asked questions
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        And User clicks on the "Account tab" button
        And User clicks on the exact "Get help menu" section
        And User waits for 7 seconds
        And User clicks on the exact "Frequently asked questions" section
        And User clicks on the exact "<Support item>" section
        And User enters "Invalid" into the "Search by topic name" field
        Then User verifies the "No results" text is "visible"

        When User clicks on the exact "<Contact us>" section
        Then User verifies the "<Have more questions or feedback for the Yara FarmCare team?>" text is "visible"
        When User goes back
        When User clicks on the exact "<Help>" section
        Then User verifies the "<App issue troubleshooting>" text is "visible"

        Examples:
            | Country   | Language | Support item | Contact us     | Have more questions or feedback for the Yara FarmCare team? | Help           | App issue troubleshooting                                 |
            | India     | English  | Support      | Contact us     | Have more questions or feedback for the Yara FarmCare team? | Help           | App issue troubleshooting                                 |
            | Indonesia |          | Dukungan     | Hubungi kami   | Masih ada pertanyaan atau masukan untuk tim Yara FarmCare?  | Bantuan        | Pemecahan masalah aplikasi                                |
            | Kenya     |          | Support      | Contact us     | Have more questions or feedback for the Yara FarmCare team? | Help           | App issue troubleshooting                                 |
            | Malaysia  | English  | Support      | Contact us     | Have more questions or feedback for the Yara FarmCare team? | Help           | App issue troubleshooting                                 |
            | Tanzania  | English  | Msaada       | Wasiliana nasi | Je, una maswali au maoni zaidi kwa timu ya Yara FarmCare?   | Wasiliana nasi | Je, una maswali au maoni zaidi kwa timu ya Yara FarmCare? |
            | VietNam   | English  | Support      | Contact us     | Have more questions or feedback for the YaraFarmcare team?  | Help           | App issue troubleshooting                                 |
