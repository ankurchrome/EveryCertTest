//
//  UIView+Extension.m
//  Volunteer
//
//  Created by Ankur Pachauri on 16/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

#pragma mark - Setters

/**
 Make a rect with given width and take rest of values from reciever then assign the rect to receiver.
 @param  CGFloat width
 @return void
 */
- (void)setFrameWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            width,
                            self.frame.size.height);
}

/**
 Make a rect with given height and take rest of values from reciever then assign the rect to receiver.
 @param  CGFloat height
 @return void
 */
- (void)setFrameHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            height);
}

/**
 Make a rect with given x origin and take rest of values from reciever then assign the rect to receiver.
 @param  CGFloat x origin
 @return void
 */
- (void)setFrameX:(CGFloat)x
{
    self.frame = CGRectMake(x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.frame.size.height);
}

/**
 Make a rect with given y origin and take rest of values from reciever then assign the rect to receiver.
 @param  CGFloat y origin
 @return void
 */
- (void)setFrameY:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x,
                            y,
                            self.frame.size.width,
                            self.frame.size.height);
}

/**
 Make a rect with given (x,y) origin and take rest of values from reciever then assign the rect to receiver.
 @param  CGFloat (x,y) origin
 @return void
 */
- (void)setFrameOrigin:(CGPoint)point
{
    self.frame = CGRectMake(point.x,
                            point.y,
                            self.frame.size.width,
                            self.frame.size.height);
}

/**
 Make a rect with given (width,height) size and take rest of values from reciever then assign the rect to receiver.
 @param  CGFloat (width,height) size
 @return void
 */
- (void)setFrameSize:(CGSize)size
{
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            size.width,
                            size.height);
}

/**
 add the width to the receiver's frame
 @param  CGFloat width
 @return void
 */
- (void)addFrameWidth:(CGFloat)width
{
    [self setFrameWidth:self.frame.size.width + width];
}

/**
 add the height to the receiver's frame
 @param  CGFloat height
 @return void
 */
- (void)addFrameHeight:(CGFloat)height
{
    [self setFrameHeight:self.frame.size.height + height];
}

/**
 Increase x origin to the receiver's frame
 @param  CGFloat x origin value to increase
 @return void
 */
- (void)increaseFrameX:(CGFloat)x
{
    [self setFrameX:self.frame.origin.x + x];
}

/**
 Increase y origin to the receiver's frame
 @param  CGFloat y origin value to increase
 @return void
 */
- (void)increaseFrameY:(CGFloat)y
{
    [self setFrameY:self.frame.origin.y + y];
}

#pragma mark - Getters

/**
 Returns the receiver's frame width
 @return CGFloat width
 */
- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

/**
 Returns the receiver's frame height
 @return CGFloat height
 */
- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

/**
 Returns the receiver's frame x origin
 @return CGFloat x origin
 */
- (CGFloat)frameX
{
    return self.frame.origin.x;
}

/**
 Returns the receiver's frame y origin
 @return CGFloat y origin
 */
- (CGFloat)frameY
{
    return self.frame.origin.y;
}

#pragma mark - Other Methods

/**
 Removes all the subviews of receiver
 @return void
 */
- (void)removeAllSubviews
{
    FUNCTION_START;
    
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    FUNCTION_END;
}

/**
 Remove the specified subview of receiver
 @return void
 */
- (void)removeSubview:(id)subview
{
    FUNCTION_START;
    
    for (UIView *view in self.subviews)
    {
        if (view == subview)
        {
            [view removeFromSuperview];
        }
    }
    
    FUNCTION_END;
}

@end
