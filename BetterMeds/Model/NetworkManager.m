//
//  NetworkManager.m
//  BetterMeds
//
//  Created by Vinay Jain on 5/14/15.
//  Copyright (c) 2015 Vinay Jain. All rights reserved.
//

#import "NetworkManager.h"

#define BaseURL @"http://www.truemd.in/api/"
#define API_KEY @"fab7267c813d0fe819437deef957ac"

@interface NetworkManager (){
    
    NSString *baseURL;
    
}

@property (strong,nonatomic) NSURLSession *session;

@end

@implementation NetworkManager

-(NSURLSession *)session{
    if (!_session) {
        _session = [NSURLSession sharedSession];
    }
    return _session;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id _sharedInstance = nil;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        baseURL =  BaseURL;
    }
    return self;
}

-(void)getMedicineDetailsForID:(NSString *)ID{
    
    NSString *pathComponent = [NSString stringWithFormat:@"medicine_details/?key=%@&id=%@",API_KEY,ID];
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",baseURL,pathComponent];
    
    NSURL *requestURL = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",requestURL);
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:requestURL  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        [self.delegate updateDataSourceWith:@{}];
        
    }];
    
    [dataTask resume];
}

-(void)getMedicineSuggestionsForID:(NSString *)ID{
    
    NSString *pathComponent = [NSString stringWithFormat:@"medicine_suggestions/?key=%@&id=%@&limit=20",API_KEY,ID];
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",baseURL,pathComponent];
    
    NSURL *requestURL = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",requestURL);
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:requestURL  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        [self.delegate updateDataSourceWith:[dict valueForKeyPath:@"response.suggestions"]];
        
    }];
    
    [dataTask resume];
}

@end