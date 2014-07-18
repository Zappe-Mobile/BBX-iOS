//
//  RequestManager.h
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBXBlocks.h"

@interface RequestManager : NSObject

/**
 *  Singleton Object
 *
 *  @return RequestManager Class Singleton
 */
+(RequestManager *)sharedManager;

/**
 *  Login Method
 *
 *  @param userName        Inputted Username
 *  @param pin             inputted Pin
 *  @param block Block Returning Success OR Failure
 */
-(void)loginUserWithUsername:(NSString *)userName WithPin:(NSString *)pin WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get Member Account Details
 *
 *  @param userName   Username of the Current User
 *  @param password   Password of the Current User
 *  @param languageId Language Selected
 *  @param block      Block Returning Success OR Failure
 */
-(void)getMemberAccountDetailsWithUsername:(NSString *)userName WithPassword:(NSString *)password WithLanguageId:(NSString *)languageId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get Current Member Account Status
 *
 *  @param memberId Member Id
 *  @param block    Block Returning Success OR Failure
 */
-(void)getCurrentMemberAccountStatusByMemberId:(NSString *)memberId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get Current Member Card Type Details
 *
 *  @param username   Username of the Current User
 *  @param password   Password of the Current User
 *  @param languageId Language Selected
 *  @param block      Block Returning Success OR Failure
 */
- (void)getCurrentMemberAccountCardDetailsWithUsername:(NSString *)username withPassword:(NSString *)password withLanguageId:(NSString *)languageId withCompletionBlock:(CompletionBlock)block;


/**
 *  Active Country List
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getActiveCountryListWithCompletionBlock:(CompletionBlock)block;


/**
 *  Active State List
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getStateIdByCountryWithCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Contact Details
 *
 *  @param countryId Country in which current user is
 *  @param block     block Block Returning Success OR Failure
 */
-(void)getContactDetailsByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Language List Details
 *
 *  @param block     block Block Returning Success OR Failure
 */
-(void)getActiveLanguageListWithCompletionBlock:(CompletionBlock)block;


/**
 *  Fetch All MarketPlace Categories
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getAllMarketplaceCategoriesWithCompletionBlock:(CompletionBlock)block;


/**
 *  Fetch All Products for a Particular Category Id
 *
 *  @param categoryId Category For Which Products are being fetched
 *  @param countryId  Country in which the current user is
 *  @param pageNumber Page no of the Data set being sent from server
 *  @param pageLimit  Number of Records Per Page
 */
-(void)getAllMarketplaceProductsForCategoryId:(NSString *)categoryId WithCountryId:(NSString *)countryId WithPageNumber:(NSString *)pageNumber WithPageLimit:(NSString *)pageLimit WithCompletionBlock:(CompletionBlock)block;


/**
 *  Search Marketplace for Products
 *
 *  @param searchString Search String
 *  @param block        Block Returning Success OR Failure
 */
-(void)searchMarketplaceWithSearchString:(NSString *)searchString WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get Current Member Marketplace Sell History
 *
 *  @param username   Username of the current user
 *  @param password   Password of the current user
 *  @param memberId   Member Id of the Current user
 *  @param countryId  Country in which the current user is
 *  @param pageNumber Page no of the Data set being sent from server
 *  @param pageLimit  Number of Records Per Page
 *  @param block      Block Returning Success OR Failure
 */
-(void)getMarketplaceCurrentMemberSellHistoryWithUsername:(NSString *)username WithPassword:(NSString *)password WithMemberId:(NSString *)memberId WithCountryId:(NSString *)countryId WithPageNumber:(NSString *)pageNumber WithPageLimit:(NSString *)pageLimit WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get Current Member Marketplace Buy History
 *
 *  @param username   Username of the current user
 *  @param password   Password of the current user
 *  @param memberId   Member Id of the Current user
 *  @param countryId  Country in which the current user is
 *  @param pageNumber Page no of the Data set being sent from server
 *  @param pageLimit  Number of Records Per Page
 *  @param block      Block Returning Success OR Failure
 */
