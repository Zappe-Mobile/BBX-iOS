
//
//  RequestManager.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"
#import "XMLReader.h"

@interface RequestManager ()
{
    NSURLConnection * connection;
    NSMutableData * webData;
  
}
@property (nonatomic, copy, readwrite) CompletionBlock completionBlock;
@end

@implementation RequestManager
@synthesize completionBlock;

static RequestManager * sharedManager;

/**
 *  Initialization Method
 */
+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
		sharedManager = [[RequestManager alloc] init];
    }
}

#pragma mark - Singleton Object
/**
 *  Singleton Object
 *
 *  @return RequestManager Singleton Object
 */
+ (RequestManager *)sharedManager {
	return (sharedManager);
}

#pragma mark - Login Methods
/**
 *  Login Method
 *
 *  @param userName        Username
 *  @param pin             Pin
 *  @param block Block Returning Success OR Failure
 */
-(void)loginUserWithUsername:(NSString *)userName WithPin:(NSString *)pin WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><Checklogin xmlns=\"http://tempuri.org/\"><Username>%@</Username><Password>%@</Password></Checklogin></soap:Body></soap:Envelope>",userName,pin];
    
    NSURL * url = [NSURL URLWithString:@"https://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/Checklogin" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setTimeoutInterval:20];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON: %@ : %@", responseObject,dict);
            
            block (YES, dict);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}


/**
 *  Get Member Account Details
 *
 *  @param userName   Username of the Current User
 *  @param password   Password of the Current User
 *  @param languageId Language Selected
 *  @param block      Block Returning Success OR Failure
 */
-(void)getMemberAccountDetailsWithUsername:(NSString *)userName WithPassword:(NSString *)password WithLanguageId:(NSString *)languageId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><AccountDetailsByMember xmlns=\"http://tempuri.org/\"><Username>%@</Username><Password>%@</Password><LanguageID>%@</LanguageID></AccountDetailsByMember></soap:Body></soap:Envelope>",userName,password,languageId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/AccountDetailsByMember" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON: %@ : %@", responseObject,dict);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"AccountDetailsByMemberResponse"]
                                             objectForKey:@"AccountDetailsByMemberResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            

            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Get Current Member Account Status
 *
 *  @param memberId Member Id
 *  @param block    Block Returning Success OR Failure
 */
-(void)getCurrentMemberAccountStatusByMemberId:(NSString *)memberId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><GetCurrentMemberAccountStatus xmlns=\"http://tempuri.org/\"><MemberID>%@</MemberID></GetCurrentMemberAccountStatus></soap:Body></soap:Envelope>",memberId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/GetCurrentMemberAccountStatus" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON: %@ : %@", responseObject,dict);
            
            block (YES, dict);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Get Current Member Card Type Details
 *
 *  @param username   Username of the Current User
 *  @param password   Password of the Current User
 *  @param languageId Language Selected
 *  @param block      Block Returning Success OR Failure
 */
- (void)getCurrentMemberAccountCardDetailsWithUsername:(NSString *)username withPassword:(NSString *)password withLanguageId:(NSString *)languageId withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><AccountDetailsGetMemberCardDetails xmlns=\"http://tempuri.org/\"><Username>%@</Username><Password>%@</Password><LanguageID>%@</LanguageID></AccountDetailsGetMemberCardDetails></soap:Body></soap:Envelope>",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"],[[NSUserDefaults standardUserDefaults]objectForKey:@"PIN"],[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/AccountDetailsGetMemberCardDetails" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON: %@ : %@", responseObject,dict);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"AccountDetailsGetMemberCardDetailsResponse"]
                                             objectForKey:@"AccountDetailsGetMemberCardDetailsResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];

            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


#pragma mark - Localization Methods
/**
 *  Active Country List
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getActiveCountryListWithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><CountryListActive xmlns=\"http://tempuri.org/\"></CountryListActive></soap:Body></soap:Envelope>"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/CountryListActive" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"CountryListActiveResponse"]
                           objectForKey:@"CountryListActiveResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"CountryListActiveResponse"]
                                             objectForKey:@"CountryListActiveResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Language List Details
 *
 *  @param block     block Block Returning Success OR Failure
 */
-(void)getActiveLanguageListWithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><LanguageListActive xmlns=\"http://tempuri.org/\"></LanguageListActive></soap:Body></soap:Envelope>"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/LanguageListActive" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"LanguageListActiveResponse"]
                           objectForKey:@"LanguageListActiveResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"LanguageListActiveResponse"]
                                             objectForKey:@"LanguageListActiveResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Active State List
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getStateIdByCountryWithCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><StateNameIDByCountryID xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID></StateNameIDByCountryID></soap:Body></soap:Envelope>",countryId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/StateNameIDByCountryID" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"StateNameIDByCountryIDResponse"]
                           objectForKey:@"StateNameIDByCountryIDResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"StateNameIDByCountryIDResponse"]
                                             objectForKey:@"StateNameIDByCountryIDResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Contact Details
 *
 *  @param countryId Country in which current user is
 *  @param block     block Block Returning Success OR Failure
 */
