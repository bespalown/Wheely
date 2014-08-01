//
//  Manager.m
//  Wheely
//
//  Created by Viktor Bespalov on 31/07/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import "Manager.h"
#import "AFNetworking.h"
#import "WheelyDataFactory.h"

NSString* const urlString = @"http://crazy-dev.wheely.com";

@implementation Manager

- (void)getWheelyData:(void (^) (NSArray* array)) block
            failBlock:(void (^) (NSException *exception)) blockException
{
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:15];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
         {
             
         }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
         {
             if (response.statusCode == 200)
             {
                 NSArray *dealsArray = [EKMapper arrayOfObjectsFromExternalRepresentation:JSON withMapping:[WheelyDataFactory wheelyFactory]];
                 block(dealsArray);
             }
             else {
                 NSException *exception = [[NSException alloc] initWithName:@"Что то пошло не так"
                                                                     reason:@"Ошибка получения данных"
                                                                   userInfo:nil];
                 blockException(exception);
             }

         }];
    [operation start];
}

@end
