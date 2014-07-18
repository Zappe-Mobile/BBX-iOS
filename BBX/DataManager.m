//
//  DataManager.m
//  BBX
//
//  Created by Roman Khan on 03/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "DataManager.h"
#import "AFNetworking.h"
#import "XMLReader.h"
#import "MagicalRecord.h"
#import "Contact.h"
#import "MarketPlaceCategories.h"
#import "ProductsPerCategory.h"
#import "Events.h"
#import "LatestProducts.h"
#import "SearchProducts.h"
#import "BuyHistory.h"
#import "SellHistory.h"
#import "WinesCategory.h"
#import "WinesPerCategory.h"
#import "Accomodation.h"
#import "Experiences.h"
#import "GiftPackages.h"
#import "ProductCategory.h"
#import "StateInfo.h"
#import "Directory.h"
#import "CountryInfo.h"
#import "LanguageInfo.h"
#import "Card.h"
#import "Videos.h"
#import "InvestmentCategory.h"
#import "Labels.h"
#import "AccountInfo.h"
#import "MinPrice.h"
#import "MaxPrice.h"
#import "MarketPlaceFrontImage.h"
#import "FrontImageDetail.h"
#import "InvestmentSearch.h"
#import "Vouchers.h"

@interface DataManager()
{
    NSURLConnection * connection;
    NSMutableData * webData;
}
@property (nonatomic, copy, readwrite) CompletionBlock completionBlock;
@end

@implementation DataManager
@synthesize completionBlock;
@synthesize arrayKey;
@synthesize arrayValue;
@synthesize dictData;

static DataManager * sharedManager;

//Initialize is called automatically before the class gets any other message
+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
		sharedManager = [[DataManager alloc] init];
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        arrayKey = [[NSMutableArray alloc]init];
        arrayValue = [[NSMutableArray alloc]init];
        dictData = [[NSMutableDictionary alloc]init];
    }
    return self;
}


#pragma mark - Singleton Object
//Singleton Object
+ (DataManager *)sharedManager {
	return (sharedManager);
}

/**
 *  Store Marketplace Categories
 *
 *  @param categoryArray    Array Coming from Server
 *  @param block            Block Returning Success OR Failure
 */
