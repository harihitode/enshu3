#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

@interface Circle : NSObject
@property NSPoint position;
-(void) draw;
-(void) reDrawToPosition:(NSPoint) p;
@end
