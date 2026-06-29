@editprofile
Feature: Edit Profile Page

    Scenario Outline: Edit profile with valid information for all countries with language
        Given User goes to dashboard page in the "<Country>" country with "<Language>" language
        When User goes to "Home" page
        When User clicks on the "<Account>" button
        When User clicks on the "<My Profile>" section
        When User fill the random value in the "<Full Name>" field
        When User change "<Location>" location
        When User select "<Farm Size>" option in the "<Select Farm Size>" dropdown
        When User enters "10" into the "<Enter Farm Size>" field
        When User clicks on the "<Select crops>" dropdown
        When User clicks on the "<Save Profile>" button
        Then User verifies the "<Profile Completed>" text is "visible"
        Then User verifies the "<Des Completed>" text is "visible"
        When User clicks on the "<Okay>" button

        Examples:
            | Country  | Language | Full Name   | Location | Farm Size | Select Farm Size        | Enter Farm Size         | Account | My Profile   | Select crops | Save Profile   | Profile Completed  | Des Completed                                                | Okay |
            | Tanzania | Swahili  | Jina kamili | Dodoma   | Ekari     | Chagua ukubwa wa shamba | Andika ukubwa wa shamba | Akaunti | Wasifu wangu | Chagua mazao | Hifadhi wasifu | Wasifu umekamilika | Unaweza kuhariri taarifa za wasifu kwenye ukurasa wa akaunti | Sawa |
# | India     | English    | Full name        | Bengal       | Acres        | Select farm size        | Enter farm size              | Account | My profile   | Select crops    | Save profile   | Profile completed   | You can always edit profile details from account page        | Okay |
# | Indonesia | Indonesian | Nama lengkap     | Jakarta      | Hektare      | Pilih ukuran kebun      | Masukkan ukuran kebun        | Akun    | Profil saya  | Tanaman dipilih | Simpan profil  | Profil selesai      | Anda selalu dapat mengedit detail profil dari halaman akun   | Oke  |
# | Kenya     | English    | Full name        | Nairobi      | Hectares     | Select farm size        | Enter farm size              | Account | My profile   | Select crops    | Save profile   | Profile completed   | You can always edit profile details from account page        | Okay |
# | Thailand  | Thai       | ชื่อ และ นามสกุล | Bangkok      | ไร่          | เลือกขนาดพื้นที่เกษตร   | ใส่ขนาดพื้นที่การเกษตร (ไร่) | บัญชี   | ข้อมูลของฉัน | เลือกพืช        | บันทึกโปรไฟล์  | โปรไฟล์เสร็จสมบูรณ์ | คุณสามารถแก้ไขรายละเอียดโปรไฟล์ได้เสมอจากหน้าบัญชี           | ตกลง |
# | VietNam   | English    | Full name        | Hồ Chí Minh  | Square meter | Select farm size        | Enter farm size              | Account | My profile   | Selected crops  | Save profile   | Profile completed   | You can always edit profile details from account page        | Okay |
# | Malaysia  | English    | full name        | Kuala Lumpur | Hectares     | Select farm size        | Enter farm size              | Account | My profile   | Selected crops  | Save profile   | Profile completed   | You can always edit profile details from account page        | Okay |