-(void)getMarketplaceCurrentMemberBuyHistoryWithUsername:(NSString *)username WithPassword:(NSString *)password WithMemberId:(NSString *)memberId WithCountryId:(NSString *)countryId WithPageNumber:(NSString *)pageNumber WithPageLimit:(NSString *)pageLimit WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get Marketplace Latest Product Listing By Country
 *
 *  @param countryId  Country in which the current user is
 *  @param pageNumber Page no of the Data set being sent from server
 *  @param pageLimit  Number of Records Per Page
 *  @param block      Block Returning Success OR Failure
 */
-(void)getMarketplaceLatestProductListingWithCountryId:(NSString *)countryId WithPageNumber:(NSString *)pageNumber WithPageLimit:(NSString *)pageLimit WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get Marketplace Product Details By SellId & CountryId
 *
 *  @param sellId    Sell ID
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getMarketplaceProductDetailsWithSellId:(NSString *)sellId WithCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block;


/**
 *  MarketPlace Closing Soon Product Listing
 *
 *  @param countryId  Country in which the current user is
 *  @param pageNumber Page no of the Data set being sent from server
 *  @param pageLimit  Number of Records Per Page
 *  @param block      Block Returning Success OR Failure
 */
-(void)getMarketplaceClosingSoonListingWithCountryId:(NSString *)countryId WithPageNumber:(NSString *)pageNumber WithPageLimit:(NSString *)pageLimit WithCompletionBlock:(CompletionBlock)block;


/**
 *  Bid Now
 *
 *  @param quantity  Quantity of Product
 *  @param sellId    Sell ID
 *  @param bidAmount Bid Amount
 *  @param block     Block Returning Success OR Failure
 */
-(void)marketPlaceProductBidNowWithQuantity:(NSString *)quantity withSellId:(NSString *)sellId withBidAmount:(NSString *)bidAmount withCompletionBlock:(CompletionBlock)block;


/**
 *  Buy Now
 *
 *  @param quantity Quantity of Product
 *  @param sellId   Sell ID
 *  @param block    Block Returning Success OR Failure
 */
-(void)marketPlaceProductBuyNowWithQuantity:(NSString *)quantity withSellId:(NSString *)sellId withCompletionBlock:(CompletionBlock)block;


/**
 *  Get Events Details By CountryId
 *
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getEventsDetailsByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block;


/**
 *  How BBX Works
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getHowBBXWorksWithCompletionBlock:(CompletionBlock)block;


/**
 *  Submit Enquiry
 *
 *  @param userName Username of the current user
 *  @param password Password of the current user
 *  @param enquiry  Enquiry Text
 *  @param block    Block Returning Success OR Failure
 */
-(void)submitEnquiryWithUsername:(NSString *)userName WithPassword:(NSString *)password WithEnquiryText:(NSString *)enquiry WithCompletionBlock:(CompletionBlock)block;


/**
 *  Process BBX Transaction
 *
 *  @param userName    Username of current user
 *  @param password    Password of current user
 *  @param languageId  Language Id of the Language Selected
 *  @param buyerId     Id of the Buyer
 *  @param memberBuyer Member Buyer
 *  @param amount      Amount of Transaction
 *  @param description Description of Transaction
 *  @param block       Block Returning Success OR Failure
 */
-(void)processBBXTransactionWithUsername:(NSString *)userName WithPassword:(NSString *)password WithLanguageId:(NSString *)languageId WithBuyerId:(NSString *)buyerId WithOtherMemberBuyer:(NSString *)memberBuyer WithTransactionAmount:(NSString *)amount WithTransactionDescription:(NSString *)description WithCompletionBlock:(CompletionBlock)block;



/**
 *  Get All Accomodations
 *
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getAllAccomodationsByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get All Experiences
 *
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getAllExperiencesByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get All Gift Packages
 *
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getAllGiftPackagesByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get Lifestyle Search
 *
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getLifestyleSearchWithText:(NSString *)searchText withCountryId:(NSString *)countryId withLanguageId:(NSString *)languageId withPageNumber:(NSString *)pageNumber withProductCount:(NSString *)productCount WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get All Wines Categories
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getAllWinesCategoriesWithCompletionBlock:(CompletionBlock)block;


/**
 *  Get All Wines By Category
 *
 *  @param categoryId Category ID
 *  @param block      Block Returning Success OR Failure
 */
-(void)getAllWinesByCategory:(NSString *)categoryId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Wine Detail
 *
 *  @param name  SelId
 *  @param block Block Returning Success OR Failure
 */
