#import <Cocoa/Cocoa.h>
#import "katarina.h"
#import "tokenView.h"
#import "tokenRender.h"
#import "token.h"

@interface TokenCeller : NSWindow{
  int currentView;
  NSMutableArray *tokenArray;
  NSMutableArray *latestMatches;
  NSMutableArray *randomArray;
  NSButton *btn2,*btn3;
  TokenView *tknv;  
  TokenRender *tkrn;
}

-(id) init;
-(void) addToken:(Token *)t;
-(void) drawTokenNo: (int)n;
-(void) drawToken;
-(void) drawTokenNext;
-(void) drawTokenPrev;
-(void) clearWindow;

@end
