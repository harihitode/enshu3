#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import "oresen.h"
#import "ui.h"
#import <math.h>

@implementation Oresen
@synthesize a;
@synthesize b;
-(id) init{
  [super init];
  a = NSMakePoint(0,0);
  b = NSMakePoint(0,0);
  debug = NO;
  mid = NSMakePoint(0,0);
  direct = DIR_NONE;
  return self;
}

-(void) selectDraw:(NSPoint) p{
  GLfloat mvMatrix[16];
  NSPoint sa;
  glPushMatrix();
  glRotated(-rad,0.0,0.0,1.0);
  glTranslatef(-a.x,-a.y,0.0);    
  
  glGetFloatv(GL_MODELVIEW_MATRIX,mvMatrix);

  mid.x = l/2;
  mid.y = mvMatrix[1] * p.x + mvMatrix[5] * p.y + mvMatrix[13];
  
  if(mid.y == 0)
    mid.y = dwy;
  else if(mid.y > upy)
    mid.y = upy;
  else if(mid.y < dwy)
    mid.y = dwy;

  if(mid.y == upy ||
     mid.y == dwy)
    direct = DIR_DONE;
  else
    direct = DIR_NONE;
  
  glLoadIdentity();
  glPopMatrix();
}

-(void) calculate{
  v.x = b.x - a.x;
  v.y = b.y - a.y;
  direct = DIR_NONE;  
  l = sqrt(v.x*v.x + v.y*v.y);  
  if(l==0){
    l = BOU_LENGTH * 2.0;
    v = NSMakePoint(0,1);
  }else if(l > BOU_LENGTH * 2.0){
    l = BOU_LENGTH * 2.0;
  }

  upy = sqrt(pow(BOU_LENGTH,2) - pow(l/2.0,2));
  dwy = -upy;   

  if(mid.y > upy)
    mid = NSMakePoint(l/2.0,upy);
  else if(mid.y < dwy)
    mid = NSMakePoint(l/2.0,dwy);
  else
    mid = NSMakePoint(l/2.0,mid.y);
  

  rad = atan2(v.y,v.x) * 180.0 / M_PI; 
}

-(void) drawUpLine{
  glBegin(GL_LINES);
  glVertex2f(0.0,0.0);
  glVertex2f(l/2.0,dwy);
  glVertex2f(l/2.0,dwy);
  glVertex2f(l,0.0);
  glEnd();  
}

-(void) drawDownLine{
  glBegin(GL_LINES);
  glVertex2f(0.0,0.0);
  glVertex2f(l/2.0,upy);
  glVertex2f(l/2.0,upy);
  glVertex2f(l,0.0);
  glEnd();
}

-(void) drawLine{
  double cir_size = 0.02;
  double midrad = atan2(mid.y,mid.x) * 180.0 / M_PI;
  double length = sqrt(pow(mid.y,2) + pow(l/2.0,2));
  
  glPushMatrix();
  glRotated(midrad,0,0,1.0);
  
  glBegin(GL_LINES);  
  glVertex2f(0.0,0.0);
  glVertex2f(length,0);
  glEnd();

  glPopMatrix();
  glPushMatrix();
  
  glTranslatef(mid.x,mid.y,0);
  glRotated(-midrad,0,0,1);
  
  glBegin(GL_LINES);    
  glVertex2f(0.0,0.0);
  glVertex2f(length,0);
  glEnd();

  glPopMatrix();

  if(direct != DIR_DONE){  
    glBegin(GL_POLYGON);
    for(int i=0;i<100;i++) {
      double rate = (double)i/100;
      double x = cos(2.0 * M_PI * rate); 
      double y = sin(2.0 * M_PI * rate);
      glVertex2f(cir_size*x+mid.x,cir_size*y+mid.y);
    }
    glEnd();
  }
}



-(void) draw{
  glPushMatrix();
  glTranslatef(a.x,a.y,0.0);
  glRotated(rad,0.0,0.0,1.0);    
  if(direct != DIR_DONE){
    glColor4f(0.8,0.8,0.8,0.5);    
    [self drawUpLine];
    [self drawDownLine];
  }
  glColor3f(0.0,0.0,0.0);
  [self drawLine];
  glLoadIdentity();
  glPopMatrix();
}
@end
