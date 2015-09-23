//
//  UIView+Extension.h
//  Volunteer
//
//  Created by Ankur Pachauri on 16/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

#pragma mark - Setters

//Make a rect with given width and take rest of values from reciever then assign the rect to receiver.
- (void)setFrameWidth:(CGFloat)width;

//Make a rect with given height and take rest of values from reciever then assign the rect to receiver
- (void)setFrameHeight:(CGFloat)height;

//Make a rect with given x origin and take rest of values from reciever then assign the rect to receiver.
- (void)setFrameX:(CGFloat)x;

//Make a rect with given y origin and take rest of values from reciever then assign the rect to receiver.
- (void)setFrameY:(CGFloat)y;

//Make a rect with given (x,y) origin and take rest of values from reciever then assign the rect to receiver.
- (void)setFrameOrigin:(CGPoint)point;

//Make a rect with given (width,height) size and take rest of values from reciever then assign the rect to receiver.
- (void)setFrameSize:(CGSize)size;

//add the width to the receiver's frame
- (void)addFrameWidth:(CGFloat)width;

//add the height to the receiver's frame
- (void)addFrameHeight:(CGFloat)height;

//Increase x origin to the receiver's frame
- (void)increaseFrameX:(CGFloat)x;

//Increase y origin to the receiver's frame
- (void)increaseFrameY:(CGFloat)y;

#pragma mark - Getters

//Returns the receiver's frame width
- (CGFloat)frameWidth;

//Returns the receiver's frame height
- (CGFloat)frameHeight;

//Returns the receiver's frame x origin
- (CGFloat)frameX;

//Returns the receiver's frame y origin
- (CGFloat)frameY;

#pragma mark - Other Methods

//Removes all the subviews of receiver
- (void)removeAllSubviews;

//Remove the specified subview of receiver
- (void)removeSubview:(id)subview;

@end
