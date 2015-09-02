//
//  DrawingPDF.m
//  MultiFormApp
//
//  Created by Nasib on 1/22/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DrawingPDF.h"
#import "ElementModel.h"

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
        
//        for (NSDictionary *elementPdfInfo in elements)
//        {
//            NSDictionary *formatInfo = elementPdfInfo[ElementPdfDrawingFormat];
//            id content = elementPdfInfo[ElementPdfDrawingContent];
//            
//            CGFloat originX  = [formatInfo[kElementOriginX] floatValue];
//            CGFloat originY  = [formatInfo[kElementOriginY] floatValue];
//            CGFloat width    = [formatInfo[kElementWidth] floatValue];
//            CGFloat height   = [formatInfo[kElementHeight] floatValue];
//            CGFloat fontSize = [formatInfo[kElementFontSize] floatValue];
//            NSString *fontColor = formatInfo[kElementFontColor];
//            NSString *fontName  = formatInfo[kElementFontName];
//            
//            if (fontSize <= 0.0f)
//            {
//                fontSize = DEFAULT_FONT_SIZE;
//            }
//            
//            UIColor *elementColor = [CommonUtils colorWithHexString:fontColor];
//            
//            if (!elementColor)
//            {
//                elementColor = DEFAULT_FONT_COLOR;
//            }
//            
//            UIFont *elementFont = [UIFont fontWithName:fontName size:fontSize];
//            
//            if (!elementFont)
//            {
//                elementFont = [UIFont fontWithName:DEFAULT_FONT_NAME size:fontSize];
//            }
//            
//            CGRect  elementRect = CGRectMake(originX, originY, width, height);
//            
//            if (content)
//            {
//                if ([content isKindOfClass:[UIImage class]])
//                {
//                    UIImage *image = content;
//                    [image drawInRect:elementRect];
//                }
//                else if ([content isKindOfClass:[NSString class]])
//                {
//                    NSDictionary *attrDic = @{NSFontAttributeName: elementFont,
//                                              NSForegroundColorAttributeName: elementColor};
//                    
//                    [content drawInRect:elementRect withAttributes:attrDic];
//                }
//            }
//        }
    }
    
    UIGraphicsEndPDFContext();

    FUNCTION_END;
}

@end

