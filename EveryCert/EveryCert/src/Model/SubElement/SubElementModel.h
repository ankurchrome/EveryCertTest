//
//  SubElementModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 01/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ElementModel.h"

@interface SubElementModel : ElementModel

@property (assign, nonatomic) NSInteger subElementId;

@property (assign, nonatomic) BOOL isCollapsed;

@end