//
//  SettingViewController.m
//  EveryCert
//
//  Created by Ankur Pachauri on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SettingViewController.h"
#import "ElementTableView.h"
#import "SubElementModel.h"
#import "ElementHandler.h"
#import "CompanyUserHandler.h"
#import "DataBinaryHandler.h"

@interface SettingViewController ()
{
    IBOutlet ElementTableView *_settingElementTableView;

    NSArray *_settingElements;
    
    CompanyUserHandler *_companyUserHandler;
    DataBinaryHandler  *_dataBinaryHandler;
}
@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_BG_COLOR;

    ElementHandler *elementHandler = [ElementHandler new];
    _settingElements = [elementHandler getSettingElementsOfCompany:APP_DELEGATE.loggedUserCompanyId];
    
    _settingElementTableView.superview.clipsToBounds = NO;
    _settingElementTableView.superview.layer.masksToBounds = NO;
    _settingElementTableView.superview.layer.shadowColor = [[UIColor blackColor] CGColor];
    _settingElementTableView.superview.layer.shadowOffset = CGSizeMake(0,5);
    _settingElementTableView.superview.layer.shadowOpacity = 0.5;
    
    [_settingElementTableView reloadWithElements:_settingElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)saveButtonTapped:(id)sender
{
    [self saveAllElements:_settingElements];
}

//Save the data for all given elements
- (void)saveAllElements:(NSArray *)elements
{
    for (ElementModel *elementModel in elements)
    {
        switch (elementModel.fieldType)
        {
            case ElementTypeTextField:
            case ElementTypeTextView:
            case ElementTypePickListOption:
            case ElementTypeRadioButton:
            {
                [self saveElementData:elementModel];
            }
                break;
                
            case ElementTypeSubElement:
            {
                //Create JSON content for Sub element's content
                NSString *subElementContent = nil;
                NSString *subElementKey     = nil;
                NSData   *subElementData    = nil;
                
                NSMutableDictionary *subElementInfo = [NSMutableDictionary new];
                
                for (SubElementModel *subElementModel in elementModel.subElements)
                {
                    if (subElementModel.dataValue)
                    {
                        subElementKey = @(subElementModel.subElementId).stringValue;
                        [subElementInfo setObject:subElementModel.dataValue forKey:subElementKey];
                    }
                }
                
                if (subElementInfo.count <= 0)
                {
                    continue;
                }
                
                subElementData = [NSJSONSerialization dataWithJSONObject:subElementInfo options:0 error:nil];
                subElementContent = [[NSString alloc] initWithData:subElementData encoding:NSUTF8StringEncoding];
                elementModel.dataValue = subElementContent;
                
                [self saveElementData:elementModel];
            }
                break;
                
            case ElementTypeSignature:
            {
                [self saveElementDataBinary:elementModel];
            }
                break;
                
            default:
                break;
        }
    }
}

//Save element's text content to the database
- (BOOL)saveElementData:(ElementModel *)elementModel
{
    FUNCTION_START;
    
    BOOL isSaved = false;
    
    if (!_companyUserHandler)
    {
        _companyUserHandler = [CompanyUserHandler new];
    }
    
    if (elementModel.companyUserIdApp > 0)
    {
        NSDictionary *columnInfo = @{
                                     CompanyUserData: elementModel.dataValue,
                                     ModifiedTimestampApp: @([[NSDate date] timeIntervalSince1970]),
                                     IsDirty: @(true)
                                     };
        
        isSaved = [_companyUserHandler updateInfo:columnInfo
                                      recordIdApp:elementModel.companyUserIdApp];
    }
    else
    {
        if (![CommonUtils isValidString:elementModel.dataValue])
        {
            return isSaved;
        }
        
        CompanyUserModel *companyUser = [CompanyUserModel new];
        companyUser.companyId = APP_DELEGATE.loggedUserCompanyId;
        companyUser.userId    = APP_DELEGATE.loggedUserId;
        companyUser.fieldName = elementModel.fieldName;
        companyUser.data      = elementModel.dataValue;
        
        isSaved = [_companyUserHandler insertCompanyUser:companyUser];
    }
    
    FUNCTION_END;
    return isSaved;
}

//Save element's binary content to the database
- (BOOL)saveElementDataBinary:(ElementModel *)elementModel
{
    FUNCTION_START;
    
    BOOL isSaved = false;
    
    if (!_dataBinaryHandler)
    {
        _dataBinaryHandler = [DataBinaryHandler new];
    }
    
    if (elementModel.dataBinaryIdApp > 0)
    {
        NSDictionary *columnInfo = @{
                                     DataBinaryValue: elementModel.dataBinaryValue,
                                     ModifiedTimestampApp: @([[NSDate date] timeIntervalSince1970]),
                                     IsDirty: @(true)
                                     };
        
        isSaved = [_companyUserHandler updateInfo:columnInfo
                                      recordIdApp:elementModel.dataBinaryIdApp];
    }
    else
    {
        if (![CommonUtils isValidObject:elementModel.dataBinaryValue])
        {
            return isSaved;
        }
        
        DataBinaryModel *dataBinaryModel = [DataBinaryModel new];
        dataBinaryModel.companyId  = APP_DELEGATE.loggedUserCompanyId;
        dataBinaryModel.elementId  = elementModel.elementId;
        dataBinaryModel.dataBinary = elementModel.dataBinaryValue;
        
        isSaved = [_dataBinaryHandler insertDataBinaryModel:dataBinaryModel];
    }
    
    FUNCTION_END;
    return isSaved;
}

@end