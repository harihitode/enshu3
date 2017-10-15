#import "tokenView.h"
#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/CoreImage.h>

@implementation TokenView
- (id)initWithFrame: (NSRect)frame{
  tkn = nil;
  tknNo = 0;
  blurFlag = 0;

  window = [[[NSWindow alloc]
		 initWithContentRect:NSMakeRect(300,300,300,300)
			   styleMask:NSTitledWindowMask|NSClosableWindowMask
			     backing:NSBackingStoreBuffered		 
			       defer:NO] autorelease];
  id sview = [window contentView];
  [window setReleasedWhenClosed:NO];
  view = [[TokenLRender alloc] initWithFrame:NSMakeRect(0,0,300,300)];
  [sview addSubview:view];
  return [super initWithFrame:frame];  
}

- (void)drawRect: (NSRect) bounds{
  if(tkn){
    [tkn draw];    
    NSString *str = [[[NSString alloc]
		       initWithFormat:@"token no. %d",tknNo] autorelease];
    NSAttributedString *astr = [[[NSAttributedString alloc]
				  initWithString:str] autorelease];
    [astr drawInRect:NSMakeRect(20,80,310,30)];    
  }else{
    NSString *str = [[[NSString alloc] initWithFormat:@"token no. -"] autorelease];
    NSAttributedString *astr = [[[NSAttributedString alloc]
				  initWithString:str] autorelease];
    [astr drawInRect:NSMakeRect(20,80,310,30)];
  }
}
- (void)refreshView{
  tkn = nil;
  [self setNeedsDisplay:YES];
}

- (void)mouseDown: (NSEvent *)event{
  NSString *name = [[[NSString alloc]
		       initWithFormat:@"token no.%d",tknNo] autorelease];

  // CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
  // 				keysAndValues:@"inputRadius", [NSNumber numberWithFloat:CONF_RENDER_BLUR],nil];
   if(tkn == nil)
     [window setTitle:@"token no.-"];
   else{
     [window setTitle:name];
     [view renderToken:[tkn getProperty]];
     //[view setContentFilters:[NSArray arrayWithObject:filter]];
   }
   [window makeKeyAndOrderFront:nil];
}

- (void)drawToken:(Token *)t TokenNo:(int) n{  
  tkn = t;
  tknNo = n;
  [self setNeedsDisplay:YES];  
}

- (IBAction)toggleBlurFlag: (id)sender{
  if(blurFlag)
    blurFlag=0;
  else
    blurFlag=1;
  [self setNeedsDisplay:YES];
}
@end
