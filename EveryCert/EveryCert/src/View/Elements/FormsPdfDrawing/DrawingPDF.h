//
//  DrawingPDF.h
//  MultiFormApp
//
//  Created by Nasib on 1/22/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface DrawingPDF : NSObject

@property (strong, nonatomic) UIImage  *pdfBgImage;//Set background image for pdf
@property (strong, nonatomic) NSString *fontType;// Set Font type of pdf text
@property (strong, nonatomic) UIColor  *fontColor;//Set Font color of pdf
@property (readwrite, nonatomic) CGFloat fontSize;// Set Font size of pdf

/**
 Draw the content of all elements of certificate on given form layout and save it as given path.
 @param  elements A list of FormElementModel objects. Each object contains its contents and drawing attributes. 
 @param  pdfLayoutUrl An url of pdf file on which element's content will be draw
 @param  pdfPath  Path string where the completed pdf will be save.
 @return void
 */
- (void)drawElements:(NSArray *)elements onPdfLayout:(NSURL *)pdfLayoutUrl saveAs:(NSString *)pdfPath;

@end