-(void)getContactDetailsByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><ContactDetailsByCountryID xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><LanguageID>1</LanguageID></ContactDetailsByCountryID></soap:Body></soap:Envelope>",countryId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/ContactDetailsByCountryID" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"ContactDetailsByCountryIDResponse"]
                                             objectForKey:@"ContactDetailsByCountryIDResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


#pragma mark - MarketPlace Methods
/**
 *  Fetch All MarketPlace Categories
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getAllMarketplaceCategoriesWithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><MarketPlaceGetAllCategories xmlns=\"http://tempuri.org/\"></MarketPlaceGetAllCategories></soap:Body></soap:Envelope>"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/MarketPlaceGetAllCategories" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                           objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                              objectForKey:@"soap:Body"]
                                             objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                                            objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                                           objectForKey:@"diffgr:diffgram"]
                                          objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}

/**
 *  Fetch All Products for a Particular Category Id
 *
 *  @param categoryId Category For Which Products are being fetched
 *  @param countryId  Country in which the current user is
 *  @param pageNumber Page no of the Data set being sent from server
 *  @param pageLimit  Number of Records Per Page
 */
-(void)getAllMarketplaceProductsForCategoryId:(NSString *)categoryId WithCountryId:(NSString *)countryId WithPageNumber:(NSString *)pageNumber WithPageLimit:(NSString *)pageLimit WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><MarketPlaceProductsByCategoryID xmlns=\"http://tempuri.org/\"><CategoryID>%@</CategoryID><CountryID>%@</CountryID><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage></MarketPlaceProductsByCategoryID></soap:Body></soap:Envelope>",categoryId,countryId,pageNumber,pageLimit];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/MarketPlaceProductsByCategoryID" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceProductsByCategoryIDResponse"]
                           objectForKey:@"MarketPlaceProductsByCategoryIDResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceProductsByCategoryIDResponse"]
                                             objectForKey:@"MarketPlaceProductsByCategoryIDResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@",error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Search Marketplace for Products
 *
 *  @param searchString Search String
 *  @param block        Block Returning Success OR Failure
 */
-(void)searchMarketplaceWithSearchString:(NSString *)searchString WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><MarketPlaceSearch xmlns=\"http://tempuri.org/\"><Keyword>%@</Keyword><CountryID>5</CountryID><LanguageID>1</LanguageID><PageNumber>1</PageNumber><NumberOfProductPerPage>100</NumberOfProductPerPage></MarketPlaceSearch></soap:Body></soap:Envelope>",searchString];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/MarketPlaceSearch" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceSearchResponse"]
                           objectForKey:@"MarketPlaceSearchResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceSearchResponse"]
                                             objectForKey:@"MarketPlaceSearchResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


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
-(void)getMarketplaceCurrentMemberSellHistoryWithUsername:(NSString *)username WithPassword:(NSString *)password WithMemberId:(NSString *)memberId WithCountryId:(NSString *)countryId WithPageNumber:(NSString *)pageNumber WithPageLimit:(NSString *)pageLimit WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><MarketPlaceCurrentMemberSellHistory xmlns=\"http://tempuri.org/\"><UserName>%@</UserName><Password>%@</Password><CurrentMemberID>%@</CurrentMemberID><CountryID>%@</CountryID><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage></MarketPlaceCurrentMemberSellHistory></soap:Body></soap:Envelope>",@"62204030180102050",@"1712",@"247",countryId,pageNumber,pageLimit];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/MarketPlaceCurrentMemberSellHistory" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceCurrentMemberSellHistoryResponse"]
                           objectForKey:@"MarketPlaceCurrentMemberSellHistoryResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceCurrentMemberSellHistoryResponse"]
                                             objectForKey:@"MarketPlaceCurrentMemberSellHistoryResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


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
-(void)getMarketplaceCurrentMemberBuyHistoryWithUsername:(NSString *)username WithPassword:(NSString *)password WithMemberId:(NSString *)memberId WithCountryId:(NSString *)countryId WithPageNumber:(NSString *)pageNumber WithPageLimit:(NSString *)pageLimit WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><MarketPlaceCurrentMemberBuyHistory xmlns=\"http://tempuri.org/\"><UserName>%@</UserName><Password>%@</Password><CurrentMemberID>%@</CurrentMemberID><CountryID>%@</CountryID><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage></MarketPlaceCurrentMemberBuyHistory></soap:Body></soap:Envelope>",@"62204030180102050",@"1712",@"247",countryId,pageNumber,pageLimit];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/MarketPlaceCurrentMemberBuyHistory" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceCurrentMemberBuyHistoryResponse"]
                           objectForKey:@"MarketPlaceCurrentMemberBuyHistoryResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceCurrentMemberBuyHistoryResponse"]
                                             objectForKey:@"MarketPlaceCurrentMemberBuyHistoryResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
 
}


/**
 *  Get Marketplace Latest Product Listing By Country
 *
 *  @param countryId  Country in which the current user is
 *  @param pageNumber Page no of the Data set being sent from server
 *  @param pageLimit  Number of Records Per Page
 *  @param block      Block Returning Success OR Failure
 */