-(void)getWineProductDetailBySelId:(NSString *)selId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get All Wines In Current Member Cart
 *
 *  @param memberId Member Id
 *  @param block    Block Returning Success OR Failure
 */
-(void)getAllWinesInCurrentMemberCartWithMemberId:(NSString *)memberId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get All Rewards
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getAllRewardsWithCompletionBlock:(CompletionBlock)block;


/**
 *  Get Rewards For Current Member
 *
 *  @param memberId Member Id
 *  @param block    Block Returning Success OR Failure
 */
-(void)getRewardsForCurrentMember:(NSString *)memberId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get Businesses Near Me
 *
 *  @param memberId Member Id
 *  @param block    Block Returning Success OR Failure
 */
-(void)getBusinessesNearMeByMemberId:(NSString *)memberId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get BBX Directory Search Result
 *
 *  @param keyword           Search Keyword
 *  @param stateId           State Id
 *  @param countryId         Country Id
 *  @param languageId        Language Id
 *  @param productCategoryId Product Category Id
 *  @param block             Block Returning Success OR Failure
 */
-(void)getBBXDirectorySearchResultWithKeyword:(NSString *)keyword WithStateId:(NSString *)stateId WithCountryId:(NSString *)countryId WithLanguageId:(NSString *)languageId WithProductCategoryId:(NSString *)productCategoryId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Directory Detail
 *
 *  @param directoryId Directory Id
 *  @param username    Username
 *  @param password    Password
 *  @param block       Block Returning Success OR Failure
 */
-(void)getDirectorySearchDetailWithDirectoryId:(NSString *)directoryId withUsername:(NSString *)username withPassword:(NSString *)password withCompletionBlock:(CompletionBlock)block;


/**
 *  Get Product Category
 *
 *  @param countryId Country Id
 *  @param block     Block Returning Success OR Failure
 */
-(void)getProductCategoryByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block;


/**
 *  Get Videos
 *
 *  @param countryId Country Id
 *  @param block     Block Returning Success OR Failure
 */
-(void)getVideosWithCountryId:(NSString *)countryId withCompletionBlock:(CompletionBlock)block;


/**
 *  Get Investment All Categories
 *
 *  @param countryId  Country Id
 *  @param languageId Language Id
 *  @param block      Block Returning Success OR Failure
 */
-(void)getInvestmentAllCategoryWithCountryId:(NSString *)countryId withLanguageId:(NSString *)languageId withCompletionBlock:(CompletionBlock)block;


/**
 *  Get Investment Detail
 *
 *  @param username     Username
 *  @param password     Password
 *  @param investmentId Selected Investment Id
 *  @param countryId    Country Id
 *  @param languageId   Language Id
 *  @param block        Block Returning Success OR Failure
 */
-(void)getInvestmentDetailWithUsername:(NSString *)username withPassword:(NSString *)password withInvestmentId:(NSString *)investmentId withCountryId:(NSString *)countryId withLanguageId:(NSString *)languageId withCompletionBlock:(CompletionBlock)block;

/**
 *  Get Price Min Investment
 *
 *  @param countryId Country Id
 *  @param block     Block Returning Success OR Failure
 */
-(void)getInvestmentPriceMinWithCountryId:(NSString *)countryId withCompletionBlock:(CompletionBlock)block;


/**
 *  Get Price Max Invesment
 *
 *  @param countryId Country Id
 *  @param block     Block Returning Success OR Failure
 */
-(void)getInvestmentPriceMaxWithCountryId:(NSString *)countryId withCompletionBlock:(CompletionBlock)block;


/**
 *  Investment Search
 *
 *  @param keyword       Search Keyword
 *  @param startPrice    Start Price
 *  @param endPrice      End Price
 *  @param categoryId    Selected Category Id
 *  @param languageId    Selected Language Id
 *  @param countryId     Selected Country Id
 *  @param pageNumber    Page Number
 *  @param productsCount Number of Products Per Page
 *  @param block         Block Returning Success OR Failure
 */
-(void)getInvestmentSearchWithKeyword:(NSString *)keyword withPriceStart:(NSString *)startPrice withPriceEnd:(NSString *)endPrice withCategoryId:(NSString *)categoryId withLanguageId:(NSString *)languageId withCountryId:(NSString *)countryId withPageNumber:(NSString *)pageNumber withProductsCount:(NSString *)productsCount withCompletionBlock:(CompletionBlock)block;


