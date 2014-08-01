//
//  MasterTableViewCell.h
//  Wheely
//
//  Created by Viktor Bespalov on 31/07/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end
