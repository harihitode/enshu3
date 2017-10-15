#import "tokenGenerater.h"

@implementation TokenGenerater
-(id) init{
  [super init];
  count = 0;
  for(int i=0;i<SIZE_N;i++){
    latestStrokes.mag[i]    = 0.0;
    latestStrokes.press[i]  = 0.0;
    latestStrokes.vector[i] = NSMakePoint(0,0);
    for(int j=0;j<SIZE_T;j++){
      latestStrokes.tddown[i][j] = 1.0;
      latestStrokes.tdup[i][j] = 1.0;
    }
  }
  return self;
}

+(tokenT *) calculateDescriptor:(tokenT *)t{
  NSPoint v;
  double mag,thetaj,orient;
  int fl,cl;
  double up[SIZE_N][SIZE_T],down[SIZE_N][SIZE_T];
  double blur[5] = {1.0,4.0,6.0,4.0,1.0};
  double blsum = 16.0;

  for(int i=0;i<SIZE_N;i++){
    for(int j=0;j<SIZE_T;j++){
      up[i][j]   = 0.0;
      down[i][j] = 0.0;
    }
  }
  
  for(int i=0;i<SIZE_N;i++){
    for(int j=0;j<SIZE_T;j++)
      t->tddown[i][j] = 1.0;    
    v   = t->vector[i];
    mag = sqrt(v.x*v.x + v.y*v.y);
    if((thetaj = atan2(v.y,v.x)) < 0)
      thetaj = 2*M_PI + thetaj;  
    orient = thetaj/(M_PI/4);    
    fl = (int)(floor(orient));
    cl = (int)(ceil(orient));
    if(t->press[i]){    
      if(fl != cl){
	down[i][fl]   = mag*(orient-fl);
	down[i][cl%8] = mag*(cl-orient);
      }else
	down[i][fl] = mag;
    }else{
      if(fl != cl){
	up[i][fl]   = mag*(orient-fl);
	up[i][cl%8] = mag*(cl-orient);
      }else
	up[i][fl] = mag;
    }      
    t->theta[i] = thetaj;  
    t->mag[i]   = mag;
  }
  
  //GAUSSIAN BLURING TO DESCRIPTOR
  for(int i=0;i<SIZE_N;i++){
    for(int j=0;j<SIZE_T;j++){
      int a,b,c,d,e;
      if((a = i-2) < 0)
	a = 0;
      if((b = i-1) < 0)
	b = 0;
      c = i;
      if((d = i+1) > SIZE_N-1)
	d = SIZE_N-1;
      if((e = i+2) > SIZE_N-1)
	e = SIZE_N-1;
      t->tddown[i][j] =
	(blur[0]*down[a][j] + blur[1]*down[b][j] +
	 blur[2]*down[c][j] + blur[3]*down[d][j] + blur[4]*down[e][j]) / blsum;
      t->tdup[i][j] =
	(blur[0]*up[a][j] + blur[1]*up[b][j] +
	 blur[2]*up[c][j] + blur[3]*up[d][j] + blur[4]*up[e][j]) / blsum;      
    }
  }
  // for(int i=0;i<SIZE_N;i++){
  //   for(int j=0;j<SIZE_T;j++){
  //     t->tddown[i][j] = log(t->tddown[i][j]);
  //     t->tdup[i][j] = log(t->tdup[i][j]); 
  //   }
  // }
  return t;  
}

-(Token *) generateTokenWithStroke:(NSPoint)s Press:(double) p{
  tokenT token;
  double eata=0,eatadiv=0;
  latestStrokes.vector[count] = s;
  latestStrokes.press[count]  = p;
  latestStrokes.mag[count]    = sqrt(s.x*s.x + s.y*s.y);

  for(int i=0;i<SIZE_N;i++){
    if(latestStrokes.press[i]){
      eatadiv++;
      eata += latestStrokes.mag[i];
    }
  }
  if(eatadiv)
    eata /= eatadiv;
  else
    eata = 1.0;
  
  for(int i=0;i<SIZE_N;i++){
    int off = (i+count+1)%SIZE_N;
    token.vector[i] = latestStrokes.vector[off];
    token.press[i]  = latestStrokes.press[off];
  }

  for(int i=0;i<SIZE_N;i++){
    token.vector[i].x /= eata;
    token.vector[i].y /= eata;
  }     
  token.eata = eata;
  
  [TokenGenerater calculateDescriptor:&token];
  if(++count == SIZE_N)
    count = 0;  
  return [[[Token alloc] initWithTokenProperty:&token] autorelease];
}
@end


const double gauss[31] = {
  0.00000000093,
  0.00000002794,
  0.00000040513,
  0.00000378117,
  0.00002552290,
  0.00013271905,
  0.00055299606,
  0.00189598650,
  0.00545096118,
  0.01332457177,
  0.02798160072,
  0.05087563768,
  0.08055309299,
  0.11153505184,
  0.13543542009,
  0.14446444809,
  0.13543542009,
  0.11153505184,
  0.08055309299,
  0.05087563768,
  0.02798160072,
  0.01332457177,
  0.00545096118,
  0.00189598650,
  0.00055299606,
  0.00013271905,
  0.00002552290,
  0.00000378117,
  0.00000040513,
  0.00000002794,
  0.00000000093};
