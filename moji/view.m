#import "view.h"
#import "tokenView.h"
#import <OpenGL/gl.h>

@implementation MyOpenGLView
- (id)initWithFrame: (NSRect)frame
	pixelFormat: (NSOpenGLPixelFormat *)format{
  celler = [[[TokenCeller alloc] init] autorelease];
  tokeng = [[[TokenGenerater alloc] init] autorelease];
  xsize = SIZE_W_X / 2.0;
  ysize = SIZE_W_Y / 2.0;
  refresh = 0;
  penUp = 1;
  return [super initWithFrame:frame pixelFormat:format];  
}

- (void) writeLine: (NSPoint)s endPoint:(NSPoint)e
{
  NSPoint start,end;
  start.x = (s.x - xsize)/xsize;
  start.y = (s.y - ysize)/ysize;
  end.x = (e.x - xsize)/xsize;
  end.y = (e.y - ysize)/ysize;
  
  glColor3f(0.8,0,0);
  glPointSize(1);    
  glBegin(GL_LINES);
  glVertex2f(start.x,start.y);
  glVertex2f(end.x,end.y);
  glEnd();  
  [self setNeedsDisplay:YES];
}

- (void) writePoint: (NSPoint)p
{
  NSPoint point;
  point.x = (p.x - xsize)/xsize;
  point.y = (p.y - ysize)/ysize;

  glColor3f(0.0,0.5,0.5);
  glPointSize(5);  
  glBegin(GL_POINTS);
  glVertex2f(point.x,point.y);
  glEnd();
  [self setNeedsDisplay:YES];
}

- (void)drawRect: (NSRect) bounds{
  if(refresh == 0){
    glClearColor(0.8,0.8,0.7,0);    
    glClear(GL_COLOR_BUFFER_BIT);
    glLineWidth(1);
    glPointSize(4);
    glEnableClientState(GL_VERTEX_ARRAY);
    refresh++;
    glFlush();    
  }else
    glFlush();
}

- (NSPoint)nextStroke: (NSPoint)p{
  latestPts[1] = latestPts[0];  
  latestPts[0] = p;
  double x = latestPts[0].x - latestPts[1].x;
  double y = latestPts[0].y - latestPts[1].y;
  theta[1] = theta[0];  
  if((theta[0] = atan2(y,x)) < 0)
    theta[0] = 2*M_PI + theta[0];      
  return NSMakePoint(x,y);
}

- (void)mouseDown: (NSEvent *)event{
  penUp = 1;
  [self updateRawSample:[self nextStroke:[event locationInWindow]] Dt:1.0];  
}

- (void)mouseUp: (NSEvent *)event{
  [self updateRawSample:[self nextStroke:[event locationInWindow]] Dt:1.0];
}

- (void)mouseDragged: (NSEvent *)event{
  NSPoint vector = [self nextStroke:[event locationInWindow]];
  [self writeLine:latestPts[0] endPoint:latestPts[1]];  
  double dt;  
  double bx = strokej.x;
  double by = strokej.y;
  double bj = sqrt(bx*bx+by*by) - sqrt(CARVE);
  double bt = fabs(theta[0] - theta[1]);
  if(1 < bj)
    bj = 1;
  else if(bj < 0)
    bj = 0;
  if((dt = ALPHA * bt * bj / (2*M_PI)) > 1)
    dt = 1;  
  [self updateRawSample:vector Dt:dt];
}

-(void)updateRawSample: (NSPoint)v Dt:(double)dt{
  int nowj = (int) floor(zi);
  zi = zi + dt;
  int nexj = (int) floor(zi);
  strokej.x += v.x;
  strokej.y += v.y;      
  if(nexj > nowj){
    [self writePoint:latestPts[0]];
    Token *newToken = [tokeng generateTokenWithStroke:strokej
						Press:(1-penUp)];
    penUp = 0;        
    [celler addToken:newToken];
    strokej = NSMakePoint(0,0);
  }
}

- (IBAction)refreshView: (id)sender{
  zi = 0;
  refresh=0;
  [celler clearWindow];
  [self setNeedsDisplay:YES];
}

- (IBAction)showTokenWindow: (id)sender{
  [celler drawTokenNext];
}

- (IBAction)drawToken: (id)sender{
  [celler drawTokenPrev];  
}
@end

