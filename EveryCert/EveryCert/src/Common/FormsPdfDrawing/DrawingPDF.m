//
//  DrawingPDF.m
//  MultiFormApp
//
//  Created by Nasib on 1/22/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DrawingPDF.h"
#import "ElementModel.h"
#import "SubElementModel.h"

#define DEFAULT_FONT_SIZE  8
#define DEFAULT_FONT_NAME  @"ArialNarrow"
#define DEFAULT_FONT_COLOR [UIColor blackColor]

#define A4_PAPER_RECT CGRectMake(0, 0, 595, 842)

@implementation DrawingPDF

//Draw the content of all elements of certificate on given form layout and save it as given path.
- (void)drawElements:(NSArray *)elements onPdfLayout:(NSURL *)pdfLayoutUrl saveAs:(NSString *)pdfPath
{
    FUNCTION_START;

    CGPDFDocumentRef pdfDocRef = CGPDFDocumentCreateWithURL((CFURLRef)pdfLayoutUrl);
    const size_t numberOfPages = CGPDFDocumentGetNumberOfPages(pdfDocRef);
    
    UIGraphicsBeginPDFContextToFile(pdfPath, A4_PAPER_RECT, nil);
    
    for(size_t page = 1; page <= numberOfPages; page++)
    {
        //Get the current page and page frame
        CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdfDocRef, page);
        const CGRect pageFrame = CGPDFPageGetBoxRect(pdfPage, kCGPDFMediaBox);
        
        UIGraphicsBeginPDFPageWithInfo(pageFrame, nil);
        
        //Draw the page (flipped)
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -pageFrame.size.height);
        CGContextDrawPDFPage(ctx, pdfPage);
        CGContextRestoreGState(ctx);
        
        for (ElementModel *elementModel in elements)
        {
            if (page != elementModel.pageNumber) continue;
            
            NSDictionary *formatInfo = elementModel.printedTextFormat;
            CGFloat   fontSize  = [formatInfo[kPdfFormatElementFontSize] floatValue];
            NSString *fontColor = formatInfo[kPdfFormatElementFontColor];
            NSString *fontName  = formatInfo[kPdfFormatElementFontName];
            
            if (fontSize <= 0.0f)
            {
                fontSize = DEFAULT_FONT_SIZE;
            }
            
            UIColor *elementColor = [CommonUtils colorWithHexString:fontColor];
            
            if (!elementColor)
            {
                elementColor = DEFAULT_FONT_COLOR;
            }
            
            UIFont *elementFont = [UIFont fontWithName:fontName size:fontSize];
            
            if (!elementFont)
            {
                elementFont = [UIFont fontWithName:DEFAULT_FONT_NAME size:fontSize];
            }
            
            CGRect elementRect = CGRectMake(elementModel.originX, elementModel.originY, elementModel.width, elementModel.height);
            
            if(elementModel.printedTextFormat[@"pdf_format"])
            {
                for(NSDictionary *otherElementModelDict in elementModel.printedTextFormat[@"pdf_format"])
                {
                    if([otherElementModelDict[ElementPageNumber] integerValue] == elementModel.pageNumber)
                    {
                        [self printElementinOtherLocationForElementDict:otherElementModelDict withElementData:elementModel.dataValue];
                    }
                }
            }
            
            switch (elementModel.fieldType)
            {
                case ElementTypeTextField:
                case ElementTypeTextView:
                case ElementTypePickListOption:
                case ElementTypeRadioButton:
                case ElementTypeLookup:
                case ElementTypeSearch:
                {
                    // Radio Button condition change elementColor, if its RadioButtonColor exist
                    if(elementModel.fieldType == ElementTypeRadioButton)
                    {
                        UIColor *changeElementColor = [self changeRadioButtonElementColor: elementModel];
                        changeElementColor = [UIColor clearColor] ? : (elementColor = changeElementColor);  // if it returns clear color ie. i consider as nill then do nothing else return the perticular of Radio Button if exist
                    }
                    
                    NSDictionary *attrDic = @{NSFontAttributeName: elementFont,
                                              NSForegroundColorAttributeName: elementColor};
                    
                    [elementModel.dataValue drawInRect:elementRect withAttributes:attrDic];
                
                }
                    break;
                    
                case ElementTypeSubElement:
                {
                    for (SubElementModel *subElementModel in elementModel.subElements)
                    {
                        NSDictionary *attrDic = @{NSFontAttributeName: elementFont,
                                                  NSForegroundColorAttributeName: elementColor};
                        
                        [subElementModel.dataValue drawInRect:elementRect withAttributes:attrDic];
                    }
                }
                    break;
                    
                case ElementTypeSignature:
                {
                    UIImage *image = [UIImage imageWithData:elementModel.dataBinaryValue];
                    [image drawInRect:elementRect];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    UIGraphicsEndPDFContext();

    FUNCTION_END;
}

// If the Individual Radio Button is having its own Color in the Element Record
- (UIColor *)changeRadioButtonElementColor:(ElementModel *)elementModel
{
    // Radio Button Color for Specific Button on PDF
    NSArray *radioButtons = [elementModel.printedTextFormat objectForKey:kPdfFormatRadioButtons];
    
    for(NSDictionary *radioButtonInfo in radioButtons)
    {
        if([elementModel.dataValue isEqualToString:radioButtonInfo[kPdfFormatRadioButtonValue]] && radioButtonInfo[kPdfRadioButtonColor])
        {
            return [CommonUtils colorWithHexString:radioButtonInfo[kPdfRadioButtonColor]]; // Returns the Actual Color
        }
    }
    return [UIColor clearColor];    //Work as a nill color that never exist
}

// This method Prints the Data value in mutiple Location on PDF according to the pdfFormat
- (void)printElementinOtherLocationForElementDict:(NSDictionary *)otherElementDict withElementData:(NSString *)elementDataValue
{
    CGFloat   fontSize  = [otherElementDict[kPdfFormatElementFontSize] floatValue];
    NSString *fontColor = otherElementDict[kPdfFormatElementFontColor];
    NSString *fontName  = otherElementDict[kPdfFormatElementFontName];
    
    if (fontSize <= 0.0f)
    {
        fontSize = DEFAULT_FONT_SIZE;
    }
    
    UIColor *elementColor = [CommonUtils colorWithHexString:fontColor];
    
    if (!elementColor)
    {
        elementColor = DEFAULT_FONT_COLOR;
    }
    
    UIFont *elementFont = [UIFont fontWithName:fontName size:fontSize];
    
    if (!elementFont)
    {
        elementFont = [UIFont fontWithName:DEFAULT_FONT_NAME size:fontSize];
    }

    CGRect elementRect = CGRectMake([otherElementDict[@"ElementOriginX"]floatValue], [otherElementDict[@"ElementOriginY"] floatValue], [otherElementDict[@"ElementWidth"] floatValue], [otherElementDict[@"ElementHeight"] floatValue]);
    
    NSDictionary *attrDic = @{NSFontAttributeName: elementFont,
                              NSForegroundColorAttributeName: fontColor};
    
    [elementDataValue drawInRect:elementRect withAttributes:attrDic];
}

@end