+(void)storeMarketplaceCategories:(NSArray *)categoryArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",categoryArray);
    NSLog(@"%lu",(unsigned long)[categoryArray count]);
    
    for (MarketPlaceCategories * Object  in [DataManager loadAllMarketPlaceCategoriesFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in categoryArray) {
        
        MarketPlaceCategories * marketObj = [MarketPlaceCategories MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        marketObj.categoryId = [[dict objectForKey:@"CatID"]objectForKey:@"text"];
        marketObj.categoryName = [[dict objectForKey:@"CatName"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

/**
 *  Store Contact Info
 *
 *  @param contactArray Contact Array from Server
 *  @param block        Block Returning Success OR Failure
 */
+(void)storeContactInfo:(NSArray *)contactArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",contactArray);
    NSLog(@"%lu",(unsigned long)[contactArray count]);
    
    for (Contact * Object  in [DataManager loadAllContactsFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in contactArray) {
        
        Contact * contactObj = [Contact MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        contactObj.franchiseName = [[dict objectForKey:@"FranchiseName"]objectForKey:@"text"];
        contactObj.address = [[dict objectForKey:@"Address"]objectForKey:@"text"];
        contactObj.phone = [[dict objectForKey:@"Phone"]objectForKey:@"text"];
        contactObj.fax = [[dict objectForKey:@"Fax"]objectForKey:@"text"];
        contactObj.email = [[dict objectForKey:@"Email"]objectForKey:@"text"];
        contactObj.mapLocation = [[dict objectForKey:@"GoogleMapLocation"]objectForKey:@"text"];
        contactObj.contactPerson = [[dict objectForKey:@"Contact"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
}

/**
 *  Store Products for MarketPlace ID
 *
 *  @param productArray Product Array from Server
 *  @param block        Block Returning Success OR Failure
 */
+(void)storeMarketPlaceProductsForCategories:(NSArray *)productArray dataDictionary:(NSDictionary *)dictData DataBlock:(DataBlock)block
{
    NSLog(@"%@",productArray);
    NSLog(@"%lu",(unsigned long)[productArray count]);
    
    for (ProductsPerCategory * Object  in [DataManager loadAllMarketPlaceProductsPerCategoryFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    if (productArray!= nil) {
        
        for (NSDictionary * dict in productArray) {
            
            ProductsPerCategory * productObj = [ProductsPerCategory MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
            productObj.latestBidAmount = [[dict objectForKey:@"LastBidAmount"]objectForKey:@"text"];
            productObj.location = [[dict objectForKey:@"Location"]objectForKey:@"text"];
            productObj.rowNumber = [[dict objectForKey:@"RowNumber"]objectForKey:@"text"];
            productObj.selCategoryId = [[dict objectForKey:@"SelCatID"]objectForKey:@"text"];
            productObj.selCrrId = [[dict objectForKey:@"SelCrrID"]objectForKey:@"text"];
            productObj.selDateExpire = [[dict objectForKey:@"SelDateExpire"]objectForKey:@"text"];
            productObj.selDatePosted = [[dict objectForKey:@"SelDatePosted"]objectForKey:@"text"];
            productObj.selDis = [[dict objectForKey:@"SelDis"]objectForKey:@"text"];
            productObj.selEnteredByMemId = [[dict objectForKey:@"SelEnteredByMemID"]objectForKey:@"text"];
            productObj.selId = [[dict objectForKey:@"SelID"]objectForKey:@"text"];
            productObj.selMemId = [[dict objectForKey:@"SelMemID"]objectForKey:@"text"];
            productObj.selNoOfViews = [[dict objectForKey:@"SelNoOfViews"]objectForKey:@"text"];
            productObj.selPricePerQuantityCash = [[dict objectForKey:@"SelPricePerQuantityCash"]objectForKey:@"text"];
            productObj.selPricePerQuantityTrade = [[dict objectForKey:@"SelPricePerQuantityTrade"]objectForKey:@"text"];
            productObj.selQuantity = [[dict objectForKey:@"SelQuantity"]objectForKey:@"text"];
            productObj.selTitle = [[dict objectForKey:@"SelTitle"]objectForKey:@"text"];
            productObj.totalPages = [[dict objectForKey:@"TotalPages"]objectForKey:@"text"];
            productObj.totalRecords = [[dict objectForKey:@"TotalRecords"]objectForKey:@"text"];
            productObj.image = [[dict objectForKey:@"Image"]objectForKey:@"text"];
        }

    }
    else {
        
        ProductsPerCategory * productObj = [ProductsPerCategory MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        productObj.latestBidAmount = [[dictData objectForKey:@"LastBidAmount"]objectForKey:@"text"];
        productObj.location = [[dictData objectForKey:@"Location"]objectForKey:@"text"];
        productObj.rowNumber = [[dictData objectForKey:@"RowNumber"]objectForKey:@"text"];
        productObj.selCategoryId = [[dictData objectForKey:@"SelCatID"]objectForKey:@"text"];
        productObj.selCrrId = [[dictData objectForKey:@"SelCrrID"]objectForKey:@"text"];
        productObj.selDateExpire = [[dictData objectForKey:@"SelDateExpire"]objectForKey:@"text"];
        productObj.selDatePosted = [[dictData objectForKey:@"SelDatePosted"]objectForKey:@"text"];
        productObj.selDis = [[dictData objectForKey:@"SelDis"]objectForKey:@"text"];
        productObj.selEnteredByMemId = [[dictData objectForKey:@"SelEnteredByMemID"]objectForKey:@"text"];
        productObj.selId = [[dictData objectForKey:@"SelID"]objectForKey:@"text"];
        productObj.selMemId = [[dictData objectForKey:@"SelMemID"]objectForKey:@"text"];
        productObj.selNoOfViews = [[dictData objectForKey:@"SelNoOfViews"]objectForKey:@"text"];
        productObj.selPricePerQuantityCash = [[dictData objectForKey:@"SelPricePerQuantityCash"]objectForKey:@"text"];
        productObj.selPricePerQuantityTrade = [[dictData objectForKey:@"SelPricePerQuantityTrade"]objectForKey:@"text"];
        productObj.selQuantity = [[dictData objectForKey:@"SelQuantity"]objectForKey:@"text"];
        productObj.selTitle = [[dictData objectForKey:@"SelTitle"]objectForKey:@"text"];
        productObj.totalPages = [[dictData objectForKey:@"TotalPages"]objectForKey:@"text"];
        productObj.totalRecords = [[dictData objectForKey:@"TotalRecords"]objectForKey:@"text"];
        productObj.image = [[dictData objectForKey:@"Image"]objectForKey:@"text"];

    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store All Events
 *
 *  @param eventsArray Events Array from Server
 *  @param block       Block Returning Success OR Failure
 */
+(void)storeAllEvents:(NSArray *)eventsArray dataDictionary:(NSDictionary *)dictData DataBlock:(DataBlock)block;
{
    NSLog(@"%@",eventsArray);
    
    for (Events * Object  in [DataManager loadAllEventsFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    if (eventsArray!=nil) {
        for (NSDictionary * dict in eventsArray) {
            
            Events * eventObj = [Events MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
            eventObj.eventType = [[dict objectForKey:@"EventType"]objectForKey:@"text"];
            eventObj.eventContactInfo = [[dict objectForKey:@"ExpContactInfo"]objectForKey:@"text"];
            eventObj.eventCostDetails = [[dict objectForKey:@"ExpCostDetails"]objectForKey:@"text"];
            eventObj.eventDateTime = [[dict objectForKey:@"ExpDateTime"]objectForKey:@"text"];
            eventObj.eventDescription = [[dict objectForKey:@"ExpDis"]objectForKey:@"text"];
            eventObj.eventTitle = [[dict objectForKey:@"ExpTitle"]objectForKey:@"text"];
            eventObj.eventVenueAddress = [[dict objectForKey:@"ExpVenueAddress"]objectForKey:@"text"];
            eventObj.eventVenueName = [[dict objectForKey:@"ExpVenueName"]objectForKey:@"text"];
        }

    }
    else {
        Events * eventObj = [Events MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        eventObj.eventType = [[dictData objectForKey:@"EventType"]objectForKey:@"text"];
        eventObj.eventContactInfo = [[dictData objectForKey:@"ExpContactInfo"]objectForKey:@"text"];
        eventObj.eventCostDetails = [[dictData objectForKey:@"ExpCostDetails"]objectForKey:@"text"];
        eventObj.eventDateTime = [[dictData objectForKey:@"ExpDateTime"]objectForKey:@"text"];
        eventObj.eventDescription = [[dictData objectForKey:@"ExpDis"]objectForKey:@"text"];
        eventObj.eventTitle = [[dictData objectForKey:@"ExpTitle"]objectForKey:@"text"];
        eventObj.eventVenueAddress = [[dictData objectForKey:@"ExpVenueAddress"]objectForKey:@"text"];
        eventObj.eventVenueName = [[dictData objectForKey:@"ExpVenueName"]objectForKey:@"text"];

    }
    
    
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store All Latest Products
 *
 *  @param eventsArray Products Array from Server
 *  @param block       Block Returning Success OR Failure
 */
+(void)storeAllLatestProducts:(NSArray *)array DataBlock:(DataBlock)block
{
    NSLog(@"%@",array);
    
    for (LatestProducts * Object  in [DataManager loadAllLatestProductsFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in array) {
        
        LatestProducts * productObj = [LatestProducts MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        productObj.lastBidAmount = [[dict objectForKey:@"LastBidAmount"]objectForKey:@"text"];
        productObj.location = [[dict objectForKey:@"Location"]objectForKey:@"text"];
        productObj.sellCatId = [[dict objectForKey:@"SelCatID"]objectForKey:@"text"];
        productObj.sellCrrId = [[dict objectForKey:@"SelCrrID"]objectForKey:@"text"];
        productObj.sellDateExpire = [[dict objectForKey:@"SelDateExpire"]objectForKey:@"text"];
        productObj.sellDatePosted = [[dict objectForKey:@"SelDatePosted"]objectForKey:@"text"];
        productObj.sellDescription = [[dict objectForKey:@"SelDis"]objectForKey:@"text"];
        productObj.sellEnteredByMemId = [[dict objectForKey:@"SelEnteredByMemID"]objectForKey:@"text"];
        productObj.sellId = [[dict objectForKey:@"SelID"]objectForKey:@"text"];
        productObj.sellMemId = [[dict objectForKey:@"SelMemID"]objectForKey:@"text"];
        productObj.sellNoOfViews = [[dict objectForKey:@"SelNoOfViews"]objectForKey:@"text"];
        productObj.sellPricePerQuantityCash = [[dict objectForKey:@"SelPricePerQuantityCash"]objectForKey:@"text"];
        productObj.sellPricePerQuantityTrade = [[dict objectForKey:@"SelPricePerQuantityTrade"]objectForKey:@"text"];
        productObj.sellQuantity = [[dict objectForKey:@"SelQuantity"]objectForKey:@"text"];
        productObj.sellTitle = [[dict objectForKey:@"SelTitle"]objectForKey:@"text"];
        productObj.image = [[dict objectForKey:@"Image"]objectForKey:@"text"];

    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store All MarketPlace Search Products
 *
 *  @param eventsArray Products Array from Server
 *  @param block       Block Returning Success OR Failure
 */
+(void)storeMarketPlaceSearchProducts:(NSArray *)array DataBlock:(DataBlock)block
{
    NSLog(@"%@",array);
    
    for (SearchProducts * Object  in [DataManager loadAllSearchProductsFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in array) {
        
        SearchProducts * productObj = [SearchProducts MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        productObj.lastBidAmount = [[dict objectForKey:@"LastBidAmount"]objectForKey:@"text"];
        productObj.location = [[dict objectForKey:@"Location"]objectForKey:@"text"];
        productObj.selCatId = [[dict objectForKey:@"SelCatID"]objectForKey:@"text"];
        productObj.selCrrId = [[dict objectForKey:@"SelCrrID"]objectForKey:@"text"];
        productObj.selDateExpire = [[dict objectForKey:@"SelDateExpire"]objectForKey:@"text"];
        productObj.selDatePosted = [[dict objectForKey:@"SelDatePosted"]objectForKey:@"text"];
        productObj.selDescription = [[dict objectForKey:@"SelDis"]objectForKey:@"text"];
        productObj.selEnteredByMemId = [[dict objectForKey:@"SelEnteredByMemID"]objectForKey:@"text"];
        productObj.selId = [[dict objectForKey:@"SelID"]objectForKey:@"text"];
        productObj.selMemId = [[dict objectForKey:@"SelMemID"]objectForKey:@"text"];
        productObj.selNoOfViews = [[dict objectForKey:@"SelNoOfViews"]objectForKey:@"text"];
        productObj.selPricePerQuantityCash = [[dict objectForKey:@"SelPricePerQuantityCash"]objectForKey:@"text"];
        productObj.selPricePerQuantityTrade = [[dict objectForKey:@"SelPricePerQuantityTrade"]objectForKey:@"text"];
        productObj.selQuantity = [[dict objectForKey:@"SelQuantity"]objectForKey:@"text"];
        productObj.selTitle = [[dict objectForKey:@"SelTitle"]objectForKey:@"text"];
        productObj.image = [[dict objectForKey:@"Image"]objectForKey:@"text"];
        
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
}


/**
 *  Store All Current Member Buy History
 *
 *  @param array Buy Array From Server
 *  @param block Block Returning Success OR Failure
 */
+(void)storeCurrentMemberBuyHistory:(NSArray *)array DataBlock:(DataBlock)block
{
    NSLog(@"%@",array);
    for (BuyHistory * Object  in [DataManager loadAllBuyHistoryFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in array) {
        
        BuyHistory * buyObj = [BuyHistory MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        buyObj.buyDateTime = [[dict objectForKey:@"BuyDateTime"]objectForKey:@"text"];
        buyObj.buyId = [[dict objectForKey:@"BuyID"]objectForKey:@"text"];
        buyObj.buyMemId = [[dict objectForKey:@"BuyMemID"]objectForKey:@"text"];
        buyObj.buyPricePerQuantityCash = [[dict objectForKey:@"BuyPricePerQuantityCash"]objectForKey:@"text"];
        buyObj.buyPricePerQuantityTrade = [[dict objectForKey:@"BuyPricePerQuantityTrade"]objectForKey:@"text"];
        buyObj.buyQuantity = [[dict objectForKey:@"BuyQuantity"]objectForKey:@"text"];
        buyObj.buySelId = [[dict objectForKey:@"BuySelID"]objectForKey:@"text"];
        buyObj.buyStaIdType = [[dict objectForKey:@"BuyStaIDType"]objectForKey:@"text"];
        buyObj.image = [[dict objectForKey:@"Image"]objectForKey:@"text"];
        buyObj.selCrrId = [[dict objectForKey:@"SelCrrID"]objectForKey:@"text"];
        buyObj.selDescription = [[dict objectForKey:@"SelDis"]objectForKey:@"text"];
        buyObj.selMemId = [[dict objectForKey:@"SelMemID"]objectForKey:@"text"];
        buyObj.selTitle = [[dict objectForKey:@"SelTitle"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store All Current Member Buy History
 *
 *  @param array Buy Array From Server
 *  @param block Block Returning Success OR Failure
 */
+(void)storeCurrentMemberSellHistory:(NSArray *)array DataBlock:(DataBlock)block
{
    NSLog(@"%@",array);
    for (SellHistory * Object  in [DataManager loadAllSellHistoryFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in array) {
        
        SellHistory * sellObj = [SellHistory MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        sellObj.image = [[dict objectForKey:@"Image"]objectForKey:@"text"];
        sellObj.selCatId = [[dict objectForKey:@"SelCatID"]objectForKey:@"text"];
        sellObj.selCrrId = [[dict objectForKey:@"SelCrrID"]objectForKey:@"text"];
        sellObj.selDateExpire = [[dict objectForKey:@"SelDateExpire"]objectForKey:@"text"];
        sellObj.selDatePosted = [[dict objectForKey:@"SelDatePosted"]objectForKey:@"text"];
        sellObj.selDescription = [[dict objectForKey:@"SelDis"]objectForKey:@"text"];
        sellObj.selEnteredByMemId = [[dict objectForKey:@"SelEnteredByMemID"]objectForKey:@"text"];
        sellObj.selId = [[dict objectForKey:@"SelID"]objectForKey:@"text"];
        sellObj.selMemId = [[dict objectForKey:@"SelMemID"]objectForKey:@"text"];
        sellObj.selNoOfViews = [[dict objectForKey:@"SelNoOfViews"]objectForKey:@"text"];
        sellObj.selPricePerQuantityCash = [[dict objectForKey:@"SelPricePerQuantityCash"]objectForKey:@"text"];
        sellObj.selPricePerQuantityTrade = [[dict objectForKey:@"SelPricePerQuantityTrade"]objectForKey:@"text"];
        sellObj.selQuantity = [[dict objectForKey:@"SelQuantity"]objectForKey:@"text"];
        sellObj.selStaIDStatus = [[dict objectForKey:@"SelStaIDStatus"]objectForKey:@"text"];
        sellObj.selStaIdType = [[dict objectForKey:@"SelStaIDType"]objectForKey:@"text"];
        sellObj.selTitle = [[dict objectForKey:@"SelTitle"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
}


/**
 *  Store Wines Categories
 *
 *  @param categoryArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeWinesCategories:(NSArray *)categoryArray DataBlock:(DataBlock)block
{
    for (WinesCategory * Object  in [DataManager loadAllWinesCategoryFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in categoryArray) {
        
        WinesCategory * wineObj = [WinesCategory MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        wineObj.categoryId = [[dict objectForKey:@"CatID"]objectForKey:@"text"];
        wineObj.categoryName = [[dict objectForKey:@"CatName"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Wines As Per Catgories
 *
 *  @param categoryArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeWinesPerCategories:(NSArray *)categoryArray dataDictionary:(NSDictionary *)dictData DataBlock:(DataBlock)block
{
    NSLog(@"%@",categoryArray);
    NSLog(@"%lu",(unsigned long)[categoryArray count]);
    
    for (WinesPerCategory * Object  in [DataManager loadAllWinesPerCategoryFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    if (categoryArray!=nil) {

    for (NSDictionary * dict in categoryArray) {
        
        WinesPerCategory * winesObj = [WinesPerCategory MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        winesObj.selCatId = [[dict objectForKey:@"SelCatID"]objectForKey:@"text"];
        winesObj.selCrrId = [[dict objectForKey:@"SelCrrID"]objectForKey:@"text"];
        winesObj.selDatePosted = [[dict objectForKey:@"SelDatePosted"]objectForKey:@"text"];
        winesObj.selDescription = [[dict objectForKey:@"SelDis"]objectForKey:@"text"];
        winesObj.selEnteredByMemId = [[dict objectForKey:@"SelEnteredByMemID"]objectForKey:@"text"];
        winesObj.selId = [[dict objectForKey:@"SelID"]objectForKey:@"text"];
        winesObj.selMemId = [[dict objectForKey:@"SelMemID"]objectForKey:@"text"];
        winesObj.selNoOfViews = [[dict objectForKey:@"SelNoOfViews"]objectForKey:@"text"];
        winesObj.selPricePerQuantityCash = [[dict objectForKey:@"SelPricePerQuantityCash"]objectForKey:@"text"];
        winesObj.selPricePerQuantityTrade = [[dict objectForKey:@"SelPricePerQuantityTrade"]objectForKey:@"text"];
        winesObj.selQuantity = [[dict objectForKey:@"SelQuantity"]objectForKey:@"text"];
        winesObj.selTitle = [[dict objectForKey:@"SelTitle"]objectForKey:@"text"];
        winesObj.sellImage = [[dict objectForKey:@"SellImage"]objectForKey:@"text"];
    }
        
    }
    else {
        
        WinesPerCategory * winesObj = [WinesPerCategory MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        winesObj.selCatId = [[dictData objectForKey:@"SelCatID"]objectForKey:@"text"];
        winesObj.selCrrId = [[dictData objectForKey:@"SelCrrID"]objectForKey:@"text"];
        winesObj.selDatePosted = [[dictData objectForKey:@"SelDatePosted"]objectForKey:@"text"];
        winesObj.selDescription = [[dictData objectForKey:@"SelDis"]objectForKey:@"text"];
        winesObj.selEnteredByMemId = [[dictData objectForKey:@"SelEnteredByMemID"]objectForKey:@"text"];
        winesObj.selId = [[dictData objectForKey:@"SelID"]objectForKey:@"text"];
        winesObj.selMemId = [[dictData objectForKey:@"SelMemID"]objectForKey:@"text"];
        winesObj.selNoOfViews = [[dictData objectForKey:@"SelNoOfViews"]objectForKey:@"text"];
        winesObj.selPricePerQuantityCash = [[dictData objectForKey:@"SelPricePerQuantityCash"]objectForKey:@"text"];
        winesObj.selPricePerQuantityTrade = [[dictData objectForKey:@"SelPricePerQuantityTrade"]objectForKey:@"text"];
        winesObj.selQuantity = [[dictData objectForKey:@"SelQuantity"]objectForKey:@"text"];
        winesObj.selTitle = [[dictData objectForKey:@"SelTitle"]objectForKey:@"text"];
        winesObj.sellImage = [[dictData objectForKey:@"SellImage"]objectForKey:@"text"];

    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Lifestyle Accomodations
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeLifestyleAccomodations:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (Accomodation * Object  in [DataManager loadAllLifestyleAccomodationsFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        Accomodation * accomodationObj = [Accomodation MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        accomodationObj.currencyName = [[dict objectForKey:@"CurrencyName"]objectForKey:@"text"];
        accomodationObj.giftCardAddress = [[dict objectForKey:@"GiftCardAddress"]objectForKey:@"text"];
        accomodationObj.giftCardAmount = [[dict objectForKey:@"GiftCardAmount"]objectForKey:@"text"];
        accomodationObj.giftCardAvailableQuantity = [[dict objectForKey:@"GiftCardAvailbleQuantity"]objectForKey:@"text"];
        accomodationObj.giftCardContactPerson = [[dict objectForKey:@"GiftCardContactPerson"]objectForKey:@"text"];
        accomodationObj.giftCardContactPhone = [[dict objectForKey:@"GiftCardContactPhone"]objectForKey:@"text"];
        accomodationObj.giftCardDetails = [[dict objectForKey:@"GiftCardDetails"]objectForKey:@"text"];
        accomodationObj.giftCardHeading = [[dict objectForKey:@"GiftCardHeading"]objectForKey:@"text"];
        accomodationObj.giftCardId = [[dict objectForKey:@"GiftCardID"]objectForKey:@"text"];
        accomodationObj.giftCardMemberName = [[dict objectForKey:@"GiftCardMemberName"]objectForKey:@"text"];
        accomodationObj.giftCardPostalCode = [[dict objectForKey:@"GiftCardPostCode"]objectForKey:@"text"];
        accomodationObj.giftCardSubHeading = [[dict objectForKey:@"GiftCardSubHeading"]objectForKey:@"text"];
        accomodationObj.giftCardTerms = [[dict objectForKey:@"GiftCardTerms"]objectForKey:@"text"];
        accomodationObj.imageFirst = [[dict objectForKey:@"ImageFirst"]objectForKey:@"text"];
        accomodationObj.imageSecond = [[dict objectForKey:@"ImageSecond"]objectForKey:@"text"];
        accomodationObj.imageThird = [[dict objectForKey:@"ImageThird"]objectForKey:@"text"];
        accomodationObj.imageFourth = [[dict objectForKey:@"ImageForth"]objectForKey:@"text"];
        accomodationObj.imageFirstSmall = [[dict objectForKey:@"ImageFirstSmall"]objectForKey:@"text"];
        accomodationObj.imageSecondSmall = [[dict objectForKey:@"ImageSecondSmall"]objectForKey:@"text"];
        accomodationObj.imageThirdSmall = [[dict objectForKey:@"ImageThirdSmall"]objectForKey:@"text"];
        accomodationObj.imageFourthSmall = [[dict objectForKey:@"ImageForthSmall"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Lifestyle Gift Packages
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeLifestyleGiftPackages:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (GiftPackages * Object  in [DataManager loadAllLifestyleGiftPackagesFromCoreData]) {
        [Object MR_deleteEntity];
    }

    for (NSDictionary * dict in dataArray) {
        
        GiftPackages * giftObj = [GiftPackages MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        giftObj.currencyName = [[dict objectForKey:@"CurrencyName"]objectForKey:@"text"];
        giftObj.giftCardAddress = [[dict objectForKey:@"GiftCardAddress"]objectForKey:@"text"];
        giftObj.giftCardAmount = [[dict objectForKey:@"GiftCardAmount"]objectForKey:@"text"];
        giftObj.giftCardAvailableQuantity = [[dict objectForKey:@"GiftCardAvailbleQuantity"]objectForKey:@"text"];
        giftObj.giftCardContactPerson = [[dict objectForKey:@"GiftCardContactPerson"]objectForKey:@"text"];
        giftObj.giftCardContactPhone = [[dict objectForKey:@"GiftCardContactPhone"]objectForKey:@"text"];
        giftObj.giftCardDetails = [[dict objectForKey:@"GiftCardDetails"]objectForKey:@"text"];
        giftObj.giftCardHeading = [[dict objectForKey:@"GiftCardHeading"]objectForKey:@"text"];
        giftObj.giftCardId = [[dict objectForKey:@"GiftCardID"]objectForKey:@"text"];
        giftObj.giftCardMemberName = [[dict objectForKey:@"GiftCardMemberName"]objectForKey:@"text"];
        giftObj.giftCardPostalCode = [[dict objectForKey:@"GiftCardPostCode"]objectForKey:@"text"];
        giftObj.giftCardSubHeading = [[dict objectForKey:@"GiftCardSubHeading"]objectForKey:@"text"];
        giftObj.giftCardTerms = [[dict objectForKey:@"GiftCardTerms"]objectForKey:@"text"];
        giftObj.imageFirst = [[dict objectForKey:@"ImageFirst"]objectForKey:@"text"];
        giftObj.imageSecond = [[dict objectForKey:@"ImageSecond"]objectForKey:@"text"];
        giftObj.imageThird = [[dict objectForKey:@"ImageThird"]objectForKey:@"text"];
        giftObj.imageFourth = [[dict objectForKey:@"ImageForth"]objectForKey:@"text"];
        giftObj.imageFirstSmall = [[dict objectForKey:@"ImageFirstSmall"]objectForKey:@"text"];
        giftObj.imageSecondSmall = [[dict objectForKey:@"ImageSecondSmall"]objectForKey:@"text"];
        giftObj.imageThirdSmall = [[dict objectForKey:@"ImageThirdSmall"]objectForKey:@"text"];
        giftObj.imageFourthSmall = [[dict objectForKey:@"ImageForthSmall"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Lifestyle Vouchers
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeLifestyleVouchers:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (Vouchers * Object  in [DataManager loadAllLifestyleVouchersFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        Vouchers * giftObj = [Vouchers MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        giftObj.currencyName = [[dict objectForKey:@"CurrencyName"]objectForKey:@"text"];
        giftObj.giftCardAddress = [[dict objectForKey:@"GiftCardAddress"]objectForKey:@"text"];
        giftObj.giftCardAmount = [[dict objectForKey:@"GiftCardAmount"]objectForKey:@"text"];
        giftObj.giftCardAvailableQuantity = [[dict objectForKey:@"GiftCardAvailbleQuantity"]objectForKey:@"text"];
        giftObj.giftCardContactPerson = [[dict objectForKey:@"GiftCardContactPerson"]objectForKey:@"text"];
        giftObj.giftCardContactPhone = [[dict objectForKey:@"GiftCardContactPhone"]objectForKey:@"text"];
        giftObj.giftCardDetails = [[dict objectForKey:@"GiftCardDetails"]objectForKey:@"text"];
        giftObj.giftCardHeading = [[dict objectForKey:@"GiftCardHeading"]objectForKey:@"text"];
        giftObj.giftCardId = [[dict objectForKey:@"GiftCardID"]objectForKey:@"text"];
        giftObj.giftCardMemberName = [[dict objectForKey:@"GiftCardMemberName"]objectForKey:@"text"];
        giftObj.giftCardPostalCode = [[dict objectForKey:@"GiftCardPostCode"]objectForKey:@"text"];
        giftObj.giftCardSubHeading = [[dict objectForKey:@"GiftCardSubHeading"]objectForKey:@"text"];
        giftObj.giftCardTerms = [[dict objectForKey:@"GiftCardTerms"]objectForKey:@"text"];
        giftObj.imageFirst = [[dict objectForKey:@"ImageFirst"]objectForKey:@"text"];
        giftObj.imageSecond = [[dict objectForKey:@"ImageSecond"]objectForKey:@"text"];
        giftObj.imageThird = [[dict objectForKey:@"ImageThird"]objectForKey:@"text"];
        giftObj.imageFourth = [[dict objectForKey:@"ImageForth"]objectForKey:@"text"];
        giftObj.imageFirstSmall = [[dict objectForKey:@"ImageFirstSmall"]objectForKey:@"text"];
        giftObj.imageSecondSmall = [[dict objectForKey:@"ImageSecondSmall"]objectForKey:@"text"];
        giftObj.imageThirdSmall = [[dict objectForKey:@"ImageThirdSmall"]objectForKey:@"text"];
        giftObj.imageFourthSmall = [[dict objectForKey:@"ImageForthSmall"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
    
}

/**
 *  Store Lifestyle Experiences
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeLifestyleExperiences:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (Experiences * Object  in [DataManager loadAllLifestyleExperiencesFromCoreData]) {
        [Object MR_deleteEntity];
    }

    for (NSDictionary * dict in dataArray) {
        
        Experiences * experienceObj = [Experiences MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        experienceObj.currencyName = [[dict objectForKey:@"CurrencyName"]objectForKey:@"text"];
        experienceObj.giftCardAddress = [[dict objectForKey:@"GiftCardAddress"]objectForKey:@"text"];
        experienceObj.giftCardAmount = [[dict objectForKey:@"GiftCardAmount"]objectForKey:@"text"];
        experienceObj.giftCardAvailableQuantity = [[dict objectForKey:@"GiftCardAvailbleQuantity"]objectForKey:@"text"];
        experienceObj.giftCardContactPerson = [[dict objectForKey:@"GiftCardContactPerson"]objectForKey:@"text"];
        experienceObj.giftCardContactPhone = [[dict objectForKey:@"GiftCardContactPhone"]objectForKey:@"text"];
        experienceObj.giftCardDetails = [[dict objectForKey:@"GiftCardDetails"]objectForKey:@"text"];
        experienceObj.giftCardHeading = [[dict objectForKey:@"GiftCardHeading"]objectForKey:@"text"];
        experienceObj.giftCardId = [[dict objectForKey:@"GiftCardID"]objectForKey:@"text"];
        experienceObj.giftCardMemberName = [[dict objectForKey:@"GiftCardMemberName"]objectForKey:@"text"];
        experienceObj.giftCardPostalCode = [[dict objectForKey:@"GiftCardPostCode"]objectForKey:@"text"];
        experienceObj.giftCardSubHeading = [[dict objectForKey:@"GiftCardSubHeading"]objectForKey:@"text"];
        experienceObj.giftCardTerms = [[dict objectForKey:@"GiftCardTerms"]objectForKey:@"text"];
        experienceObj.imageFirst = [[dict objectForKey:@"ImageFirst"]objectForKey:@"text"];
        experienceObj.imageSecond = [[dict objectForKey:@"ImageSecond"]objectForKey:@"text"];
        experienceObj.imageThird = [[dict objectForKey:@"ImageThird"]objectForKey:@"text"];
        experienceObj.imageFourth = [[dict objectForKey:@"ImageForth"]objectForKey:@"text"];
        experienceObj.imageFirstSmall = [[dict objectForKey:@"ImageFirstSmall"]objectForKey:@"text"];
        experienceObj.imageSecondSmall = [[dict objectForKey:@"ImageSecondSmall"]objectForKey:@"text"];
        experienceObj.imageThirdSmall = [[dict objectForKey:@"ImageThirdSmall"]objectForKey:@"text"];
        experienceObj.imageFourthSmall = [[dict objectForKey:@"ImageForthSmall"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Product Categories
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeProductCategories:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (ProductCategory * Object  in [DataManager loadAllProductCategoriesFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        ProductCategory * productObj = [ProductCategory MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        productObj.categoryId = [[dict objectForKey:@"SICCode"]objectForKey:@"text"];
        productObj.categoryName = [[dict objectForKey:@"SICName"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Directory Search Results
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeDirectorySearchResults:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (Directory * Object  in [DataManager loadAllDirectoryResultsFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        Directory * directoryObj = [Directory MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        directoryObj.directoryAddress = [[dict objectForKey:@"DirAddress"]objectForKey:@"text"];
        directoryObj.directoryBuyPeriod = [[dict objectForKey:@"DirBuyPrepaid"]objectForKey:@"text"];
        directoryObj.directoryBuyPrepaidTextLink = [[dict objectForKey:@"DirBuyPrepaidTextLink"]objectForKey:@"text"];
        directoryObj.directoryCommEmail = [[dict objectForKey:@"DirCommEmail"]objectForKey:@"text"];
        directoryObj.directoryCommFax = [[dict objectForKey:@"DirCommFax"]objectForKey:@"text"];
        directoryObj.directoryCommMobile = [[dict objectForKey:@"DirCommMobile"]objectForKey:@"text"];
        directoryObj.directoryCommPhone = [[dict objectForKey:@"DirCommPhone"]objectForKey:@"text"];
        directoryObj.directoryCommWebsite = [[dict objectForKey:@"DirCommWebsite"]objectForKey:@"text"];
        directoryObj.directoryCompany = [[dict objectForKey:@"DirCompany"]objectForKey:@"text"];
        directoryObj.directoryContactPerson = [[dict objectForKey:@"DirContactPerson"]objectForKey:@"text"];
        directoryObj.directoryId = [[dict objectForKey:@"DirID"]objectForKey:@"text"];
        directoryObj.directoryMemberId = [[dict objectForKey:@"DirMemID"]objectForKey:@"text"];
        directoryObj.directoryMepId = [[dict objectForKey:@"DirMepID"]objectForKey:@"text"];
        directoryObj.directoryNetwordId = [[dict objectForKey:@"DirNtwID"]objectForKey:@"text"];
        directoryObj.directoryPPCText = [[dict objectForKey:@"DirPPCText"]objectForKey:@"text"];
        directoryObj.directoryPrcId = [[dict objectForKey:@"DirPrcID"]objectForKey:@"text"];
        directoryObj.directoryPrcImage = [[dict objectForKey:@"DirPrcImage"]objectForKey:@"text"];
        directoryObj.directoryProductCategory = [[dict objectForKey:@"DirProductCategory"]objectForKey:@"text"];
        directoryObj.directoryStaIdState = [[dict objectForKey:@"DirStaIDState"]objectForKey:@"text"];
        directoryObj.directoryState = [[dict objectForKey:@"DirState"]objectForKey:@"text"];
        directoryObj.directorySuburb = [[dict objectForKey:@"DirSuburb"]objectForKey:@"text"];
        directoryObj.directoryText = [[dict objectForKey:@"DirText"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
    
}


/**
 *  Store State Data For Country
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeStateInfoForCountry:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (StateInfo * Object  in [DataManager loadAllStateInfoForCountryIdFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        StateInfo * stateObj = [StateInfo MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        stateObj.stateId = [[dict objectForKey:@"StaID"]objectForKey:@"text"];
        stateObj.stateName = [[dict objectForKey:@"StaName"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Country Data
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeCountryData:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (CountryInfo * Object  in [DataManager loadAllActiveCountryFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        CountryInfo * countryObj = [CountryInfo MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        countryObj.countryId = [[dict objectForKey:@"CountryID"]objectForKey:@"text"];
        countryObj.countryName = [[dict objectForKey:@"CountryName"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
    
}


/**
 *  Store Country Data
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeLanguageData:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (LanguageInfo * Object  in [DataManager loadAllActiveLanguageFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        LanguageInfo * countryObj = [LanguageInfo MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        countryObj.languageId = [[dict objectForKey:@"LanguageID"]objectForKey:@"text"];
        countryObj.languageName = [[dict objectForKey:@"LanguageName"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
    
}


/**
 *  Store Card Data
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeCardData:(NSDictionary *)dict DataBlock:(DataBlock)block
{
    
    for (Card * Object  in [DataManager loadActiveCardDataFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
//    for (NSDictionary * dict in dataArray) {
        
        Card * cardObj = [Card MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        cardObj.cardExpire = [[dict objectForKey:@"CardExpire"]objectForKey:@"text"];
        cardObj.cardName = [[dict objectForKey:@"CardName"]objectForKey:@"text"];
        cardObj.cardNumber = [[dict objectForKey:@"CardNumber"]objectForKey:@"text"];
        cardObj.cardType = [[dict objectForKey:@"CardType"]objectForKey:@"text"];
        
//    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Video Data
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeVideoData:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (Videos * Object  in [DataManager loadAllVideoDataFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        Videos * videoObj = [Videos MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        videoObj.title = [[dict objectForKey:@"Title"]objectForKey:@"text"];
        videoObj.link = [[dict objectForKey:@"Link"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Investment Category Data
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeInvestmentData:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (InvestmentCategory * Object  in [DataManager loadAllInvestmentCategoryDataFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        InvestmentCategory * investObj = [InvestmentCategory MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        investObj.categoryId = [[dict objectForKey:@"CatID"]objectForKey:@"text"];
        investObj.categoryText = [[dict objectForKey:@"CalText"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Label Data
 *
 *  @param dataArray Array Coming from Server
 *  @param block     Block Returning Success OR Failure
 */
+(void)storeLabelData:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    NSLog(@"%@",dataArray);
    NSLog(@"%lu",(unsigned long)[dataArray count]);
    
    for (Labels * Object  in [DataManager loadAllLabelDataFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        Labels * labelObj = [Labels MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        labelObj.labelId = [[dict objectForKey:@"ID"]objectForKey:@"text"];
        labelObj.keyText = [[dict objectForKey:@"LableName"]objectForKey:@"text"];
        labelObj.valueText = [[dict objectForKey:@"LableText"]objectForKey:@"text"];
        labelObj.languageId = [[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"];
        labelObj.countryId = [[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Account Info
 *
 *  @param dict  Dictionary
 *  @param block Block Returning Success OR Failure
 */
+(void)storeAccountInfo:(NSMutableDictionary *)dict DataBlock:(DataBlock)block
{
    NSLog(@"%@",dict);
    
    for (AccountInfo * Object  in [DataManager loadAccountInfoFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    
    AccountInfo * accountObj = [AccountInfo MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    accountObj.accountManagerEmail = [[dict objectForKey:@"AccountManagerEmail"]objectForKey:@"text"];
    accountObj.accountManagerName = [[dict objectForKey:@"AccountManagerName"]objectForKey:@"text"];
    accountObj.accountManagerNumber = [[dict objectForKey:@"AccountManagerNumber"]objectForKey:@"text"];
    accountObj.availableSpending = [[dict objectForKey:@"AvailbleSpending"]objectForKey:@"text"];
    accountObj.cashBalance = [[dict objectForKey:@"CashBalance"]objectForKey:@"text"];
    accountObj.companyName = [[dict objectForKey:@"CompanyName"]objectForKey:@"text"];
    accountObj.contactName = [[dict objectForKey:@"ContactName"]objectForKey:@"text"];
    accountObj.creditLine = [[dict objectForKey:@"CreditLine"]objectForKey:@"text"];
    accountObj.email = [[dict objectForKey:@"Email"]objectForKey:@"text"];
    accountObj.franchise = [[dict objectForKey:@"Franchise"]objectForKey:@"text"];
    accountObj.mailingAddress = [[dict objectForKey:@"MailingAddress"]objectForKey:@"text"];
    accountObj.mobile = [[dict objectForKey:@"Mobile"]objectForKey:@"text"];
    accountObj.phone = [[dict objectForKey:@"Phone"]objectForKey:@"text"];
    accountObj.streetAddress = [[dict objectForKey:@"StreetAddress"]objectForKey:@"text"];
    accountObj.tradeBalance = [[dict objectForKey:@"TradeBalance"]objectForKey:@"text"];
    accountObj.tradingName = [[dict objectForKey:@"TradingName"]objectForKey:@"text"];
    accountObj.website = [[dict objectForKey:@"Website"]objectForKey:@"text"];

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];



}


/**
 *  Store Min Price Data
 *
 *  @param dataArray  Array
 *  @param block Block Returning Success OR Failure
 */
+(void)storeMinPriceData:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    
    for (MinPrice * Object  in [DataManager loadMinPriceFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {

    
    MinPrice * priceObj = [MinPrice MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    priceObj.name = [[dict objectForKey:@"Name"]objectForKey:@"text"];
    priceObj.value = [[dict objectForKey:@"Value"]objectForKey:@"text"];
    
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
    
    
    
}


/**
 *  Store Investment Search Data
 *
 *  @param dataArray  Array
 *  @param block Block Returning Success OR Failure
 */
+(void)storeInvestmentSearchData:(NSArray *)dataArray dataDictionary:(NSDictionary *)dictData DataBlock:(DataBlock)block
{
    for (InvestmentSearch * Object in [DataManager loadInvestmentSearchFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    if (dataArray != nil) {
        
        for (NSDictionary * dict in dataArray) {
            
            NSLog(@"%@",dict);
            
            InvestmentSearch * priceObj = [InvestmentSearch MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
            priceObj.selCatId = [[dict objectForKey:@"SelCatID"]objectForKey:@"text"];
            priceObj.selCrrId = [[dict objectForKey:@"SelCrrID"]objectForKey:@"text"];
            priceObj.selDateExpire = [[dict objectForKey:@"SelDateExpire"]objectForKey:@"text"];
            priceObj.selDatePosted = [[dict objectForKey:@"SelDatePosted"]objectForKey:@"text"];
            priceObj.selDescription = [[dict objectForKey:@"SelDis"]objectForKey:@"text"];
            priceObj.selId = [[dict objectForKey:@"SelID"]objectForKey:@"text"];
            priceObj.selMemId = [[dict objectForKey:@"SelMemID"]objectForKey:@"text"];
            priceObj.selNoOfViews = [[dict objectForKey:@"SelNoOfViews"]objectForKey:@"text"];
            priceObj.selPricePerQuantityCash = [[dict objectForKey:@"SelPricePerQuantityCash"]objectForKey:@"text"];
            priceObj.selPricePerQuantityTrade = [[dict objectForKey:@"SelPricePerQuantityTrade"]objectForKey:@"text"];
            priceObj.selQuantity = [[dict objectForKey:@"SelQuantity"]objectForKey:@"text"];
            priceObj.selStaIdStatus = [[dict objectForKey:@"SelStaIDStatus"]objectForKey:@"text"];
            priceObj.selStaIdType = [[dict objectForKey:@"SelStaIDType"]objectForKey:@"text"];
            priceObj.selTitle = [[dict objectForKey:@"SelTitle"]objectForKey:@"text"];
            
        }

    }
    else {
        
        InvestmentSearch * priceObj = [InvestmentSearch MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        priceObj.selCatId = [[dictData objectForKey:@"SelCatID"]objectForKey:@"text"];
        priceObj.selCrrId = [[dictData objectForKey:@"SelCrrID"]objectForKey:@"text"];
        priceObj.selDateExpire = [[dictData objectForKey:@"SelDateExpire"]objectForKey:@"text"];
        priceObj.selDatePosted = [[dictData objectForKey:@"SelDatePosted"]objectForKey:@"text"];
        priceObj.selDescription = [[dictData objectForKey:@"SelDis"]objectForKey:@"text"];
        priceObj.selId = [[dictData objectForKey:@"SelID"]objectForKey:@"text"];
        priceObj.selMemId = [[dictData objectForKey:@"SelMemID"]objectForKey:@"text"];
        priceObj.selNoOfViews = [[dictData objectForKey:@"SelNoOfViews"]objectForKey:@"text"];
        priceObj.selPricePerQuantityCash = [[dictData objectForKey:@"SelPricePerQuantityCash"]objectForKey:@"text"];
        priceObj.selPricePerQuantityTrade = [[dictData objectForKey:@"SelPricePerQuantityTrade"]objectForKey:@"text"];
        priceObj.selQuantity = [[dictData objectForKey:@"SelQuantity"]objectForKey:@"text"];
        priceObj.selStaIdStatus = [[dictData objectForKey:@"SelStaIDStatus"]objectForKey:@"text"];
        priceObj.selStaIdType = [[dictData objectForKey:@"SelStaIDType"]objectForKey:@"text"];
        priceObj.selTitle = [[dictData objectForKey:@"SelTitle"]objectForKey:@"text"];

    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


/**
 *  Store Max Price Data
 *
 *  @param dataArray  Array
 *  @param block Block Returning Success OR Failure
 */
+(void)storeMaxPriceData:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    
    for (MaxPrice * Object  in [DataManager loadMaxPriceFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        
        MaxPrice * priceObj = [MaxPrice MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        priceObj.name = [[dict objectForKey:@"Name"]objectForKey:@"text"];
        priceObj.value = [[dict objectForKey:@"Value"]objectForKey:@"text"];
        
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
    
    
    
}


/**
 *  Store Marketplace Front Image
 *
 *  @param dataArray  Array
 *  @param block Block Returning Success OR Failure
 */
+(void)storeMarketplaceFrontImage:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    for (MarketPlaceFrontImage * Object in [DataManager loadallMarketplaceFrontImagesFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        MarketPlaceFrontImage * imageObj = [MarketPlaceFrontImage MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        imageObj.imageLink = [[dict objectForKey:@"Image"]objectForKey:@"text"];
        imageObj.imageOrder = [dict objectForKey:@"msdata:rowOrder"];
        
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
}


/**
 *  Store Marketplace Front Image Link Data
 *
 *  @param dataArray  Array
 *  @param block Block Returning Success OR Failure
 */
+(void)storeMarketplaceFrontImageListing:(NSArray *)dataArray DataBlock:(DataBlock)block
{
    for (FrontImageDetail * Object  in [DataManager loadAllMarketplaceImageLinkDataFromCoreData]) {
        [Object MR_deleteEntity];
    }
    
    for (NSDictionary * dict in dataArray) {
        
        FrontImageDetail * productObj = [FrontImageDetail MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        productObj.latestBidAmount = [[dict objectForKey:@"LastBidAmount"]objectForKey:@"text"];
        productObj.location = [[dict objectForKey:@"Location"]objectForKey:@"text"];
        productObj.rowNumber = [[dict objectForKey:@"RowNumber"]objectForKey:@"text"];
        productObj.selCategoryId = [[dict objectForKey:@"SelCatID"]objectForKey:@"text"];
        productObj.selCrrId = [[dict objectForKey:@"SelCrrID"]objectForKey:@"text"];
        productObj.selDateExpire = [[dict objectForKey:@"SelDateExpire"]objectForKey:@"text"];
        productObj.selDatePosted = [[dict objectForKey:@"SelDatePosted"]objectForKey:@"text"];
        productObj.selDis = [[dict objectForKey:@"SelDis"]objectForKey:@"text"];
        productObj.selEnteredByMemId = [[dict objectForKey:@"SelEnteredByMemID"]objectForKey:@"text"];
        productObj.selId = [[dict objectForKey:@"SelID"]objectForKey:@"text"];
        productObj.selMemId = [[dict objectForKey:@"SelMemID"]objectForKey:@"text"];
        productObj.selNoOfViews = [[dict objectForKey:@"SelNoOfViews"]objectForKey:@"text"];
        productObj.selPricePerQuantityCash = [[dict objectForKey:@"SelPricePerQuantityCash"]objectForKey:@"text"];
        productObj.selPricePerQuantityTrade = [[dict objectForKey:@"SelPricePerQuantityTrade"]objectForKey:@"text"];
        productObj.selQuantity = [[dict objectForKey:@"SelQuantity"]objectForKey:@"text"];
        productObj.selTitle = [[dict objectForKey:@"SelTitle"]objectForKey:@"text"];
        productObj.totalPages = [[dict objectForKey:@"TotalPages"]objectForKey:@"text"];
        productObj.totalRecords = [[dict objectForKey:@"TotalRecords"]objectForKey:@"text"];
        productObj.image = [[dict objectForKey:@"Image"]objectForKey:@"text"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

/**
 *  Returns Language Info Object
 *
 *  @param languageId LanguageID
 *  @param block      Block Returning Success OR Failure
 *
 *  @return <#return value description#>
 */
+(LanguageInfo *)getLanguageInfoForLanguageId:(NSString *)languageId
{
    LanguageInfo * languageObj = [LanguageInfo MR_findFirstByAttribute:@"languageId" withValue:languageId];
    
    return languageObj;
}


#pragma mark - Core Data Getters
/**
 *  Load All Contacts
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllContactsFromCoreData
{
    return [Contact MR_findAll].mutableCopy;
}


/**
 *  Load All MarketPlace Categories
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllMarketPlaceCategoriesFromCoreData
{
    return [MarketPlaceCategories MR_findAll].mutableCopy;
}


/**
 *  Load All MarketPlace Products By Category
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllMarketPlaceProductsPerCategoryFromCoreData
{
    return [ProductsPerCategory MR_findAll].mutableCopy;
}


/**
 *  Load All Events
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllEventsFromCoreData;
{
    return [Events MR_findAll].mutableCopy;
}


/**
 *  Load All Latest Products
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllLatestProductsFromCoreData
{
    return [LatestProducts MR_findAll].mutableCopy;
}


/**
 *  Load All Search Products
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllSearchProductsFromCoreData
{
    return [SearchProducts MR_findAll].mutableCopy;
}


/**
 *  Load All Buy History
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllBuyHistoryFromCoreData
{
    return [BuyHistory MR_findAll].mutableCopy;
}


/**
 *  Load All Buy History
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllSellHistoryFromCoreData
{
    return [SellHistory MR_findAll].mutableCopy;
}


/**
 *  Load All Wines Categories
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllWinesCategoryFromCoreData
{
    return [WinesCategory MR_findAll].mutableCopy;
}

/**
 *  Load All Wines Per Categories
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllWinesPerCategoryFromCoreData
{
    return [WinesPerCategory MR_findAll].mutableCopy;
}

/**
 *  Load All Accomodations
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllLifestyleAccomodationsFromCoreData
{
    return [Accomodation MR_findAll].mutableCopy;
}


/**
 *  Load All Gift Packages
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllLifestyleGiftPackagesFromCoreData
{
    return [GiftPackages MR_findAll].mutableCopy;
}


/**
 *  Load All Experiences
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllLifestyleExperiencesFromCoreData
{
    return [Experiences MR_findAll].mutableCopy;
}

/**
 *  Load All Vouchers
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllLifestyleVouchersFromCoreData
{
    return [Vouchers MR_findAll].mutableCopy;
}

/**
 *  Load All Product Categories
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllProductCategoriesFromCoreData
{
    return [ProductCategory MR_findAll].mutableCopy;
}


/**
 *  Load All Directory Search Results
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllDirectoryResultsFromCoreData
{
    return [Directory MR_findAll].mutableCopy;
}

/**
 *  Load All State Info for Particular Country
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllStateInfoForCountryIdFromCoreData
{
    return [StateInfo MR_findAll].mutableCopy;
}

/**
 *  Load All Active Country Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllActiveCountryFromCoreData
{
    return [CountryInfo MR_findAll].mutableCopy;
}


/**
 *  Load All Active Country Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllActiveLanguageFromCoreData
{
    return [LanguageInfo MR_findAll].mutableCopy;
}

/**
 *  Load Card Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadActiveCardDataFromCoreData
{
    return [Card MR_findAll].mutableCopy;
}


/**
 *  Load Video Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllVideoDataFromCoreData
{
    return [Videos MR_findAll].mutableCopy;
}


/**
 *  Load Video Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllInvestmentCategoryDataFromCoreData
{
    return [InvestmentCategory MR_findAll].mutableCopy;
}


/**
 *  Load All Labels
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllLabelDataFromCoreData
{
    return [Labels MR_findAll].mutableCopy;
}

/**
 *  Load Contact Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAccountInfoFromCoreData
{
    return [AccountInfo MR_findAll].mutableCopy;
}

/**
 *  Load Min Price
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadMinPriceFromCoreData
{
    return [MinPrice MR_findAll].mutableCopy;
}


/**
 *  Load Max Price
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadMaxPriceFromCoreData
{
    return [MaxPrice MR_findAll].mutableCopy;
}


/**
 *  Load Investment Search
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadInvestmentSearchFromCoreData
{
    return [InvestmentSearch MR_findAll].mutableCopy;
}


+(NSMutableArray *)loadallMarketplaceFrontImagesFromCoreData
{
    return [MarketPlaceFrontImage MR_findAll].mutableCopy;
}


/**
 *  Load All MarketPlace Image Link Data Set
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllMarketplaceImageLinkDataFromCoreData
{
    return [FrontImageDetail MR_findAll].mutableCopy;
}


/**
 *  Load All Investment Search
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllInvestmentSearchDataFromCoreData
{
    return [InvestmentSearch MR_findAll].mutableCopy;
}

@end
