#import <OpenGL/gl.h>
#import <Cocoa/Cocoa.h>
#import "katarina.h"

@interface TokenLRender : NSView
{
  tokenT *token;
}

-(id) initWithFrame: (NSRect)frame;
-(void) drawRect: (NSRect)bounds;
-(NSBitmapImageRep *) renderToken: (tokenT *)t;

@end
