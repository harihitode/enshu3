#import <OpenGL/gl.h>
#import <Cocoa/Cocoa.h>
#import "katarina.h"
#import "strokeRefiner.h"
#import "strokeArray.h"
#import "token.h"

@interface TokenRender : NSView
{
  tokenT *token;
  StrokeArray *sArray;
  StrokeRefiner *sr[31];
  int count,rFlag;
  NSPoint renderStart;
}

-(id) initWithFrame: (NSRect)frame;
-(void) drawRect: (NSRect)bounds;
-(void) renderToken: (tokenT *)t;
-(void) setMatchedToken: (Token *)t withL2: (double)l;
-(void) setToken: (tokenT *)t;
-(void) unsetToken;
-(void) clearWindow;
-(NSPoint) refinedStroke;
-(IBAction) toggleRefineFlag:(id) sender;
@end
