//
//  SettingViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SettingViewController.h"
#import "ElementTableViewCell.h"
#import "ElementModel.h"
#import "FormSectionHandler.h"
#import "ElementHandler.h"

@interface SettingViewController ()
{
    NSArray *_sectionModelArray;
    __weak IBOutlet UITableView *_settingTableView;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ElementHandler *elementHandler = [ElementHandler new];
    _elementModelList = (NSMutableArray *)[elementHandler allElementsOfFormId:0]; // Fetch All ELments that is Related to Form Id of Setting Table
    
    [_settingTableView registerNib:[UINib nibWithNibName:@"TextFieldElementCell" bundle:nil] forCellReuseIdentifier:TextFieldReuseIdentifier];
    [_settingTableView registerNib:[UINib nibWithNibName:@"TextViewElementCell" bundle:nil] forCellReuseIdentifier:TextViewReuseIdentifier];
    [_settingTableView registerNib:[UINib nibWithNibName:@"TextLabelElementCell" bundle:nil] forCellReuseIdentifier:TextLabelReuseIdentifier];
    [_settingTableView registerNib:[UINib nibWithNibName:@"SubElementCell" bundle:nil] forCellReuseIdentifier:SubElementsReuseIdentifier];
    [_settingTableView registerNib:[UINib nibWithNibName:@"TickBoxElementCell" bundle:nil] forCellReuseIdentifier:TickBoxReuseIdentifier];
    [_settingTableView registerNib:[UINib nibWithNibName:@"RadioButtonElementCell" bundle:nil] forCellReuseIdentifier:RadioButtonsReuseIdentifier];
    [_settingTableView registerNib:[UINib nibWithNibName:@"SignatureElementCell" bundle:nil] forCellReuseIdentifier:SignatureViewReuseIdentifier];
    [_settingTableView registerNib:[UINib nibWithNibName:@"LookupElementCell" bundle:nil] forCellReuseIdentifier:LookUpReuseIdentifier];
    _settingTableView.estimatedRowHeight = 68;
    _settingTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)onClickHomeBarButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _elementModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [NSString new];
    
    ElementModel *elementModel = _elementModelList[indexPath.row];
    reuseIdentifier = EMPTY_STRING;
    
    switch (elementModel.fieldType) {
        case ElementTypeTextField:
        {
            reuseIdentifier = TextFieldReuseIdentifier;
        }
            break;
            
        case ElementTypeTextView:
        {
            reuseIdentifier =TextViewReuseIdentifier;
        }
            break;
            
        case ElementTypeTextLabel:
        {
            reuseIdentifier = TextLabelReuseIdentifier;
        }
            break;
            
        case ElementTypeSubElements:
        {
            reuseIdentifier = SubElementsReuseIdentifier;
        }
            break;
            
        case ElementTypeTickBox:
        {
            reuseIdentifier = TickBoxReuseIdentifier;
        }
            break;
            
        case ElementTypeRadioButton:
        {
            reuseIdentifier = RadioButtonsReuseIdentifier;
        }
            break;
            
        case ElementTypeSignature:
        {
            reuseIdentifier = SignatureViewReuseIdentifier;
        }
            break;
            
        case ElementTypeLookup:
        {
            reuseIdentifier = LookUpReuseIdentifier;
        }
            break;
            
        default:
        {
            reuseIdentifier = TextLabelReuseIdentifier;
        }
            break;
    }
    
    ElementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [ElementTableViewCell new];
    }
    
    cell = [cell initWithModel:_elementModelList[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end