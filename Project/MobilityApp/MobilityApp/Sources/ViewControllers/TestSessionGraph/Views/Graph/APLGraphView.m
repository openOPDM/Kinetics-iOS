
/*
     File: APLGraphView.m
 Abstract: Displays a graph of output. This class uses Core Animation techniques to avoid needing to render the entire graph every update.
 
 The APLGraphView needs to be able to update the scene quickly in order to track the data at a fast enough frame rate. There is too much content to draw the entire graph every frame and sustain a high framerate. This class therefore uses CALayers to cache previously drawn content and arranges them carefully to create an illusion that we are redrawing the entire graph every frame.
 
  Version: 1.0.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "APLGraphView.h"

#pragma mark - Quartz Helpers

#define kNormalizeFactor 1000.0

// Functions used to draw all content.

CGColorRef CreateDeviceGrayColor(CGFloat w, CGFloat a)
{
    CGColorSpaceRef gray = CGColorSpaceCreateDeviceGray();
    CGFloat comps[] = {w, a};
    CGColorRef color = CGColorCreate(gray, comps);
    CGColorSpaceRelease(gray);
    return color;
}

CGColorRef CreateDeviceRGBColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat comps[] = {r, g, b, a};
    CGColorRef color = CGColorCreate(rgb, comps);
    CGColorSpaceRelease(rgb);
    return color;
}

CGColorRef graphBackgroundColor()
{
    static CGColorRef c = NULL;
    if (c == NULL)
    {
        c = CreateDeviceGrayColor(0.6, 1.0);
    }
    return c;
}

CGColorRef graphLineColor()
{
    static CGColorRef c = NULL;
    if (c == NULL)
    {
        c = CreateDeviceGrayColor(0.5, 1.0);
    }
    return c;
}

CGColorRef graphXColor()
{
    static CGColorRef c = NULL;
    if (c == NULL)
    {
        c = CreateDeviceRGBColor(1.0, 0.0, 0.0, 1.0);
    }
    return c;
}

CGColorRef graphYColor()
{
    static CGColorRef c = NULL;
    if (c == NULL)
    {
        c = CreateDeviceRGBColor(0.0, 1.0, 0.0, 1.0);
    }
    return c;
}

CGColorRef graphZColor()
{
    static CGColorRef c = NULL;
    if (c == NULL)
    {
        c = CreateDeviceRGBColor(0.0, 0.0, 1.0, 1.0);
    }
    return c;
}

double InverCoordX(CGFloat aX, CGFloat width){
    
    return (2*aX-width)/(2*kNormalizeFactor);
}

double InverCoordY(CGFloat aY, CGFloat height){
    
    return (height-2*aY)/(2*kNormalizeFactor);
}

void DrawGridlines(CGContextRef context, CGFloat x, CGFloat width, CGFloat height)
{
    
    for (CGFloat theX = 10; theX <= width; theX += 15.0)
    {
        CGContextMoveToPoint(context, theX, 0);
        CGContextAddLineToPoint(context, theX, height);
    }
    
    x=0;
    
    for (CGFloat y = 0; y <= height; y += 15.0)
    {
        CGContextMoveToPoint(context, 0, y);
        CGContextAddLineToPoint(context,width, y);
    }
    
    CGContextSetStrokeColorWithColor(context, graphLineColor());
    CGContextStrokePath(context);
    
    //draw X axis
    //CGContextMoveToPoint(context, 0, height/2);
    CGContextMoveToPoint(context, 0, height-10);
    //CGContextAddLineToPoint(context, width, height/2);
    CGContextAddLineToPoint(context, width, height-10);

    
    //draw Y axis
    //CGContextMoveToPoint(context, width/2,0);
    CGContextMoveToPoint(context, 10, 0);
    //CGContextAddLineToPoint(context, width/2, height);
    CGContextAddLineToPoint(context, 10, height);
    
    //draw Y axis units
    for (CGFloat y = 45; y <= height-30; y += 30.0)
    {
        CGContextMoveToPoint(context, 5, y);
        CGContextAddLineToPoint(context,15, y);
        
        NSString *text = [NSString stringWithFormat:@"%.3f",InverCoordY(y,height)];
        CGPoint center = CGPointMake(35, y);
        UIFont *font = [UIFont systemFontOfSize:8];
        
        CGSize stringSize = [text sizeWithFont:font];
        CGRect stringRect = CGRectMake(center.x-stringSize.width/2, center.y-stringSize.height/2, stringSize.width, stringSize.height);
        
        [[UIColor whiteColor] set];
        [text drawInRect:stringRect withFont:font];
    }
    
    //draw X axis units
    for (CGFloat theX = 40; theX <= width; theX += 30.0)
    {
    
        CGContextMoveToPoint(context, theX, height-5);
        CGContextAddLineToPoint(context, theX, height-15);
        
        NSString *text = [NSString stringWithFormat:@"%.2f",InverCoordX(theX,width)];
        CGPoint center = CGPointMake(theX, height-20);
        UIFont *font = [UIFont systemFontOfSize:8];
        
        CGSize stringSize = [text sizeWithFont:font];
        CGRect stringRect = CGRectMake(center.x-stringSize.width/2, center.y-stringSize.height/2, stringSize.width, stringSize.height);
        
        [[UIColor whiteColor] set];
        [text drawInRect:stringRect withFont:font];
        
    }

    //draw Y title
    NSString *text = @"AP";
    CGPoint center = CGPointMake(50, 20);
    UIFont *font = [UIFont systemFontOfSize:16];
    
    CGSize stringSize = [text sizeWithFont:font];
    CGRect stringRect = CGRectMake(center.x-stringSize.width/2, center.y-stringSize.height/2, stringSize.width, stringSize.height);
    
    [[UIColor whiteColor] set];
    [text drawInRect:stringRect withFont:font];
    
    text = @"ML";
    center = CGPointMake(width-20, height-50);
    font = [UIFont systemFontOfSize:16];
    
    stringSize = [text sizeWithFont:font];
    stringRect = CGRectMake(center.x-stringSize.width/2, center.y-stringSize.height/2, stringSize.width, stringSize.height);
    
    [[UIColor whiteColor] set];
    [text drawInRect:stringRect withFont:font];
    
    
    CGContextSetStrokeColorWithColor(context, graphYColor());
    CGContextStrokePath(context);
    
}

void DrawPixel(CGContextRef context, CGFloat x, CGFloat y, CGFloat frameSize){
    
    CGRect frame = CGRectMake(x - frameSize / 2.0,
                              y - frameSize / 2.0, frameSize, frameSize);
    CGContextSetFillColorWithColor (context,graphZColor());
    CGContextFillEllipseInRect(context, frame);
    CGContextStrokeEllipseInRect(context, frame);
    
}

void DrawEllipse(CGContextRef context, CGFloat x, CGFloat y, CGFloat frameW, CGFloat frameH){
    
    frameW=frameW/2;
    frameH=frameH/2;
    
    CGRect frame = CGRectMake(x - frameW / 2.0,
                              y - frameH / 2.0, frameW, frameH);

    CGContextStrokeEllipseInRect(context, frame);
        
}


void DrowLines(CGContextRef context, CGFloat x0, CGFloat y0, CGFloat x1, CGFloat y1){
    
    CGContextMoveToPoint(context, x0, y0);
    CGContextAddLineToPoint(context, x1, y1);
    
    CGContextSetStrokeColorWithColor(context, graphZColor());
    CGContextStrokePath(context);
}

void DrowCurvedLines(CGContextRef context, CGFloat x0, CGFloat y0, CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2){
    
    CGContextMoveToPoint(context, x0, y0);
    //CGContextAddLineToPoint(context, x1, y1);
    CGContextAddCurveToPoint(context, x0, y0, x1, y1, x2, y2);
    
    CGContextSetStrokeColorWithColor(context, graphZColor());
    CGContextStrokePath(context);
}

@interface APLGraphView(){
    
    NSMutableArray* strokeArr;
    NSArray* rowTestData;
    NSArray* pathArray;
    
}

@end



@implementation APLGraphView

// Designated initializer.
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        [self commonInit];
    }
    return self;
}


// Designated initializer.
-(id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if (self != nil)
    {
        [self commonInit];
    }
    return self;
}


-(void)commonInit
{
    // Create a mutable array to store segments, which is required by -addSegment.
    //strokeArr = [[NSMutableArray alloc]init];
}


/*
 The graph view itself exists only to draw the background and gridlines. All other content is drawn either into the GraphTextView or into a layer managed by a GraphViewSegment.
 */
