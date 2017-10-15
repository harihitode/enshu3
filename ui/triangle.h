#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

@interface Triangle : NSObject
@property NSPoint a;
@property NSPoint b;
@property NSPoint c;
-(void) draw;
@end
