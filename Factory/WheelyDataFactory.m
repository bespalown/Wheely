//
//  WheelyDataFactory.m
//  Wheely
//
//  Created by Viktor Bespalov on 31/07/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import "WheelyDataFactory.h"

@implementation WheelyDataFactory

+ (EKObjectMapping*) wheelyFactory;
{
    return [EKObjectMapping mappingForClass:[WheelyData class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"id",
                                      @"title",
                                      @"text"]];
    }];
}

@end
