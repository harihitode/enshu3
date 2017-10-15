#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import "circle.h"
#import "ui.h"
#import <math.h>
@implementation Circle
@synthesize position;
-(id) init{
  [super init];
  position = NSMakePoint(0,0);
  return self;
}

-(void) reDrawToPosition:(NSPoint) p{
  position = p;
  [self draw];
}

-(void) draw{
  int n = 100;
  double size = HEAD_SIZE;
  glColor4f(0.0,0.0,0.0,1.0);  
  glBegin(GL_POLYGON);
  for(int i=0;i<n;i++) {
    double rate = (double)i/n;
    double x = cos(2.0 * M_PI * rate); 
    double y = sin(2.0 * M_PI * rate);
    glVertex2f((size+0.015)*x+position.x,(size+0.015)*y+position.y);
  }
  glEnd();
  glColor4f(1.0,1.0,1.0,1.0);    
  glBegin(GL_POLYGON);
  for(int i=0;i<n;i++) {
    double rate = (double)i/n;
    double x = cos(2.0 * M_PI * rate); 
    double y = sin(2.0 * M_PI * rate);
    glVertex2f(size*x+position.x,size*y+position.y);
  }
  glEnd();
}
@end
