#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

#define TEX_SIZE 1024
#define MEDAL_SIZE 0.2

@interface Medal : NSObject{
  GLuint texId;
  double size;
}
@property NSPoint position;
-(GLuint) loadImageToTexture : (NSString *) imagePath;
-(id) initWithPosition:(NSPoint)p Image:(NSString *)imagePath;
-(void) draw;
-(void) reDrawToPosition:(NSPoint)p;
@end
