#import <OpenGL/gl.h>
#import <Cocoa/Cocoa.h>
#import "katarina.h"
#import "token.h"

@interface TokenView : NSView
{
  int blurFlag;
  Token *tkn;
  int tknNo;
  NSWindow *window;
  TokenLRender *view;
}
-(id)   initWithFrame: (NSRect)frame;
-(void) drawRect: (NSRect)bounds;
-(void) drawToken: (Token *)t TokenNo:(int)n;
-(void) refreshView;
-(IBAction) toggleBlurFlag: (id)sender;
@end