-(void)drawRect:(CGRect)aRect
{
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    // Fill in the background.
    CGContextSetFillColorWithColor(theContext, graphBackgroundColor());
    CGContextFillRect(theContext, self.bounds);

    // Draw the grid lines.
    CGFloat theWidth = self.bounds.size.width;
    CGFloat theHeight = self.bounds.size.height;
    DrawGridlines(theContext, 0.0,theWidth,theHeight);
    
    
    if ([strokeArr count]>0) {
    
        for (NSUInteger i=0; i<[strokeArr count]-2*2; i+=2*2) {
            
            CGFloat x0 = [self convertoCoordSystemX:[strokeArr[i]doubleValue]];
            CGFloat y0 = [self convertoCoordSystemY:[strokeArr[i+1]doubleValue]];
            CGFloat x1 = [self convertoCoordSystemX:[strokeArr[i+  1*2]doubleValue]];
            CGFloat y1 = [self convertoCoordSystemY:[strokeArr[i+1+1*2]doubleValue]];
            CGFloat x2 = [self convertoCoordSystemX:[strokeArr[i+  2*2]doubleValue]];
            CGFloat y2 = [self convertoCoordSystemY:[strokeArr[i+1+2*2]doubleValue]];
            DrowCurvedLines(theContext,x0,y0,x1,y1,x2,y2);
        }
    }


}

