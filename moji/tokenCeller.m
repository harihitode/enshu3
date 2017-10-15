#import "tokenCeller.h"
#import "tokenView.h"
#import "randomNumber.h"

@implementation TokenCeller
-(id) init{  
  currentView = 0;
  [super initWithContentRect:NSMakeRect(800,300,615,420)
		   styleMask:NSTitledWindowMask|NSClosableWindowMask
		     backing:NSBackingStoreBuffered		 
		       defer:NO];  
  [self setTitle:@"デバッグ ウインドウ"];
  [self setReleasedWhenClosed:NO];

  tokenArray = [[NSMutableArray alloc] init];
  randomArray = [[NSMutableArray alloc] init];
  latestMatches = [[NSMutableArray alloc] init];
  tknv = [[[TokenView alloc]
	     initWithFrame:NSMakeRect(5,5,SIZE_N*10,SIZE_T*10+30)] autorelease];
  tkrn = [[[TokenRender alloc]
	     initWithFrame:NSMakeRect(5,115,SIZE_W_X,SIZE_W_Y)] autorelease];
  btn2 = [[[NSButton alloc]
	    initWithFrame:NSMakeRect(340,10,110,20)] autorelease];
  [btn2 setTitle:@"ディスクリプタ"];
  [btn2 setBordered:YES];
  [btn2 setTarget:tknv];
  [btn2 setAction:@selector(toggleBlurFlag:)];
  
  btn3 = [[[NSButton alloc]
	    initWithFrame:NSMakeRect(340,50,110,20)] autorelease];  
  [btn3 setTitle:@"refine!"];
  [btn3 setBordered:YES];
  [btn3 setTarget:tkrn];
  [btn3 setAction:@selector(toggleRefineFlag:)];
  
  id sview = [self contentView];  
  [sview addSubview:tknv];
  [sview addSubview:tkrn];
  [sview addSubview:btn2];
  [sview addSubview:btn3];
  [self makeKeyAndOrderFront:nil];
  return self;
}

-(void) addToken:(Token *)t{
  int newFlag=0;
  double rd;
  int tokenSize = [tokenArray count];
  NSMutableArray *matches = [[[NSMutableArray alloc] initWithArray:latestMatches] autorelease];
  int search_size;
  int matchCount = [matches count];

  if(tokenSize > [randomArray count])
    [randomArray addObject:[[RandomNumber alloc] initWithNum:(tokenSize-1)]];  
  [latestMatches removeAllObjects];  
  [randomArray makeObjectsPerformSelector:@selector(reRandomValue)];

  NSArray *random = [randomArray sortedArrayUsingSelector:@selector(compare:)];
  
  for(int i=0;i<matchCount;i++){    
    NSNumber *j = [matches objectAtIndex:i];
    Token *index = [tokenArray objectAtIndex:[j intValue]];
    if([t compareWithToken:index] < MERGE_TH){
      newFlag++;          
      [index mergeWithToken:t];
      rd = [t confidenceWithToken:index];
      [tkrn setMatchedToken:index withL2:rd];
      [latestMatches addObject:j];
    }        
  }
    
  if(tokenSize < RAND_SEARCH_SIZE)
    search_size = tokenSize;
  else
    search_size = RAND_SEARCH_SIZE;

  if(newFlag==0){
    for(int i=0;i<search_size;i++){
      RandomNumber *randnum = [random objectAtIndex:i];
      Token *index = [tokenArray objectAtIndex:randnum.num];
      if([t compareWithToken:index] < MERGE_TH){
  	newFlag++;            
  	[index mergeWithToken:t];
  	rd = [t confidenceWithToken:index];
  	[tkrn setMatchedToken:index withL2:rd];
  	[latestMatches addObject:[[NSNumber alloc] initWithInt:randnum.num]];
      }
    }
  }
  
  [tkrn setToken:[t getProperty]];
  if(newFlag==0){
    [t setTokenNo:tokenSize];
    [tokenArray addObject:t];
  }
}

-(void) drawTokenNo: (int) n{
  int count = [tokenArray count];
  if(n >= count)
    n = count - 1;
  if(n < 0)
    n = 0;
  [tknv drawToken:[tokenArray objectAtIndex:n] TokenNo:n];
  currentView = n;
}

-(void) drawToken{
  [self drawTokenNo:currentView];
}

-(void) drawTokenNext{
  [self drawTokenNo:(currentView+1)];
}

-(void) drawTokenPrev{
  [self drawTokenNo:(currentView-1)];
}

- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (void)clearWindow{
  [tkrn clearWindow];
}

- (void)keyDown:(NSEvent*)event
{
  switch ([event keyCode]){
  case 123:
    [self drawTokenPrev];
    break;
  case 124:
    [self drawTokenNext];
    break;
  case 125:
    [self drawTokenNo:(currentView-10)];
    break;
  case 126:
    [self drawTokenNo:(currentView+10)];    
    break;
  default:
    break;
 }
}

@end
