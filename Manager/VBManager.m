//
//  Manager.m
//  Wheely
//
//  Created by Viktor Bespalov on 31/07/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import "VBManager.h"
#import "AFNetworking.h"
#import "VBWheelyDataFactory.h"

NSString* const urlString = @"http://crazy-dev.wheely.com";

@implementation VBManager

- (void)getWheelyData:(void (^) (NSArray* array)) block
            failBlock:(void (^) (NSException *exception)) blockException
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        if (!error) {
            NSArray *dealsArray = [EKMapper arrayOfObjectsFromExternalRepresentation:(NSArray *)json withMapping:[VBWheelyDataFactory wheelyFactory]];
            block(dealsArray);
        }
        else {
            NSException *exception = [[NSException alloc] initWithName:@"Что то пошло не так"
                                                                reason:@"Ошибка сериализации данных"
                                                              userInfo:nil];
            blockException(exception);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSException *exception = [[NSException alloc] initWithName:@"Что то пошло не так"
                                                            reason:@"Ошибка получения данных"
                                                          userInfo:nil];
        blockException(exception);
    }];
    [operation start];
}

@end
