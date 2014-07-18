//
//  DataManager.h
//  BBX
//
//  Created by Roman Khan on 03/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBXBlocks.h"
#import "LanguageInfo.h"

@interface DataManager : NSObject

@property (nonatomic, strong) NSMutableArray * arrayKey;
@property (nonatomic, strong) NSMutableArray * arrayValue;
@property (nonatomic, strong) NSMutableDictionary * dictData;


//! Singleton access
+ (DataManager *)sharedManager;

/**
 *  Store Marketplace Categories
 *
 *  @param categoryArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeMarketplaceCategories:(NSArray *)categoryArray DataBlock:(DataBlock)block;


/**
 *  Store Contact Info
 *
 *  @param contactArray Contact Array from Server
 *  @param block        Block Returning Success OR Failure
 */
+(void)storeContactInfo:(NSArray *)contactArray DataBlock:(DataBlock)block;

/**
 *  Store Products for MarketPlace ID
 *
 *  @param productArray Product Array from Server
 *  @param block        Block Returning Success OR Failure
 */
+(void)storeMarketPlaceProductsForCategories:(NSArray *)productArray DataBlock:(DataBlock)block;


/**
 *  Store All Events
 *
 *  @param eventsArray Events Array from Server
 *  @param block       Block Returning Success OR Failure
 */
+(void)storeAllEvents:(NSArray *)eventsArray dataDictionary:(NSDictionary *)dictData DataBlock:(DataBlock)block;


/**
 *  Store All Latest Products
 *
 *  @param eventsArray Products Array from Server
 *  @param block       Block Returning Success OR Failure
 */
+(void)storeAllLatestProducts:(NSArray *)array DataBlock:(DataBlock)block;


/**
 *  Store All MarketPlace Search Products
 *
 *  @param eventsArray Products Array from Server
 *  @param block       Block Returning Success OR Failure
 */
+(void)storeMarketPlaceSearchProducts:(NSArray *)array DataBlock:(DataBlock)block;


/**
 *  Store All Current Member Buy History
 *
 *  @param array Buy Array From Server
 *  @param block Block Returning Success OR Failure
 */
+(void)storeCurrentMemberBuyHistory:(NSArray *)array DataBlock:(DataBlock)block;


/**
 *  Store All Current Member Buy History
 *
 *  @param array Buy Array From Server
 *  @param block Block Returning Success OR Failure
 */
+(void)storeCurrentMemberSellHistory:(NSArray *)array DataBlock:(DataBlock)block;


/**
 *  Store Wines Categories
 *
 *  @param categoryArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeWinesCategories:(NSArray *)categoryArray DataBlock:(DataBlock)block;


/**
 *  Store Wines As Per Catgories
 *
 *  @param categoryArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeWinesPerCategories:(NSArray *)categoryArray DataBlock:(DataBlock)block;


/**
 *  Store Lifestyle Accomodations
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeLifestyleAccomodations:(NSArray *)dataArray DataBlock:(DataBlock)block;


/**
 *  Store Lifestyle Gift Packages
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeLifestyleGiftPackages:(NSArray *)dataArray DataBlock:(DataBlock)block;


/**
 *  Store Lifestyle Experiences
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeLifestyleExperiences:(NSArray *)dataArray DataBlock:(DataBlock)block;


/**
 *  Store Product Categories
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeProductCategories:(NSArray *)dataArray DataBlock:(DataBlock)block;


/**
 *  Store Directory Search Results
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeDirectorySearchResults:(NSArray *)dataArray DataBlock:(DataBlock)block;


/**
 *  Store State Data For Country
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeStateInfoForCountry:(NSArray *)dataArray DataBlock:(DataBlock)block;


/**
 *  Store Country Data
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeCountryData:(NSArray *)dataArray DataBlock:(DataBlock)block;


/**
 *  Store Country Data
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeLanguageData:(NSArray *)dataArray DataBlock:(DataBlock)block;


/**
 *  Store Card Data
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeCardData:(NSDictionary *)dict DataBlock:(DataBlock)block;


/**
 *  Store Video Data
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeVideoData:(NSArray *)dataArray DataBlock:(DataBlock)block;


/**
 *  Store Investment Category Data
 *
 *  @param dataArray Array Coming from Server
 *  @param dataBlock     Block Returning Success OR Failure
 */
