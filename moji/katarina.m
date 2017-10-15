#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import "view.h"
#import "tokenView.h"
#import "token.h"
#import "randomNumber.h"
#import <time.h>

extern double gaussian(double h,double w2,double a);

int main()  
{
  srand(time(NULL));  
  [NSAutoreleasePool new];   
  [NSApplication sharedApplication];
  [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];            
  id window = [[[NSWindow alloc]
		 initWithContentRect:NSMakeRect(500,300,SIZE_W_X,SIZE_W_Y)
			   styleMask:NSTitledWindowMask
			     backing:NSBackingStoreBuffered		 
			       defer:NO] autorelease];
  id sview = [window contentView];
  id gl = [[[MyOpenGLView alloc]
	     initWithFrame:NSMakeRect(0,0,SIZE_W_X,SIZE_W_Y)
	       pixelFormat:[MyOpenGLView defaultPixelFormat]] autorelease];  
  [gl setWantsBestResolutionOpenGLSurface:YES];  
  [sview addSubview:gl];

  Token *t = [[[Token alloc] init] autorelease];
  
  id menubar = [[NSMenu new] autorelease];
  id rtmenu = [[NSMenuItem new] autorelease];
  id appmenu = [[NSMenu new] autorelease];
  id quitmenu = [[[NSMenuItem new]
		   initWithTitle:@"終了"
			  action:@selector(terminate:)
		   keyEquivalent:@"q"] autorelease];
  id tshowmenu = [[[NSMenuItem new]
		    initWithTitle:@"現在のトークンと比較"
			   action:@selector(compTokens:)
		    keyEquivalent:@"t"] autorelease];
  id tokenmenu = [[[NSMenuItem new]
		    initWithTitle:@"トークンを見る"
			   action:@selector(showTokenWindow:)
		    keyEquivalent:@"a"] autorelease];
  id freshmenu = [[[NSMenuItem new]
		    initWithTitle:@"画面をクリアー"
			   action:@selector(refreshView:)
		    keyEquivalent:@"o"] autorelease];  
  [freshmenu setTarget:gl];
  [tokenmenu setTarget:gl];
  [tshowmenu setTarget:gl];
  
  [appmenu addItem:freshmenu];
  [appmenu addItem:tokenmenu];
  [appmenu addItem:quitmenu];
  [appmenu addItem:tshowmenu];  
  [rtmenu setSubmenu:appmenu];
  [menubar addItem:rtmenu];
  [window setTitle:@"入力ウインドウ"];
  [window makeKeyAndOrderFront:nil];
  
  [NSApp setMainMenu:menubar];      
  [NSApp activateIgnoringOtherApps:YES];  
  [NSApp run];
  return 0;
}