-(void)getMarketplaceLatestProductListingWithCountryId:(NSString *)countryId WithPageNumber:(NSString *)pageNumber WithPageLimit:(NSString *)pageLimit WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><MarketPlaceLatestProductListing xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage></MarketPlaceLatestProductListing></soap:Body></soap:Envelope>",countryId,pageNumber,pageLimit];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/MarketPlaceLatestProductListing" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceLatestProductListingResponse"]
                           objectForKey:@"MarketPlaceLatestProductListingResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceLatestProductListingResponse"]
                                             objectForKey:@"MarketPlaceLatestProductListingResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Get Marketplace Product Details By SellId & CountryId
 *
 *  @param sellId    Sell ID
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getMarketplaceProductDetailsWithSellId:(NSString *)sellId WithCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><MarketPlaceProductDetailsBySelID xmlns=\"http://tempuri.org/\"><SelID>%@</SelID></MarketPlaceProductDetailsBySelID></soap:Body></soap:Envelope>",sellId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/MarketPlaceProductDetailsBySelID" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceProductDetailsBySelIDResponse"]
                           objectForKey:@"MarketPlaceProductDetailsBySelIDResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceProductDetailsBySelIDResponse"]
                                             objectForKey:@"MarketPlaceProductDetailsBySelIDResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  MarketPlace Closing Soon Product Listing
 *
 *  @param countryId  Country in which the current user is
 *  @param pageNumber Page no of the Data set being sent from server
 *  @param pageLimit  Number of Records Per Page
 *  @param block      Block Returning Success OR Failure
 */
-(void)getMarketplaceClosingSoonListingWithCountryId:(NSString *)countryId WithPageNumber:(NSString *)pageNumber WithPageLimit:(NSString *)pageLimit WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><MarketPlaceClosingSoonProductListing xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage></MarketPlaceClosingSoonProductListing></soap:Body></soap:Envelope>",countryId,pageNumber,pageLimit];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/MarketPlaceClosingSoonProductListing" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceLatestProductListingResponse"]
                           objectForKey:@"MarketPlaceLatestProductListingResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceLatestProductListingResponse"]
                                             objectForKey:@"MarketPlaceLatestProductListingResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Bid Now
 *
 *  @param quantity  Quantity of Product
 *  @param sellId    Sell ID
 *  @param bidAmount Bid Amount
 *  @param block     Block Returning Success OR Failure
 */
-(void)marketPlaceProductBidNowWithQuantity:(NSString *)quantity withSellId:(NSString *)sellId withBidAmount:(NSString *)bidAmount withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><MarketPlaceBidNowButton xmlns=\"http://tempuri.org/\"><UserName>%@</UserName><Password>%@</Password><LanguageID>%@</LanguageID><Quantity>%@</Quantity><SellID>%@</SellID><BidAmount>%@</BidAmount></MarketPlaceBidNowButton></soap:Body></soap:Envelope>",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"],[[NSUserDefaults standardUserDefaults]objectForKey:@"PIN"],[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"],quantity,sellId,bidAmount];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/MarketPlaceBidNowButton" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceLatestProductListingResponse"]
                           objectForKey:@"MarketPlaceLatestProductListingResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceLatestProductListingResponse"]
                                             objectForKey:@"MarketPlaceLatestProductListingResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Buy Now
 *
 *  @param quantity Quantity of Product
 *  @param sellId   Sell ID
 *  @param block    Block Returning Success OR Failure
 */
-(void)marketPlaceProductBuyNowWithQuantity:(NSString *)quantity withSellId:(NSString *)sellId withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><MarketPlaceBuyNowButton xmlns=\"http://tempuri.org/\"><UserName>%@</UserName><Password>%@</Password><LanguageID>%@</LanguageID><Quantity>%@</Quantity><SellID>%@</SellID></MarketPlaceBuyNowButton></soap:Body></soap:Envelope>",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"],[[NSUserDefaults standardUserDefaults]objectForKey:@"PIN"],[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"],quantity,sellId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/MarketPlaceBuyNowButton" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceBuyNowButtonResponse"]
                           objectForKey:@"MarketPlaceBuyNowButtonResult"]);
            
            NSMutableDictionary * dict1 = [[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceBuyNowButtonResponse"]
                                             objectForKey:@"MarketPlaceBuyNowButtonResult"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


#pragma mark - Events Methods
/**
 *  Get Events Details By CountryId
 *
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getEventsDetailsByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><EventsDetailsByCountryID xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><LanguageID>%@</LanguageID><PageNumber>1</PageNumber><NumberOfProductPerPage>50</NumberOfProductPerPage></EventsDetailsByCountryID></soap:Body></soap:Envelope>",countryId,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];

    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/EventsDetailsByCountryID" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"EventsDetailsByCountryIDResponse"]
                           objectForKey:@"EventsDetailsByCountryIDResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"EventsDetailsByCountryIDResponse"]
                                             objectForKey:@"EventsDetailsByCountryIDResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}



#pragma mark - How BBX Works
/**
 *  How BBX Works
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getHowBBXWorksWithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><GetHowBBXWorks xmlns=\"http://tempuri.org/\"></GetHowBBXWorks></soap:Body></soap:Envelope>"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/GetHowBBXWorks" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                           objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                                             objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Submit Enquiry
 *
 *  @param userName Username of the current user
 *  @param password Password of the current user
 *  @param enquiry  Enquiry Text
 *  @param block    Block Returning Success OR Failure
 */
-(void)submitEnquiryWithUsername:(NSString *)userName WithPassword:(NSString *)password WithEnquiryText:(NSString *)enquiry WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><InquirySubmit xmlns=\"http://tempuri.org/\"><Username>%@</Username><Password>%@</Password><InquiryText>%@</InquiryText></InquirySubmit><LanguageID>%@</LanguageID><CountryID>%@</CountryID></soap:Body></soap:Envelope>",userName,password,enquiry,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"],@"5"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/InquirySubmit" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"InquirySubmitResponse"]
                           objectForKey:@"InquirySubmitResult"]);
            
            NSMutableDictionary * dict1 = [[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"InquirySubmitResponse"]
                                             objectForKey:@"InquirySubmitResult"];
                                            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