+(void)storeInvestmentData:(NSArray *)dataArray DataBlock:(DataBlock)block;


/**
 *  Store Label Data
 *
 *  @param dataArray Array Coming from Server
 *  @param block     Block Returning Success OR Failure
 */
+(void)storeLabelData:(NSArray *)dataArray DataBlock:(DataBlock)block;


/**
 *  Store Account Info
 *
 *  @param dict  Dictionary
 *  @param block Block Returning Success OR Failure
 */
+(void)storeAccountInfo:(NSMutableDictionary *)dict DataBlock:(DataBlock)block;


/**
 *  Store Min Price Data
 *
 *  @param dataArray  Array
 *  @param block Block Returning Success OR Failure
 */
+(void)storeMinPriceData:(NSArray *)dataArray DataBlock:(DataBlock)block;



/**
 *  Store Max Price Data
 *
 *  @param dataArray  Array
 *  @param block Block Returning Success OR Failure
 */
+(void)storeMaxPriceData:(NSArray *)dataArray DataBlock:(DataBlock)block;



/**
 *  Returns Language Info Object
 *
 *  @param languageId LanguageID
 *  @param block      Block Returning Success OR Failure
 *
 *  @return Language Info Object
 */
+(LanguageInfo *)getLanguageInfoForLanguageId:(NSString *)languageId;

/**
 *  Load All Contacts
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllContactsFromCoreData;


/**
 *  Load All MarketPlace Categories
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllMarketPlaceCategoriesFromCoreData;


/**
 *  Load All MarketPlace Products By Category
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllMarketPlaceProductsPerCategoryFromCoreData;


/**
 *  Load All Events
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllEventsFromCoreData;


/**
 *  Load All Latest Products
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllLatestProductsFromCoreData;


/**
 *  Load All Search Products
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllSearchProductsFromCoreData;


/**
 *  Load All Buy History
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllBuyHistoryFromCoreData;


/**
 *  Load All Buy History
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllSellHistoryFromCoreData;


/**
 *  Load All Wines Categories
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllWinesCategoryFromCoreData;


/**
 *  Load All Wines Per Categories
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllWinesPerCategoryFromCoreData;


/**
 *  Load All Accomodations
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllLifestyleAccomodationsFromCoreData;


/**
 *  Load All Gift Packages
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllLifestyleGiftPackagesFromCoreData;


/**
 *  Load All Experiences
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllLifestyleExperiencesFromCoreData;


/**
 *  Load All Product Categories
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllProductCategoriesFromCoreData;


/**
 *  Load All Directory Search Results
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllDirectoryResultsFromCoreData;


/**
 *  Load All State Info for Particular Country
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllStateInfoForCountryIdFromCoreData;


/**
 *  Load All Active Country Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllActiveCountryFromCoreData;


/**
 *  Load All Active Country Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllActiveLanguageFromCoreData;


/**
 *  Load Card Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadActiveCardDataFromCoreData;


/**
 *  Load Video Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllVideoDataFromCoreData;


/**
 *  Load Video Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllInvestmentCategoryDataFromCoreData;


/**
 *  Load All Labels
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAllLabelDataFromCoreData;


/**
 *  Load Contact Info
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadAccountInfoFromCoreData;


/**
 *  Load Min Price
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadMinPriceFromCoreData;


/**
 *  Load Max Price
 *
 *  @return Returns An Array
 */
+(NSMutableArray *)loadMaxPriceFromCoreData;

@end
