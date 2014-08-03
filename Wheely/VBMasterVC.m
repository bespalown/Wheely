//
//  MasterViewController.m
//  Wheely
//
//  Created by Viktor Bespalov on 31/07/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import "VBMasterVC.h"
#import "VBMasterTableViewCell.h"
#import "VBDetailVC.h"

@interface VBMasterVC () {
    NSMutableArray* sourceDataArray;
}

@property (nonatomic, strong) VBMasterTableViewCell *vbMasterTableViewCell;
@end

static NSString *CellIdentifier = @"Cell";

@implementation VBMasterVC

#pragma mark  Accessors

- (void)sourceData
{
    if (!isNetworkActivityVisible) {
        [self networkActivity:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [appDelegate.vbManager getWheelyData:^(NSArray *newArray) {
                [self networkActivity:NO];
                [self updateTableFromArray:newArray];
            }failBlock:^(NSException* exception){
                [self alertException:exception];
            }];
        });
    }
}

-(void)updateTableFromArray:(NSArray *)newArray
{
    NSArray *sourceIdsArray = [self returnIdsArrayFromOriginArray:sourceDataArray];
    NSArray *newIdsArray = [self returnIdsArrayFromOriginArray:newArray];
    
    NSMutableArray *deleteIndexPaths = [NSMutableArray new];
    NSMutableArray *insertIndexPaths = [NSMutableArray new];
    NSMutableArray *reloadIndexPaths = [NSMutableArray new];
    
    //поиск по новому массиву
    for (int i = 0; i < newIdsArray.count; i++) {
        if (![sourceIdsArray containsObject:newIdsArray[i]]) {
            //в новом массиве %d элемент новый, добавим его в старый массив
            [insertIndexPaths addObject:[NSIndexPath indexPathForRow:sourceDataArray.count inSection:0]];
            
            VBWheelyData* vbWheelyData = newArray[i];
            [sourceDataArray addObject:vbWheelyData];
        }
    }
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //поиск по старому массиву
    NSMutableIndexSet *deleteIndexSet = [NSMutableIndexSet new];
    for (int i = 0; i < sourceIdsArray.count; i++) {
        if ([newIdsArray containsObject:sourceIdsArray[i]]) {
            //в новом массиве %d элемент есть, перезаписал новыми данными
            [reloadIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            
            NSUInteger index = [newIdsArray indexOfObject:sourceIdsArray[i]];
            VBWheelyData* vbWheelyData = [newArray objectAtIndex:index];
            
            [sourceDataArray replaceObjectAtIndex:i withObject:vbWheelyData];
        }
        else {
            //в новом массиве %d элемента нету, удаляем этот элемент из таблицы и из старого массива
            [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            [deleteIndexSet addIndex:i];
        }
    }
    
    [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [sourceDataArray removeObjectsAtIndexes:deleteIndexSet];
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(NSArray *)returnIdsArrayFromOriginArray:(NSArray *)originArray
{
    NSMutableArray *mut = [NSMutableArray new];
    for (VBWheelyData* vbWheelyData in originArray) {
        [mut addObject:[NSNumber numberWithUnsignedInteger:vbWheelyData.id]];
    }
    return mut;
}

- (VBMasterTableViewCell *)vbMasterTableViewCell
{
    if (!_vbMasterTableViewCell)
    {
        _vbMasterTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    return _vbMasterTableViewCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sourceDataArray = [NSMutableArray new];
    [self sourceData];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(sourceData)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0f
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
    return sourceDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[VBMasterTableViewCell class]])
    {
        VBMasterTableViewCell *textCell = (VBMasterTableViewCell *)cell;
        VBWheelyData* wheelyData = [sourceDataArray objectAtIndex:indexPath.row];
        
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
    [self configureCell:self.vbMasterTableViewCell forRowAtIndexPath:indexPath];

    self.vbMasterTableViewCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.vbMasterTableViewCell.bounds));
    [self.vbMasterTableViewCell layoutIfNeeded];
    
    CGSize size = [self.vbMasterTableViewCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
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
        VBWheelyData* wheelyData = sourceDataArray[indexPath.row];
        [[segue destinationViewController] setDetailItem:wheelyData];
    }
}

@end
