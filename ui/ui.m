#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import "ui.h"
#import "poseView.h"

int main()  
{
  [NSAutoreleasePool new]; 
  [NSApplication sharedApplication];
  [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];            
  id window = [[[NSWindow alloc]
		 initWithContentRect:NSMakeRect(500,300,W_SIZE_X,W_SIZE_Y)
			   styleMask:NSTitledWindowMask
			     backing:NSBackingStoreBuffered
			       defer:NO] autorelease];

  id pose = [[[PoseView alloc]
	       initWithFrame:NSMakeRect(0,0,W_SIZE_X,W_SIZE_Y)] autorelease];
  [pose setWantsBestResolutionOpenGLSurface:YES];

  id sview = [window contentView];  
  [sview addSubview:pose];
  
  id menubar = [[NSMenu new] autorelease];
  id rtmenu = [[NSMenuItem new] autorelease];
  id appmenu = [[NSMenu new] autorelease];
  id quitmenu = [[[NSMenuItem new]
		   initWithTitle:@"quit"
			  action:@selector(terminate:)
		   keyEquivalent:@"q"] autorelease];
  id tranmenu = [[[NSMenuItem new]
		   initWithTitle:@"trans"
			  action:@selector(transForm:)
		   keyEquivalent:@"a"] autorelease];  
  [tranmenu setTarget:pose];
  [appmenu addItem:quitmenu];
  [appmenu addItem:tranmenu];
  [rtmenu setSubmenu:appmenu];
  [menubar addItem:rtmenu];
  [window setTitle:@"Pose"];
  [window makeKeyAndOrderFront:nil];
  
  [NSApp setMainMenu:menubar];
  [NSApp activateIgnoringOtherApps:YES];  
  [NSApp run];
  return 0;
}
