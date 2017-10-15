#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import "medal.h"
#import "circle.h"
#import "triangle.h"
#import "oresen.h"

#define HEAD_ID 0
#define BODY_ID 1
#define LHND_ID 2
#define RHND_ID 3
#define LFOT_ID 4
#define RFOT_ID 5

@interface PoseView : NSOpenGLView{
  CGSize center;
  Medal *fig[6];
  int selectingObject;
  double anime;
  BOOL medal,calFlag[6];
  Circle *head;
  Triangle *body;
  Oresen *rarm,*larm,*rleg,*lleg;
  int priority[6];
  //NSTimer *timer;
}
-(id)initWithFrame: (NSRect)frame;
-(void) drawRect:(NSRect) bounds;
-(int) selectedObject:(NSPoint) p;
@end
