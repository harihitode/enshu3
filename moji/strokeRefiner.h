#import <Cocoa/Cocoa.h>
#import "katarina.h"
#import "stroke.h"
#import "token.h"

typedef struct _tokenTripleT {
  NSPoint vector[SIZE_N];
  double press[SIZE_N];
  double lambda;
  int size;
  struct _tokenTripleT *next;
} tokenTripleT;

@interface StrokeRefiner : NSObject
{
  tokenT original;
  tokenTripleT *matches;
  int matchedNumber;  
}

-(id) init;
-(int) addMatchedToken:(Token *)t withL2:(double)l;
-(int) setTargetToken:(tokenT *)t;
-(int) unsetMatchedTokens;
-(Stroke *) getOriginalStroke;
-(int) matchedNumber;
-(tokenTripleT *) matchedTokens;
@end
