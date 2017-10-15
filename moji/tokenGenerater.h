#import <Cocoa/Cocoa.h>
#import "katarina.h"
#import "token.h"

@interface TokenGenerater : NSObject{
  int count;
  tokenT latestStrokes;
}
+(tokenT *) calculateDescriptor:(tokenT *)t;
-(id) init;
-(Token *) generateTokenWithStroke:(NSPoint)s Press:(double)p;

@end
