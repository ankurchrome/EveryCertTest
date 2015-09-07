//
//  PickListViewController.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 03/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "PickListViewController.h"
#import "PickListElementCell.h"

#define PICK_LIST_CELL_HEIGHT 40.0f

@interface PickListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UIButton *_doneButton;
    __weak IBOutlet UITableView *_tableView;
    
    NSArray *_optionList;
    NSMutableArray *_selectedOptionList;
}
@end

@implementation PickListViewController

static NSString *const PickListCellReuseIdentifier = @"PickListCellIdentifier";
NSString *const PickListCellNibName = @"PickListTableViewCell";

#pragma mark - Initialisation Methods

// Initialize an PickListViewController object with options to be selected from the given all options
- (id)initWithSelectedOptions:(NSArray *)selectedOptions allOptions:(NSArray *)allOptions
{
    self = [super init];
    
    if (self)
    {
        _optionList = allOptions;
        
        if(!_selectedOptionList)
        {
            _selectedOptionList = [NSMutableArray new];
        }
        
        [_selectedOptionList removeAllObjects];
        [_selectedOptionList addObjectsFromArray:selectedOptions];
    }
    
    return self;
}

#pragma mark - ViewLifeCycle Methods

- (void)viewDidLoad
{
    FUNCTION_START;
    
    [super viewDidLoad];
    
    [_tableView registerClass:[PickListElementCell class] forCellReuseIdentifier:PickListCellReuseIdentifier];
    
    UINib *pickListCellNib = [UINib nibWithNibName:PickListCellNibName
                                            bundle:[NSBundle mainBundle]];
    [_tableView registerNib:pickListCellNib
     forCellReuseIdentifier:PickListCellReuseIdentifier];

    [_tableView reloadData];
    
    FUNCTION_END;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBOutlet Methods

- (IBAction)doneButtonTapped:(id)sender
{
    FUNCTION_START;
    
    if ([self.delegate respondsToSelector:@selector(pickListViewController:didSelectOptions:)])
    {
        [self.delegate pickListViewController:self didSelectOptions:_selectedOptionList];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    FUNCTION_END;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _optionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PickListElementCell *pickListCell = nil;
    
    pickListCell = (PickListElementCell *)[tableView dequeueReusableCellWithIdentifier:PickListCellReuseIdentifier forIndexPath:indexPath];
    
    NSString *option = nil;
    
    if (_optionList && indexPath.row < _optionList.count)
    {
        option = [_optionList objectAtIndex:indexPath.row];
    }
    
    if (pickListCell)
    {
        pickListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //TODO: Change Comment
//        pickListCell.checkMarkImageView.hidden = YES;
        pickListCell.titleLabel.text = option;
        pickListCell.titleLabel.textColor = [UIColor blackColor];
        
//        if ([_selectedOptionList containsObject:option])
//        {
//            pickListCell.checkMarkImageView.hidden = NO;
//        }
    }
    
    return pickListCell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = PICK_LIST_CELL_HEIGHT;
    
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUNCTION_START;
    
    PickListElementCell *pickListCell = (PickListElementCell *)[tableView cellForRowAtIndexPath:indexPath];

    if (!_selectedOptionList)
    {
        _selectedOptionList = [NSMutableArray new];
    }
    
    if (_optionList && indexPath.row < _optionList.count)
    {
        NSString *option = [_optionList objectAtIndex:indexPath.row];
        
        if ([_selectedOptionList containsObject:option])
        {
            [_selectedOptionList removeObject:option];
            pickListCell.titleLabel.textColor = [UIColor blackColor];
//            pickListCell.checkMarkImageView.hidden = YES;
        }
        else
        {
            [_selectedOptionList addObject:option];
//            pickListCell.checkMarkImageView.hidden = NO;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

@end
