import fs from "fs";
import path from "path";
import { Browser, BrowserContext, Page } from "@playwright/test";
import { IWorldOptions, setWorldConstructor, World } from "@cucumber/cucumber";
import { verifySession, getStoragePath, verifySessionWithPhone, getStoragePathWithPhone } from "../utils/auth/authHelper";
import { BasePage } from "../pages/core/basePage";
import { LocalePage } from "../pages/login/localePage";
import { config } from "../support/config";
import { LoginPage } from "../pages/login/loginPage";
import { HomePage } from "../pages/home/homePage";
import { ShopPage } from "../pages/shop/shopDetailPage";
import { CartPage } from "../pages/shoppingCart/cartPage";
import { PlaceOrderPage } from "../pages/shoppingCart/placeOrderPage";
import { MyOrderPage } from "../pages/account/myOrderPage";
import { SearchPage } from "../pages/home/searchPage";
import { GetHelpPage } from "../pages/account/getHelpPage";
import { EditProfilePage } from "../pages/account/editProfilePage";
import { ProfilePage } from "../pages/account/profilePage";
import { ClaimRewardPage } from "../pages/account/claimRewardPage";
import { StoresNearYouPage } from "../pages/home/storesNearYouPage";
import { TestDataStore } from "../utils/i18n/testDataLoader";
import { CouponCartPage } from "../pages/discount/couponCartPage";
import { CouponHomePage } from "../pages/discount/couponHomePage";
export class CustomWorld extends World {
    // Playwright lifecycle (per scenario)
    browser!: Browser;
    context!: BrowserContext;
    page!: Page;
    country?: string;
    language?: string;
    locale?: string;
    orderNumber?: string;
    fullName?: string;
    currentLat?: number;
    currentLng?: number;

    // Share data
    storageStatePath?: string;
    config = config;

    // Page Objects
    basePage!: BasePage;
    localePage!: LocalePage;
    loginPage!: LoginPage;
    homePage!: HomePage;
    shopDetailPage!: ShopPage;
    cartPage!: CartPage;
    placeOrderPage!: PlaceOrderPage;
    myOrderPage!: MyOrderPage;
    searchPage!: SearchPage;
    getHelpPage!: GetHelpPage;
    editProfilePage!: EditProfilePage;
    profilePage!: ProfilePage;
    claimRewardPage!: ClaimRewardPage;
    storesNearYouPage!: StoresNearYouPage;
    couponHomePage!: CouponHomePage;
    couponCartPage!: CouponCartPage;

    ticketId?: string;
    orderNumbers: string[] = [];
    testData: Record<string, string> = {};
    testDataCache: Record<string, TestDataStore> = {};

    adminCampaignId?: string;
    adminCampaignName?: string;
    loyaltyId?: string;
    orderId?: string;
    submissionId?: string;

    constructor(options: IWorldOptions) {
        super(options);
    }
    /**
     * Set locale
     */
    setLocale(locale: string) {
        this.locale = locale;
        const pages = [
            this.basePage,
            this.localePage,
            this.loginPage,
            this.homePage,
            this.shopDetailPage,
            this.cartPage,
            this.placeOrderPage,
            this.myOrderPage,
            this.searchPage,
            this.getHelpPage,
            this.editProfilePage,
            this.storesNearYouPage,
            this.couponHomePage,
            this.couponCartPage,
        ];
        for (const p of pages) {
            if (p) {
                p.locale = locale;
                p.testDataCache = this.testDataCache;
            }
        }
    }

    /**
     * Bind Playwright Page & init Page Objects
     * Called from Before hook
     */
    initPages(page: Page) {
        this.page = page;
        this.basePage = new BasePage(page);
        this.localePage = new LocalePage(page);
        this.loginPage = new LoginPage(page);
        this.homePage = new HomePage(page);
        this.shopDetailPage = new ShopPage(page);
        this.cartPage = new CartPage(page);
        this.placeOrderPage = new PlaceOrderPage(page);
        this.myOrderPage = new MyOrderPage(page);
        this.searchPage = new SearchPage(page);
        this.getHelpPage = new GetHelpPage(page);
        this.editProfilePage = new EditProfilePage(page);
        this.profilePage = new ProfilePage(page);
        this.claimRewardPage = new ClaimRewardPage(page);
        this.storesNearYouPage = new StoresNearYouPage(page);
        this.couponHomePage = new CouponHomePage(page);
        this.couponCartPage = new CouponCartPage(page);
    }

    /**
     * Login with session
     */
    async launchBrowserWithStorageSession(country: string, language: string) {
        const dir = path.dirname(getStoragePath(country));
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }
        const storageExists = fs.existsSync(getStoragePath(country));
        this.context = await this.browser.newContext({
            storageState: storageExists ? getStoragePath(country) : undefined,
        });
        this.page = await this.context.newPage();
        const status = await verifySession(this.context, this.page, country, language);
        const currentURL = this.page.url();
        const localeFromURL = currentURL.split("/")[3];
        if (localeFromURL) {
            this.locale = localeFromURL;
        }
        this.initPages(this.page);
        if (this.locale) this.setLocale(this.locale);
    }

    /**
     * Login with phone number and session
     */
    async launchBrowserWithPhoneLogin(country: string, language: string, phone: string) {
        const sessionPath = getStoragePathWithPhone(country, phone);
        const dir = path.dirname(sessionPath);
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }
        const storageExists = fs.existsSync(sessionPath);
        this.context = await this.browser.newContext({
            storageState: storageExists ? sessionPath : undefined,
        });
        this.page = await this.context.newPage();
        const status = await verifySessionWithPhone(this.context, this.page, country, language, phone);
        const currentURL = this.page.url();
        const localeFromURL = currentURL.split("/")[3];
        if (localeFromURL) {
            this.locale = localeFromURL;
        }
        this.initPages(this.page);
        if (this.locale) this.setLocale(this.locale);
    }

    /**
     * Open URL without session
     */
    async launchBrowserWithoutStorageSession() {
        this.context = await this.browser.newContext();
        const page = await this.context.newPage();
        await page.goto(this.config.baseUrl, { waitUntil: "networkidle" });
        this.initPages(page);
    }
}

setWorldConstructor(CustomWorld);