#pragma mark - Process BBX Transaction
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
-(void)processBBXTransactionWithUsername:(NSString *)userName WithPassword:(NSString *)password WithLanguageId:(NSString *)languageId WithBuyerId:(NSString *)buyerId WithOtherMemberBuyer:(NSString *)memberBuyer WithTransactionAmount:(NSString *)amount WithTransactionDescription:(NSString *)description WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><TransactionProcess xmlns=\"http://tempuri.org/\"><Username>%@</Username><Password>%@</Password><LanguageID>%@</LanguageID><BuyerID>%@</BuyerID><OtherMemberBuyer>%@</OtherMemberBuyer><TransactionAmount>%@</TransactionAmount><TransactionDescription>%@</TransactionDescription></TransactionProcess></soap:Body></soap:Envelope>",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"],[[NSUserDefaults standardUserDefaults]objectForKey:@"PIN"],[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"],buyerId,memberBuyer,amount,description];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/TransactionProcess" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"TransactionProcessResponse"]
                           objectForKey:@"TransactionProcessResult"]);
            
            NSMutableDictionary * dict1 = [[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"TransactionProcessResponse"]
                                             objectForKey:@"TransactionProcessResult"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
 
}


#pragma mark - Leisure & Lifestyle
/**
 *  Get All Accomodations
 *
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getAllAccomodationsByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><LifeStyleGetAccomodation xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><LanguageID>%@</LanguageID><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage></LifeStyleGetAccomodation></soap:Body></soap:Envelope>",countryId,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"],@"1",@"100"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/LifeStyleGetAccomodation" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"LifeStyleGetAccomodationResponse"]
                           objectForKey:@"LifeStyleGetAccomodationResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"LifeStyleGetAccomodationResponse"]
                                             objectForKey:@"LifeStyleGetAccomodationResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}


/**
 *  Get All Experiences
 *
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getAllExperiencesByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><LifeStyleGetAllExperiences xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><LanguageID>%@</LanguageID><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage></LifeStyleGetAllExperiences></soap:Body></soap:Envelope>",countryId,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"],@"1",@"100"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/LifeStyleGetAllExperiences" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"LifeStyleGetAllExperiencesResponse"]
                           objectForKey:@"LifeStyleGetAllExperiencesResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"LifeStyleGetAllExperiencesResponse"]
                                             objectForKey:@"LifeStyleGetAllExperiencesResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Get All Gift Packages
 *
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getAllGiftPackagesByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><LifeStyleGetAllGiftPackages xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><LanguageID>%@</LanguageID><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage></LifeStyleGetAllGiftPackages></soap:Body></soap:Envelope>",countryId,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"],@"1",@"100"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/LifeStyleGetAllGiftPackages" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"LifeStyleGetAllGiftPackagesResponse"]
                           objectForKey:@"LifeStyleGetAllGiftPackagesResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"LifeStyleGetAllGiftPackagesResponse"]
                                             objectForKey:@"LifeStyleGetAllGiftPackagesResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Get Lifestyle Search
 *
 *  @param countryId Country in which the user is
 *  @param block     Block Returning Success OR Failure
 */
-(void)getLifestyleSearchWithText:(NSString *)searchText withCountryId:(NSString *)countryId withLanguageId:(NSString *)languageId withPageNumber:(NSString *)pageNumber withProductCount:(NSString *)productCount WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><LifeStyleGetAllGiftPackages xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><LanguageID>%@</LanguageID><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage></LifeStyleGetAllGiftPackages></soap:Body></soap:Envelope>",countryId,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"],@"1",@"100"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/LifeStyleGetAllGiftPackages" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"LifeStyleGetAllGiftPackagesResponse"]
                           objectForKey:@"LifeStyleGetAllGiftPackagesResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"LifeStyleGetAllGiftPackagesResponse"]
                                             objectForKey:@"LifeStyleGetAllGiftPackagesResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
    
}

