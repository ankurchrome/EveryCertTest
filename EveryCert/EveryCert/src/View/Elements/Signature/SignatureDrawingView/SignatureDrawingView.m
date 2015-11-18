//
//  SignatureDrawingView.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "SignatureDrawingView.h"

@implementation SignatureDrawingView

{
    UIBezierPath    *_bezierPath;
//    UIImage         *_image;
    CGPoint pts[5]; // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    uint ctr;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setMultipleTouchEnabled:NO];
        _bezierPath = [UIBezierPath bezierPath];
        _bezierPath.lineWidth = 2.0f;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setMultipleTouchEnabled:NO];
        _bezierPath = [UIBezierPath bezierPath];
        [_bezierPath setLineWidth:2.0];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ctr = 0;
    UITouch *touch = [touches anyObject];
    pts[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    ctr++;
    pts[ctr] = point;
    if (ctr == 4)
    {
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
        
        [_bezierPath moveToPoint:pts[0]];
        [_bezierPath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
        
        [self setNeedsDisplay];
        // replace points and get ready to handle the next segment
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self drawBitmap];
    [self setNeedsDisplay];
    [_bezierPath removeAllPoints];
    ctr = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    if (!_image) //first time; paint background white
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    
    [_image drawAtPoint:CGPointZero];
    [[UIColor blackColor] setStroke];
    [_bezierPath stroke];
    [self.layer renderInContext:UIGraphicsGetCurrentContext()]; // Image Modification Issue Solved
    _image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [_image drawInRect:rect];
    [_bezierPath stroke];
}

- (void)clearImage
{
    //Reload the view
    [self setNeedsDisplay];
    
    // Clear Image Color by remove Opaque by No
    UIGraphicsBeginImageContextWithOptions(_image.size, NO, _image.scale);
    _image = UIGraphicsGetImageFromCurrentImageContext();
}

@end
