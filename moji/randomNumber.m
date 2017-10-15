#import "randomNumber.h"

@implementation RandomNumber
@synthesize num;
@synthesize random;

-(id) initWithNum:(int)n{
  [super init];
  num = n;
  random = rand();
  return self;
}

-(NSComparisonResult) compare:(RandomNumber *) aNumber{
  if(random > aNumber.random)
    return 1;
  else if(random < aNumber.random)
    return -1;
  else
    return 0;
}

-(void) reRandomValue{
  random = rand();
}
@end
