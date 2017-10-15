#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import "katarina.h"
#import "tokenLRender.h"

@interface Token : NSObject{
  tokenT  property;
  TokenLRender *render;
  int tokenNo;
  NSBitmapImageRep *rep;
}
@property int size;
-(id)   initWithTokenProperty:(tokenT *)p;
-(void) draw;
-(void) mergeWithToken:(Token *)t;
-(double) compareWithToken:(Token *)t;
-(double) confidenceWithToken:(Token *)t;
-(tokenT *) getProperty;
-(NSBitmapImageRep *) getImage;
-(void) setTokenNo:(int)n;
-(NSBitmapImageRep *) lowResolutionRender;
@end

