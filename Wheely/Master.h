//
//  Master.h
//  Wheely
//
//  Created by Viktor Bespalov on 01/08/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "WheelyData.h"

@interface Master : UITableViewController
{
    AppDelegate* appDelegate;
    BOOL isNetworkActivityVisible;
}

-(void)alertException:(NSException*)exception;
-(void)networkActivity:(BOOL)activity;

@end
