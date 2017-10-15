#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreImage.h>
#import "tokenRender.h"
#import "strokeArray.h"

  // NSString *name = [[[NSString alloc]
  // 		      initWithFormat:@"/Users/harihitode/ドキ☆ドキ!?トークン集/no.%d-%d.png",tokenNo,size] autorelease];

extern double gaussian(double h,double w2,double a);

@implementation TokenRender

- (id)initWithFrame: (NSRect)frame{
  self = [super initWithFrame:frame];
  sArray = [[[StrokeArray alloc] init] autorelease];
  if(self)
    self.wantsLayer = YES;
  token = NULL;
  count = 0;
  rFlag = 0;
  for(int i=0;i<SIZE_N;i++)
    sr[i] = [[[StrokeRefiner alloc] init] autorelease];
  renderStart = NSMakePoint(0,0);
  CGContextRef cgContext = [[NSGraphicsContext currentContext] graphicsPort];
  CGContextSetRGBFillColor(cgContext,1.0,1.0,1.0,1.0);    
  CGContextFillRect(cgContext,CGRectMake(0,0,300,300));  
  [NSBezierPath setDefaultLineWidth:1];  
  [self setNeedsDisplay:YES];  
  return self;
}
  
- (void)drawRect: (NSRect) bounds{
  double r;
  NSPoint start,end;
  NSPoint v;
  if(rFlag)
    [self refinedStroke];
  else
    rFlag++;
}
 
- (void)renderToken:(tokenT *)t{
  token = t;
  [self setNeedsDisplay:YES];  
}

- (NSPoint)refinedStroke{
  tokenTripleT *m;
  Stroke *s;
  NSPoint p;
  double div = 1.0;
  double w;  
  s = [sArray nextStroke];
  if(s){
    p = s.stroke;
    for(int i=0;i<SIZE_N;i++){
      int off = (i+count)%SIZE_N;
      m = [sr[off] matchedTokens];
      while(m){
	if(((m->press[SIZE_N_1-i] != 0) && (s.press != 0)) ||
	   ((m->press[SIZE_N_1-i] == 0) && (s.press == 0))){
	  w = gaussian((SIZE_N_1)/2,(pow((SIZE_N_1)/6,2)),i) *
	    sqrt(m->size) * m->lambda;
	  div += w;
	  p.x += (w * m->vector[SIZE_N_1-i].x);
	  p.y += (w * m->vector[SIZE_N_1-i].y);
	}
	m = m->next;
      }
    }
    [sr[count] unsetMatchedTokens];  
    p.x = p.x / div;
    p.y = p.y / div;
    s.refined = p;
    s.flag = 1;
  }
  [sArray drawStroke];
  return NSMakePoint(10,10);
}

- (void)setMatchedToken: (Token *)t withL2: (double)l{
  [sr[count] addMatchedToken:t withL2:l];
}

- (void)setToken: (tokenT *)t{
  Stroke *s;
  [sr[count] setTargetToken:t];
  s = [sr[count] getOriginalStroke];
  s.flag = 0;
  [sArray addStroke:s];
  
  count++;
  if(count == SIZE_N)
    count = 0;  
  [self setNeedsDisplay:YES];
}

- (void)unsetToken{
  [sr[count] unsetMatchedTokens];
}

- (IBAction)toggleRefineFlag:(id) sender{
  [sArray toggleRefineFlag];
  [sArray drawStroke];
  [self setNeedsDisplay:YES];
}

- (void)clearWindow{
  rFlag = 0;
  [sArray clear];
  [self setNeedsDisplay:YES];
}
@end

