//
//  Manager.h
//  Wheely
//
//  Created by Viktor Bespalov on 31/07/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manager : NSObject

- (void)getWheelyData:(void (^) (NSArray* array)) block
            failBlock:(void (^) (NSException *exception)) blockException;

@end
