//
//  OllTvDemo.h
//  DS Test App
//
//  Created by Grigory Tarashuk on 3/23/17.
//  Copyright © 2017 Test Name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OllTvDemo : NSObject

- (void)getTVProgramsFromBorderId:(NSString *)borderId andDirection:(NSString *)direction block:(void (^)(id))block;

@end
