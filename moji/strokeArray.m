#import "strokeArray.h"

@implementation StrokeArray
-(void) drawStroke{
  int count = [array count];  
  Stroke *s;
  NSPoint avgOri,avgRef,drift,drifted;
  drift = NSMakePoint(0,0);
  avgOri = NSMakePoint(0,0);
  avgRef = NSMakePoint(0,0);
  end = strokeStart;
  rend = refineStart;
  
  for(int i=0;i<count;i++){    
    s = [array objectAtIndex:i];
    
    start = end;
    rstart = drift;
    
    end.x += s.stroke.x * s.eata;
    end.y += s.stroke.y * s.eata;
    rend.x += s.refined.x * s.eata;
    rend.y += s.refined.y * s.eata;    

    avgOri.x = (avgOri.x * i + end.x)/(i+1);
    avgOri.y = (avgOri.y * i + end.y)/(i+1);
    avgRef.x = (avgRef.x * i + rend.x)/(i+1);
    avgRef.y = (avgRef.y * i + rend.y)/(i+1);

    drift.x = rend.x - (avgRef.x - avgOri.x);
    drift.y = rend.y - (avgRef.y - avgOri.y);
        
    if(s.press){
      if(showRefine){
	if(s.flag)
	  [NSBezierPath strokeLineFromPoint:rstart toPoint:drift];
	else
	  [NSBezierPath strokeLineFromPoint:start toPoint:end];
      }else
	[NSBezierPath strokeLineFromPoint:start toPoint:end];	
    }
  }
}

-(Stroke *) nextStroke{
  int count = [array count];
  if(count - SIZE_N > 0)
    return [array objectAtIndex:(count-SIZE_N-1)];
  else
    return nil;
}

-(id) init{
  [super init];
  showRefine = 1;
  strokeStart = NSMakePoint(0,0);
  refineStart = NSMakePoint(0,0);
  array = [[[NSMutableArray alloc] init] autorelease];
  return self;
}
-(void) addStroke:(Stroke *)s{ 
  [array addObject:s];
}
-(void) toggleRefineFlag{
  if(showRefine)
    showRefine = 0;
  else
    showRefine = 1;
}
-(void) clear{
  strokeStart = end;
  refineStart = rend;  
  [array removeAllObjects];
}
@end
