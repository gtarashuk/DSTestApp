//
//  OllTvDemo.m
//  DS Test App
//
//  Created by Grigory Tarashuk on 3/23/17.
//  Copyright © 2017 Test Name. All rights reserved.
//

#import "OllTvDemo.h"
#import <UIKit/UIKit.h>


NSString *const OLL_SERVER_URL = @"http://oll.tv/demo";


@implementation OllTvDemo

-(id)init{
    if (self == [super init]){
    }
    return self;
}

- (void)getTVProgramsFromBorderId:(NSString *)borderId andDirection:(NSString *)direction block:(void (^)(id))block{
    
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *uuId = [[device identifierForVendor]UUIDString];
    
    NSString *urlString =  [NSString stringWithFormat:@"%@?serial_number=%@&borderId=%@&direction=%@", OLL_SERVER_URL, uuId, borderId,direction ];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    request.HTTPMethod = @"GET";
    
    NSLog(@"%@", request);
    
    NSURLSessionDataTask *dataTsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error){
            NSError *errorJson;
        NSMutableDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorJson];
            
            block(resultDictionary);
        }else{
            NSLog(@"%@",error);
            block(nil);
        }
    }];
    
    [dataTsk resume];
    
    
}

@end
