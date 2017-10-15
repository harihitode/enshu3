#import <Cocoa/Cocoa.h>

@interface RandomNumber : NSObject
@property int num;
@property int random;
-(id) initWithNum:(int) n;
-(NSComparisonResult) compare:(RandomNumber *) aNumber;
-(void) reRandomValue;
@end



