#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/CoreImage.h>
#import "tokenLRender.h"

@implementation TokenLRender
- (id)initWithFrame: (NSRect)frame{
  self = [super initWithFrame:frame];  
  if(self)
    self.wantsLayer = YES;  
  token = NULL;
  return self;
}

- (void)drawRect: (NSRect) bounds{
  CGContextRef cgContext = [[NSGraphicsContext currentContext] graphicsPort];
  NSPoint start,end;
  double hmax=150,hmin=150,vmax=150,vmin=150;
  int fflag=0;   
  CGContextSetRGBFillColor(cgContext,0,0,0,1.0);
  CGContextFillRect(cgContext,CGRectMake(0,0,300,300));
  if(token){
    start = NSMakePoint(150,150);
    [[NSColor whiteColor] set];
    [NSBezierPath setDefaultLineWidth:1];
    for(int i=0;i<31;i++){
      end = NSMakePoint(start.x + token->vector[i].x,
			start.y + token->vector[i].y);          
      if(end.x > hmax)
	hmax = end.x;
      else if(end.x < hmin)
	hmin = end.x;
      if(end.y > vmax)
	vmax = end.y;
      else if(end.y < vmin)
	vmin = end.y;      
      start = end;
    }
    
    start = NSMakePoint(300-((hmax+hmin)/2.0),300-((vmax+vmin)/2.0));
    for(int i=0;i<31;i++){
      end = NSMakePoint(start.x + token->vector[i].x,
			start.y + token->vector[i].y);                
      if(token->press[i])
	[NSBezierPath strokeLineFromPoint:start toPoint:end];
      start = end;
    }    
  }
}

-(NSBitmapImageRep *) renderToken:(tokenT *)t{
  token = t; 
  NSBitmapImageRep *rep =
    [self bitmapImageRepForCachingDisplayInRect:NSMakeRect(120,120,60,60)];
  [self cacheDisplayInRect:NSMakeRect(120,120,60,60) toBitmapImageRep:rep];  
  CIImage *mid = [[[CIImage alloc] initWithBitmapImageRep:rep] autorelease];
  CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" 
  				keysAndValues: kCIInputImageKey, mid, 
  			       @"inputRadius", [NSNumber numberWithFloat:CONF_RENDER_BLUR],nil];
  CIImage *outputImage = [filter valueForKey: kCIOutputImageKey];
  rep = [rep initWithCIImage:outputImage];
  [self setNeedsDisplay:YES];
  return rep;
}
@end

  // CIVector *cropRect =[CIVector vectorWithX:0 Y:0 Z:250 W:250];
  // filter = [CIFilter filterWithName:@"CICrop"
  // 		      keysAndValues: kCIInputImageKey, [filter valueForKey: kCIOutputImageKey],
  // 		     @"inputRectangle", cropRect, nil];
  