/**
 *  About Us Text
 *
 *  @param sectionId  1 for About Us
 *  @param countryId  Country Id for Selected Country
 *  @param languageId Language Id for Selected Language
 *  @param block      Block Returning Success OR Failure
 */
- (void)getAboutUsTextWithSectionId:(NSString *)sectionId withCountryId:(NSString *)countryId withLanguageId:(NSString *)languageId withCompletionBlock:(CompletionBlock)block;


/**
 *  Get Labels
 *
 *  @param languageId Language Id
 *  @param block      Block Returning Success OR Failure
 */
- (void)getLabelsByLanguageId:(NSString *)languageId withCompletionBlock:(CompletionBlock)block;


/**
 *  Pay Fee
 *
 *  @param creditCardNo     CC Number
 *  @param creditCardExpiry CC Expiry Date
 *  @param securityCode     CC Security Code
 *  @param amount           Payment Amount
 *  @param block            Block Returning Success OR Failure
 */
- (void)processPayFeeWithCreditCardNumber:(NSString *)creditCardNo withCreditCardExpiryDate:(NSString *)creditCardExpiry withCreditCardSecurityCode:(NSString *)securityCode withPaymentAmount:(NSString *)amount withCompletionBlock:(CompletionBlock)block;


/**
 *  Last Update
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getLastUpdateWithCompletionBlock:(CompletionBlock)block;


/**
 *  Contact Your Account Manager
 *
 *  @param username     Username
 *  @param password     Password
 *  @param iNeedText    I Need
 *  @param howOftenText How Often
 *  @param inquiryText  Inquiry Text
 *  @param poSupName    PoSup Name
 *  @param poSupAddress PoSup Address
 *  @param poSupPhone   PoSup Phone
 *  @param languageId   LanguageId
 *  @param countryId    CountryId
 *  @param block        Block Returning Success OR Failure
 */
-(void)contactYourAccountManagerWithUsername:(NSString *)username withPassword:(NSString *)password withINeed:(NSString *)iNeedText withHowOften:(NSString *)howOftenText withInquiryText:(NSString *)inquiryText withPoSupName:(NSString *)poSupName withPoSupAddress:(NSString *)poSupAddress withPoSupPhone:(NSString *)poSupPhone withLanguageId:(NSString *)languageId withCountryId:(NSString *)countryId withCompletionBlock:(CompletionBlock)block;


/**
 *  Language By Country
 *
 *  @param countryId Country Id
 *  @param block     Block Returning Success OR Failure
 */
-(void)getLanguageIdByCountryIdWithCountryId:(NSString *)countryId withCompletionBlock:(CompletionBlock)block;


/**
 *  Join BBX
 *
 *  @param companyName     Company Name
 *  @param businessAddress Business Address
 *  @param postCode        Post Code
 *  @param phone           Phone
 *  @param email           Email
 *  @param website         Website
 *  @param ownerName       Owner Name
 *  @param comments        Comments
 *  @param block           Block Returning Success OR Failure
 */
-(void)joinBBXWithCompanyName:(NSString *)companyName withBusinessAddress:(NSString *)businessAddress withPostCodeState:(NSString *)postCode withPhone:(NSString *)phone withEmail:(NSString *)email withWebsite:(NSString *)website withOwnerName:(NSString *)ownerName withComments:(NSString *)comments withCompletionBlock:(CompletionBlock)block;


/**
 *  Invite By Email
 *
 *  @param emails  Comma Separated Emails
 *  @param subject Mail Subject
 *  @param body    Mail Body
 *  @param block   Block Returning Success OR Failure
 */
-(void)inviteFriendByEmailWithEmails:(NSString *)emails withSubject:(NSString *)subject withBody:(NSString *)body withCompletionBlock:(CompletionBlock)block;


/**
 *  Invite By SMS
 *
 *  @param numbers Numbers to be sent SMS to
 *  @param body    SMS Body
 *  @param block   Block Returning Success OR Failure
 */
-(void)inviteFriendBySMSWithNumbers:(NSString *)numbers withBody:(NSString *)body withCompletionBlock:(CompletionBlock)block;
@end