#pragma mark - Wines
/**
 *  Get All Wines
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getAllWinesCategoriesWithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><WineGetAllCategories xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><UserName>%@</UserName><Password>%@</Password></WineGetAllCategories></soap:Body></soap:Envelope>",@"5",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"],[[NSUserDefaults standardUserDefaults]objectForKey:@"PIN"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/WineGetAllCategories" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"WineGetAllCategoriesResponse"]
                           objectForKey:@"WineGetAllCategoriesResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"WineGetAllCategoriesResponse"]
                                             objectForKey:@"WineGetAllCategoriesResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}



/**
 *  Get All Wines By Category
 *
 *  @param categoryId Category ID
 *  @param block      Block Returning Success OR Failure
 */
-(void)getAllWinesByCategory:(NSString *)categoryId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><WinesListByCategory xmlns=\"http://tempuri.org/\"><CategoryID>%@</CategoryID><CountryID>%@</CountryID><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage></WinesListByCategory></soap:Body></soap:Envelope>",categoryId,@"5",@"1",@"100"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/WinesListByCategory" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"WinesListByCategoryResponse"]
                           objectForKey:@"WinesListByCategoryResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"WinesListByCategoryResponse"]
                                             objectForKey:@"WinesListByCategoryResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Wine Detail
 *
 *  @param name  SelId
 *  @param block Block Returning Success OR Failure
 */
-(void)getWineProductDetailBySelId:(NSString *)selId WithCompletionBlock:(CompletionBlock)block;
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><WineProductDetailsBySelID xmlns=\"http://tempuri.org/\"><SelID>%@</SelID><LanguageID>%@</LanguageID></WineProductDetailsBySelID></soap:Body></soap:Envelope>",selId,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/WineProductDetailsBySelID" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"WineProductDetailsBySelIDResponse"]
                           objectForKey:@"WineProductDetailsBySelIDResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"WineProductDetailsBySelIDResponse"]
                                             objectForKey:@"WineProductDetailsBySelIDResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Get All Wines In Current Member Cart
 *
 *  @param memberId Member Id
 *  @param block    Block Returning Success OR Failure
 */
-(void)getAllWinesInCurrentMemberCartWithMemberId:(NSString *)memberId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><GetAllWinesInCurrentMemberCart xmlns=\"http://tempuri.org/\"><CurrentMemberID>%@</CurrentMemberID></GetAllWinesInCurrentMemberCart></soap:Body></soap:Envelope>",memberId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/GetAllWinesInCurrentMemberCart" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                           objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                                             objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


#pragma mark - Rewards
/**
 *  Get All Rewards
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getAllRewardsWithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><GetRewardsIntro xmlns=\"http://tempuri.org/\"></GetRewardsIntro></soap:Body></soap:Envelope>"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/GetRewardsIntro" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                           objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                                             objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Get Rewards For Current Member
 *
 *  @param memberId Member Id
 *  @param block    Block Returning Success OR Failure
 */
-(void)getRewardsForCurrentMember:(NSString *)memberId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><GetRewardsForCurrentMember xmlns=\"http://tempuri.org/\"><MemberID>%@</MemberID></GetRewardsForCurrentMember></soap:Body></soap:Envelope>",memberId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/GetRewardsForCurrentMember" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                           objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                                             objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

/**
 *  Get Businesses Near Me
 *
 *  @param memberId Member Id
 *  @param block    Block Returning Success OR Failure
 */
-(void)getBusinessesNearMeByMemberId:(NSString *)memberId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><GetBusinessesNearMeByAddress xmlns=\"http://tempuri.org/\"><MemberID>%@</MemberID></GetBusinessesNearMeByAddress></soap:Body></soap:Envelope>",memberId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/GetBusinessesNearMeByAddress" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                           objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"MarketPlaceGetAllCategoriesResponse"]
                                             objectForKey:@"MarketPlaceGetAllCategoriesResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


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
-(void)getBBXDirectorySearchResultWithKeyword:(NSString *)keyword WithStateId:(NSString *)stateId WithCountryId:(NSString *)countryId WithLanguageId:(NSString *)languageId WithProductCategoryId:(NSString *)productCategoryId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><DirectorySearch xmlns=\"http://tempuri.org/\"><Keyword>%@</Keyword><StateID>%@</StateID><CountryID>%@</CountryID><LanguageID>%@</LanguageID><ProductCategoryID>%@</ProductCategoryID><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage><UserName>%@</UserName><Password>%@</Password></DirectorySearch></soap:Body></soap:Envelope>",@"",stateId,countryId,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"],productCategoryId,@"1",@"100",@"6220430160116252",@"8139"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/DirectorySearch" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"DirectorySearchResponse"]
                           objectForKey:@"DirectorySearchResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"DirectorySearchResponse"]
                                             objectForKey:@"DirectorySearchResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Directory Detail
 *
 *  @param directoryId Directory Id
 *  @param username    Username
 *  @param password    Password
 *  @param block       Block Returning Success OR Failure
 */
