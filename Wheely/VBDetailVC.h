//
//  DetailViewController.h
//  Wheely
//
//  Created by Viktor Bespalov on 31/07/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBWheelyData.h"

@interface VBDetailVC : UIViewController

@property (strong, nonatomic) VBWheelyData *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
