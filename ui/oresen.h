#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

@interface Oresen : NSObject{
  int direct;
  NSPoint v,mid;
  double l;
  double upy,dwy,rad;
  BOOL debug;
}
@property NSPoint a;
@property NSPoint b;
-(void) calculate;
-(void) drawUpLine;
-(void) drawDownLine;
-(void) drawLine;
-(void) draw;
-(void) selectDraw:(NSPoint) p;
@end
