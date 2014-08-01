//
//  MasterViewController.m
//  Wheely
//
//  Created by Viktor Bespalov on 31/07/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import "MasterViewController.h"
#import "MasterTableViewCell.h"
#import "DetailViewController.h"

@interface MasterViewController () {

}

@property (nonatomic, strong) NSArray *sourceData;
@property (nonatomic, strong) MasterTableViewCell *prototypeCell;
@end

static NSString *CellIdentifier = @"Cell";

@implementation MasterViewController

#pragma mark  Accessors

- (NSArray *)sourceData
{
    if (!isNetworkActivityVisible) {
            [self networkActivity:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [appDelegate.manager getWheelyData:^(NSArray *array) {
                    [self networkActivity:NO];
                    _sourceData = array;
                    [self.tableView reloadData];

                    NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
                    [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }failBlock:^(NSException* exception){
                    [self alertException:exception];
                }];
            });
    }
    return _sourceData;
}

- (MasterTableViewCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    return _prototypeCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sourceData = [self sourceData];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(sourceData)];
    self.navigationItem.rightBarButtonItem = addButton;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:30.0f
                                     target:self
                                   selector:@selector(sourceData)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MasterTableViewCell class]])
    {
        MasterTableViewCell *textCell = (MasterTableViewCell *)cell;
        WheelyData* wheelyData = [_sourceData objectAtIndex:indexPath.row];
        
        textCell.header.text = wheelyData.title;
        textCell.header.font = [UIFont systemFontOfSize:16];
        textCell.detail.text = wheelyData.text;
        textCell.detail.textColor = [UIColor grayColor];
        textCell.detail.font = [UIFont systemFontOfSize:14];
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _sourceData[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
