#import <OpenGL/gl.h>
#import <Cocoa/Cocoa.h>
#import "tokenCeller.h"
#import "tokenGenerater.h"

@interface MyOpenGLView : NSOpenGLView
{
  float xsize,ysize;
  int refresh,penUp;
  float theta[2];
  NSPoint latestPts[2],strokej;
  float zi;
  TokenCeller *celler;
  TokenGenerater *tokeng;
}
-(id)   initWithFrame: (NSRect)frame pixelFormat:(NSOpenGLPixelFormat *)format;
-(void) drawRect: (NSRect)bounds;
-(void) updateRawSample: (NSPoint)v Dt:(double)dt;
-(void) mouseDown: (NSEvent *)theEvent;
-(IBAction) refreshView: (id)sender;
-(IBAction) drawToken: (id)sender;
-(IBAction) showTokenWindow: (id)sender;
-(NSPoint) nextStroke: (NSPoint) p;
-(void) writeLine: (NSPoint)s endPoint:(NSPoint)e;
@end
