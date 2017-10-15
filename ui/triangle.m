#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import "triangle.h"
#import "ui.h"
#import <math.h>


const GLfloat vertex[] = {
	-0.9 , 0.9 , 0.9 , 0.9 , 0 , -0.9
};

@implementation Triangle
@synthesize a;
@synthesize b;
@synthesize c;
-(id) init{
  [super init];
  a = NSMakePoint(0,0);
  b = NSMakePoint(0,0);
  c = NSMakePoint(0,0);
  return self;
}

-(void) draw{
  glColor3f(0.0,0.0,0.0);

  glBegin(GL_LINE_LOOP);
  glVertex2f(a.x,a.y);
  glVertex2f(b.x,b.y);
  glVertex2f(c.x,c.y);  
  glEnd();
}
@end