-(void)getDirectorySearchDetailWithDirectoryId:(NSString *)directoryId withUsername:(NSString *)username withPassword:(NSString *)password withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><DirectorySearchDetail xmlns=\"http://tempuri.org/\"><UserName>%@</UserName><Password>%@</Password><DirID>%@</DirID></DirectorySearchDetail></soap:Body></soap:Envelope>",username,password,directoryId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/DirectorySearchDetail" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"DirectorySearchResponse"]
                           objectForKey:@"DirectorySearchResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"DirectorySearchResponse"]
                                             objectForKey:@"DirectorySearchResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Get Product Category
 *
 *  @param countryId Country Id
 *  @param block     Block Returning Success OR Failure
 */
-(void)getProductCategoryByCountryId:(NSString *)countryId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><ProductCategoryByCountryID xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><LanguageID>%@</LanguageID></ProductCategoryByCountryID></soap:Body></soap:Envelope>",countryId,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/ProductCategoryByCountryID" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"ProductCategoryByCountryIDResponse"]
                           objectForKey:@"ProductCategoryByCountryIDResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"ProductCategoryByCountryIDResponse"]
                                             objectForKey:@"ProductCategoryByCountryIDResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Get Videos
 *
 *  @param countryId Country Id
 *  @param block     Block Returning Success OR Failure
 */
-(void)getVideosWithCountryId:(NSString *)countryId withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><GetVideos xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID></GetVideos></soap:Body></soap:Envelope>",countryId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/GetVideos" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"GetVideosResponse"]
                           objectForKey:@"GetVideosResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"GetVideosResponse"]
                                             objectForKey:@"GetVideosResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


#pragma mark - Investments
/**
 *  Get Investment All Categories
 *
 *  @param countryId  Country Id
 *  @param languageId Language Id
 *  @param block      Block Returning Success OR Failure
 */
-(void)getInvestmentAllCategoryWithCountryId:(NSString *)countryId withLanguageId:(NSString *)languageId withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><InvestmentGetAllCategory xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><LanguageID>%@</LanguageID></InvestmentGetAllCategory></soap:Body></soap:Envelope>",countryId,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/InvestmentGetAllCategory" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"InvestmentGetAllCategoryResponse"]
                           objectForKey:@"InvestmentGetAllCategoryResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"InvestmentGetAllCategoryResponse"]
                                             objectForKey:@"InvestmentGetAllCategoryResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


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
-(void)getInvestmentDetailWithUsername:(NSString *)username withPassword:(NSString *)password withInvestmentId:(NSString *)investmentId withCountryId:(NSString *)countryId withLanguageId:(NSString *)languageId withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><InvestmentDetail xmlns=\"http://tempuri.org/\"><UserName>%@</UserName><Password>%@</Password><InvestmentID>%@</InvestmentID><CountryID>%@</CountryID><LanguageID>%@</LanguageID></InvestmentDetail></soap:Body></soap:Envelope>",username,password,investmentId,countryId,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/InvestmentDetail" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"InvestmentDetailResponse"]
                           objectForKey:@"InvestmentDetailResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"InvestmentDetailResponse"]
                                             objectForKey:@"InvestmentDetailResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Get Price Min Investment
 *
 *  @param countryId Country Id
 *  @param block     Block Returning Success OR Failure
 */
-(void)getInvestmentPriceMinWithCountryId:(NSString *)countryId withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><InvestmentGetPriceMin xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID></InvestmentGetPriceMin></soap:Body></soap:Envelope>",countryId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/InvestmentGetPriceMin" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"InvestmentGetPriceMinResponse"]
                           objectForKey:@"InvestmentGetPriceMinResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"InvestmentGetPriceMinResponse"]
                                             objectForKey:@"InvestmentGetPriceMinResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Get Price Max Invesment
 *
 *  @param countryId Country Id
 *  @param block     Block Returning Success OR Failure
 */
-(void)getInvestmentPriceMaxWithCountryId:(NSString *)countryId withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><InvestmentGetPriceMax xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID></InvestmentGetPriceMax></soap:Body></soap:Envelope>",countryId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/InvestmentGetPriceMax" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"InvestmentGetPriceMaxResponse"]
                           objectForKey:@"InvestmentGetPriceMaxResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"InvestmentGetPriceMaxResponse"]
                                             objectForKey:@"InvestmentGetPriceMaxResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


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
-(void)getInvestmentSearchWithKeyword:(NSString *)keyword withPriceStart:(NSString *)startPrice withPriceEnd:(NSString *)endPrice withCategoryId:(NSString *)categoryId withLanguageId:(NSString *)languageId withCountryId:(NSString *)countryId withPageNumber:(NSString *)pageNumber withProductsCount:(NSString *)productsCount withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><InvestmentSearch xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID><CategoryID>%@</CategoryID><PriceStart>%@</PriceStart><PriceEnd>%@</PriceEnd><LanguageID>%@</LanguageID><Keyword>%@</Keyword><PageNumber>%@</PageNumber><NumberOfProductPerPage>%@</NumberOfProductPerPage></InvestmentSearch></soap:Body></soap:Envelope>",countryId,categoryId,startPrice,endPrice,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"],keyword,pageNumber,productsCount];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/InvestmentSearch" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"ProductCategoryByCountryIDResponse"]
                           objectForKey:@"ProductCategoryByCountryIDResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"ProductCategoryByCountryIDResponse"]
                                             objectForKey:@"ProductCategoryByCountryIDResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        block (NO, nil);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  About Us Text
 *
 *  @param sectionId  1 for About Us
 *  @param countryId  Country Id for Selected Country
 *  @param languageId Language Id for Selected Language
 *  @param block      Block Returning Success OR Failure
 */
