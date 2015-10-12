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
            
            switch (elementModel.fieldType)
            {
                case ElementTypeTextField:
                case ElementTypeTextView:
                case ElementTypePickListOption:
                case ElementTypeRadioButton:
                case ElementTypeLookup:
                case ElementTypeSearch:
                {
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

@end

