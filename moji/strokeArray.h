#import <Cocoa/Cocoa.h>
#import "stroke.h"
#import "katarina.h"

@interface StrokeArray : NSObject
{
  NSMutableArray *array;
  int showRefine;
  NSPoint strokeStart;
  NSPoint refineStart;
  NSPoint start,end;
  NSPoint rstart,rend;  
}
-(id) init;
-(void) drawStroke;
-(void) addStroke:(Stroke *)s;
-(void) toggleRefineFlag;
-(void) clear;
-(Stroke *) nextStroke;
@end 