- (void)getAboutUsTextWithSectionId:(NSString *)sectionId withCountryId:(NSString *)countryId withLanguageId:(NSString *)languageId withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><StaticSectionText xmlns=\"http://tempuri.org/\"><SectionID>%@</SectionID><CountryID>%@</CountryID><LanguageID>%@</LanguageID></StaticSectionText></soap:Body></soap:Envelope>",sectionId,countryId,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/StaticSectionText" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"StaticSectionTextResponse"]
                           objectForKey:@"StaticSectionTextResult"]);
            
            NSMutableDictionary * dict1 = [[[[dict objectForKey:@"soap:Envelope"]
                                             objectForKey:@"soap:Body"]
                                            objectForKey:@"StaticSectionTextResponse"]
                                           objectForKey:@"StaticSectionTextResult"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}

/**
 *  Get Labels
 *
 *  @param languageId Language Id
 *  @param block      Block Returning Success OR Failure
 */
- (void)getLabelsByLanguageId:(NSString *)languageId withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><LableByLanguageID xmlns=\"http://tempuri.org/\"><LanguageID>%@</LanguageID></LableByLanguageID></soap:Body></soap:Envelope>",[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/LableByLanguageID" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                           objectForKey:@"soap:Body"]
                          objectForKey:@"LableByLanguageIDResponse"]
                         objectForKey:@"LableByLanguageIDResult"]
                        objectForKey:@"diffgr:diffgram"]
                        objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                             objectForKey:@"soap:Body"]
                                            objectForKey:@"LableByLanguageIDResponse"]
                                           objectForKey:@"LableByLanguageIDResult"]
                                        objectForKey:@"diffgr:diffgram"]
                                    objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Pay Fee
 *
 *  @param creditCardNo     CC Number
 *  @param creditCardExpiry CC Expiry Date
 *  @param securityCode     CC Security Code
 *  @param amount           Payment Amount
 *  @param block            Block Returning Success OR Failure
 */
- (void)processPayFeeWithCreditCardNumber:(NSString *)creditCardNo withCreditCardExpiryDate:(NSString *)creditCardExpiry withCreditCardSecurityCode:(NSString *)securityCode withPaymentAmount:(NSString *)amount withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><ProcessPayFee xmlns=\"http://tempuri.org/\"><CreditCardNumber>%@</CreditCardNumber><CreditCardExpiryDate>%@</CreditCardExpiryDate><CreditCardSecurityCode>%@</CreditCardSecurityCode><PaymentAmount>%@</PaymentAmount></ProcessPayFee></soap:Body></soap:Envelope>",creditCardNo,creditCardExpiry,securityCode,amount];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/ProcessPayFee" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"ProcessPayFeeResponse"]
                           objectForKey:@"ProcessPayFeeResult"]);
            
            NSMutableDictionary * dict1 = [[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"ProcessPayFeeResponse"]
                                             objectForKey:@"ProcessPayFeeResult"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}

/**
 *  Last Update
 *
 *  @param block Block Returning Success OR Failure
 */
