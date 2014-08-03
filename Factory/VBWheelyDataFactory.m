//
//  WheelyDataFactory.m
//  Wheely
//
//  Created by Viktor Bespalov on 31/07/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import "VBWheelyDataFactory.h"

@implementation VBWheelyDataFactory

+ (EKObjectMapping*) wheelyFactory;
{
    return [EKObjectMapping mappingForClass:[VBWheelyData class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"id",
                                      @"title",
                                      @"text"]];
    }];
}

@end
