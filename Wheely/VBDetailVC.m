//
//  DetailViewController.m
//  Wheely
//
//  Created by Viktor Bespalov on 31/07/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import "VBDetailVC.h"


@interface VBDetailVC ()
- (void)configureView;
@end

@implementation VBDetailVC

#pragma mark - Managing the detail item

- (void)setDetailItem:(VBWheelyData *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        VBWheelyData* wheelyData = self.detailItem;
        
        self.navigationItem.title = _titleLabel.text = wheelyData.title;
        _textLabel.text = wheelyData.text;
        _textLabel.contentMode = UIViewContentModeTop;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