-(void)getLastUpdateWithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><LastUpdate xmlns=\"http://tempuri.org/\"></LastUpdate></soap:Body></soap:Envelope>"];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/LastUpdate" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"LableByLanguageIDResponse"]
                           objectForKey:@"LableByLanguageIDResult"]
                          objectForKey:@"diffgr:diffgram"]
                         objectForKey:@"NewDataSet"]);
            
            NSMutableDictionary * dict1 = [[[[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"LableByLanguageIDResponse"]
                                             objectForKey:@"LableByLanguageIDResult"]
                                            objectForKey:@"diffgr:diffgram"]
                                           objectForKey:@"NewDataSet"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Language By Country
 *
 *  @param countryId Country Id
 *  @param block     Block Returning Success OR Failure
 */
-(void)getLanguageIdByCountryIdWithCountryId:(NSString *)countryId withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><LanguageIDByCountryID xmlns=\"http://tempuri.org/\"><CountryID>%@</CountryID></LanguageIDByCountryID></soap:Body></soap:Envelope>",countryId];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/LanguageIDByCountryID" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"LanguageIDByCountryIDResponse"]
                           objectForKey:@"LanguageIDByCountryIDResult"]);
            
            NSMutableDictionary * dict1 = [[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"LanguageIDByCountryIDResponse"]
                                             objectForKey:@"LanguageIDByCountryIDResult"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


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
-(void)contactYourAccountManagerWithUsername:(NSString *)username withPassword:(NSString *)password withINeed:(NSString *)iNeedText withHowOften:(NSString *)howOftenText withInquiryText:(NSString *)inquiryText withPoSupName:(NSString *)poSupName withPoSupAddress:(NSString *)poSupAddress withPoSupPhone:(NSString *)poSupPhone withLanguageId:(NSString *)languageId withCountryId:(NSString *)countryId withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><ContactYourAccountManager xmlns=\"http://tempuri.org/\"><Username>%@</Username><Password>%@</Password><INeed>%@</INeed><HowOften>%@</HowOften><InquiryText>%@</InquiryText><PoSupName>%@</PoSupName><PoSupAddress>%@</PoSupAddress><PoSupPhone>%@</PoSupPhone><LanguageID>%@</LanguageID><CountryID>%@</CountryID></ContactYourAccountManager></soap:Body></soap:Envelope>",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"],[[NSUserDefaults standardUserDefaults]objectForKey:@"PIN"],iNeedText,howOftenText,inquiryText,poSupName,poSupAddress,poSupPhone,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"],[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/ContactYourAccountManager" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[dict objectForKey:@"soap:Envelope"]
                           objectForKey:@"soap:Body"]
                          objectForKey:@"ContactYourAccountManagerResponse"]
                         objectForKey:@"ContactYourAccountManagerResult"]);
            
            NSMutableDictionary * dict1 = [[[[dict objectForKey:@"soap:Envelope"]
                                             objectForKey:@"soap:Body"]
                                            objectForKey:@"ContactYourAccountManagerResponse"]
                                           objectForKey:@"ContactYourAccountManagerResult"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


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
-(void)joinBBXWithCompanyName:(NSString *)companyName withBusinessAddress:(NSString *)businessAddress withPostCodeState:(NSString *)postCode withPhone:(NSString *)phone withEmail:(NSString *)email withWebsite:(NSString *)website withOwnerName:(NSString *)ownerName withComments:(NSString *)comments withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><Join xmlns=\"http://tempuri.org/\"><CompanyName>%@</CompanyName><BusinessAddress>%@</BusinessAddress><SuburbPostCodeState>%@</SuburbPostCodeState><Phone>%@</Phone><Email>%@</Email><Website>%@</Website><OwnerName>%@</OwnerName><Comments>%@</Comments><CountryID>%@</CountryID><LanguageID>%@</LanguageID></Join></soap:Body></soap:Envelope>",companyName,businessAddress,postCode,phone,email,website,ownerName,comments,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"],[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/Join" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"JoinResponse"]
                           objectForKey:@"JoinResult"]);
            
            NSMutableDictionary * dict1 = [[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"JoinResponse"]
                                             objectForKey:@"JoinResult"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Invite By Email
 *
 *  @param emails  Comma Separated Emails
 *  @param subject Mail Subject
 *  @param body    Mail Body
 *  @param block   Block Returning Success OR Failure
 */
-(void)inviteFriendByEmailWithEmails:(NSString *)emails withSubject:(NSString *)subject withBody:(NSString *)body withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><InviteEmail xmlns=\"http://tempuri.org/\"><Username>%@</Username><Password>%@</Password><Email1>%@</Email1><Subject>%@</Subject><Body>%@</Body><CountryID>%@</CountryID><LanguageID>%@</LanguageID></InviteEmail></soap:Body></soap:Envelope>",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"],[[NSUserDefaults standardUserDefaults]objectForKey:@"PIN"],emails,subject,body,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"],[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/InviteEmail" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"InviteEmailResponse"]
                           objectForKey:@"InviteEmailResult"]);
            
            NSMutableDictionary * dict1 = [[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"InviteEmailResponse"]
                                             objectForKey:@"InviteEmailResult"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/**
 *  Invite By SMS
 *
 *  @param numbers Numbers to be sent SMS to
 *  @param body    SMS Body
 *  @param block   Block Returning Success OR Failure
 */
-(void)inviteFriendBySMSWithNumbers:(NSString *)numbers withBody:(NSString *)body withCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString *soapMsg =	[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body><InviteSMS xmlns=\"http://tempuri.org/\"><Username>%@</Username><Password>%@</Password><SMS1>%@</SMS1><Body>%@</Body><CountryID>%@</CountryID><LanguageID>%@</LanguageID></InviteSMS></soap:Body></soap:Envelope>",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"],[[NSUserDefaults standardUserDefaults]objectForKey:@"PIN"],numbers,body,[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"],[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSURL * url = [NSURL URLWithString:@"http://ebbx.com/webservices/bbxmobileapp.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //—-set the various headers—-
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/InviteSMS" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"ebbx.com" forHTTPHeaderField:@"Host"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
	//—-set the HTTP method and body—-
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            
            NSError * error;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
            NSLog(@"JSON:%@",dict);
            NSLog(@"%@",[[[[dict objectForKey:@"soap:Envelope"]
                             objectForKey:@"soap:Body"]
                            objectForKey:@"InviteSMSResponse"]
                           objectForKey:@"InviteSMSResult"]);
            
            NSMutableDictionary * dict1 = [[[[dict objectForKey:@"soap:Envelope"]
                                               objectForKey:@"soap:Body"]
                                              objectForKey:@"InviteSMSResponse"]
                                             objectForKey:@"InviteSMSResult"];
            
            block (YES, dict1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}

@end
