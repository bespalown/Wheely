//
//  Master.m
//  Wheely
//
//  Created by Viktor Bespalov on 01/08/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import "Master.h"

@interface Master ()

@end

@implementation Master

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
}

-(void)alertException:(NSException*)exception
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:exception.name message:exception.reason delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
    [alert show];
    [self networkActivity:NO];
}

-(void)networkActivity:(BOOL)activity
{
    isNetworkActivityVisible = activity;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = activity;
    if (activity)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    else
        [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