-(NSMutableArray*)formGraphArray{
    
    int iterationStep = 20;
    NSMutableArray* retArray = [[NSMutableArray alloc]init];
    for (NSUInteger i=1; i<[rowTestData count]-2*4; i+=iterationStep*2*4) {
        
        if (i+1+2*4<[rowTestData count]-2*4) {
            NSString* x0 = rowTestData[i];
            NSString* y0 = rowTestData[i+  1];
            NSString* x1 = rowTestData[i+  1*4];
            NSString* y1 = rowTestData[i+1+1*4];
            NSString* x2 = rowTestData[i+  2*4];
            NSString* y2 = rowTestData[i+1+2*4];
            
            [retArray addObject:x0];
            [retArray addObject:y0];
            [retArray addObject:x1];
            [retArray addObject:y1];
            [retArray addObject:x2];
            [retArray addObject:y2];
        }
       
    }

    return retArray;
}


-(void)drowStabilogramWitharray:(NSArray*)aRowTestData{
    
    rowTestData = aRowTestData;
    strokeArr = [self formGraphArray];
    [self setNeedsDisplay];

}

-(double)convertoCoordSystemX:(double)aX{
    
    CGFloat theWidth = self.bounds.size.width;
    return theWidth/2+aX*kNormalizeFactor;
}

-(double)inverCoordX:(double)aX{
    
    CGFloat theWidth = self.bounds.size.width;
    return (2*aX-theWidth)/(2*kNormalizeFactor);
}

-(double)convertoCoordSystemY:(double)aY{
    
    CGFloat theHeight = self.bounds.size.height;
    return theHeight/2-aY*kNormalizeFactor;
    
}

-(double)inverCoordY:(double)aY{
    
    CGFloat theHeight = self.bounds.size.height;
    return (theHeight-2*aY)/(2*kNormalizeFactor);
}

-(double)calculateLengthforX:(double)aX andY:(double)aY{
    
    return kNormalizeFactor*sqrt(pow(aX, 2)+pow(aY,2));
}

-(void)clearContext{
    
    [strokeArr removeAllObjects];
    [self setNeedsDisplay];

}
@end

