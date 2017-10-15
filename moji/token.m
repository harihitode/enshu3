#import "token.h"
#import "tokenGenerater.h"

@implementation Token
@synthesize size;

-(id)  initWithTokenProperty:(tokenT *)p{
  [super init];
  property = *p;
  size = 1;
  tokenNo = 0;
  render = [[TokenLRender alloc] initWithFrame:NSMakeRect(0,0,300,300)];
  return self;
}

-(void) setTokenNo:(int)n{
  tokenNo = n;
  [self lowResolutionRender];
}

-(tokenT *) getProperty{
  return &property;
}

-(NSBitmapImageRep *) lowResolutionRender{
  NSString *name = [[[NSString alloc]
		      initWithFormat:@"/Users/harihitode/ドキ☆ドキ!?トークン集/no.%d-%d.png",tokenNo,size] autorelease];
  rep = [render renderToken:&property];
  //Nsdata *data = [rep representationUsingType: NSPNGFileType properties: nil];
  //[data writeToFile:name atomically: NO];  
  return rep;
}

-(double) compareWithToken:(Token *)t{
  double vl = 0;
  tokenT target = *[t getProperty];
  for(int j=0;j<SIZE_N;j++){
    for(int k=0;k<SIZE_T;k++){
      vl += pow(property.tdup[j][k] - target.tdup[j][k],2);
      vl += pow(property.tddown[j][k] - target.tddown[j][k],2);
    }
  }
  return sqrt(vl);
}

-(NSBitmapImageRep *) getImage{
  return rep;
}

-(double) confidenceWithToken:(Token *)t{
  NSBitmapImageRep *target = [t lowResolutionRender];
  NSUInteger p1[4],p2[4];
  double p1_,p2_;
  double vl = 0;
  rep = [self lowResolutionRender];    
  for(int i=0;i<130;i++){
    for(int j=0;j<130;j++){
      [rep getPixel:p1 atX:i y:j];
      [target getPixel:p2 atX:i y:j];
      p1_ = p1[0]/255.0;
      p2_ = p2[0]/255.0;
      vl += pow(p1_-p2_,2);
    }
  } 
  return sqrt(vl);
}

-(void) mergeWithToken:(Token *)t{
  double alignBeta[SIZE_N][SIZE_N];
  double alignCost[SIZE_N][SIZE_N];
  tokenT target = *[t getProperty];
  
  for(int i=1;i<SIZE_N;i++){
    for(int j=0;j<SIZE_N;j++){
      alignBeta[i][j] =
	fabs(property.theta[i] - target.theta[j]) +
	fabs(property.mag[i] - target.mag[j]);
      if((property.press[i] == 0 && target.press[j] == 0) ||	 
	 (property.press[i] > 0 && target.press[j] > 0)){}
      else
	alignBeta[i][j] += 1;
    }
  }
  // for(int i=0;i<SIZE_N;i++){
  //   for(int j=0;j<SIZE_N;j++)
  //     printf("%0.2f ",alignBeta[i][j]);
  //   putchar('\n');
  // }
  
  alignCost[0][0] = alignBeta[0][0];
  for(int i=1;i<SIZE_N;i++){
    alignCost[0][i] = alignCost[0][i-1] + 0.2 + alignBeta[0][i];
    alignCost[i][0] = alignCost[i-1][0] + 0.2 + alignBeta[i][0];
  }
  double c1,c2,c3,min;
  for(int i=1;i<SIZE_N;i++){
    for(int j=1;j<SIZE_N;j++){
      c1 = alignCost[i][j-1] + 0.2;
      c2 = alignCost[i-1][j-1];
      c3 = alignCost[i-1][j] + 0.2;
      if(c1 > c2){
	if(c2 > c3)
	  min = c3;
	else
	  min = c2;
      }else{
	if(c1 > c3)
	  min = c3;
	else
	  min = c1;
      }	
      alignCost[i][j] = min + alignBeta[i][j];
    }
  }
  int i=SIZE_N-1,j=SIZE_N-1;
  //printf("(%d,%d)",i,j);  
  for(;;){
    if(i != 0 && j != 0){
      c1 = alignCost[i][j-1];
      c2 = alignCost[i-1][j-1];
      c3 = alignCost[i-1][j];      
    }else if(i != 0 && j == 0){
      c1 = INFINITY;
      c2 = INFINITY;
      c3 = alignCost[i-1][j];            
    }else{
      c1 = alignCost[i][j-1];
      c2 = INFINITY;
      c3 = INFINITY;
    }
    if(c1 > c2){
      if(c2 > c3)
	i--;
      else{
	i--;j--;}
    }else{
      if(c1 > c3)
	i--;
      else
	j--;
    }
    property.vector[i].x =
      (target.vector[j].x + size * property.vector[i].x)/(1.0 + size);
    property.vector[i].y =
      (target.vector[j].y + size * property.vector[i].y)/(1.0 + size);
    //printf("(%d,%d)",i,j);
    if(i == 0 && j == 0)
      break;
  }
  //putchar('\n');
  
  [TokenGenerater calculateDescriptor:&property];
  size++;

  [self lowResolutionRender];
}

-(void) draw{
  CGContextRef cgContext = [[NSGraphicsContext currentContext] graphicsPort];
  CGContextSetRGBFillColor(cgContext,1.0,1.0,1.0,1.0);    
  CGContextFillRect(cgContext,CGRectMake(0,0,310,80));  
  double r;  
  for(int i=0;i<SIZE_N;i++){
    for(int j=0;j<SIZE_T;j++){
      r = property.tddown[i][j];
      if(property.press[i])
	CGContextSetRGBFillColor(cgContext,1.0-r,1.0-r,1.0-r,1.0);	  
      else
	CGContextSetRGBFillColor(cgContext,1.0-r,0.0,0.0,1.0);
      CGContextFillRect(cgContext,NSMakeRect(10*i,10*j,10,10));	  
    }
  }
}
@end
