#import "strokeRefiner.h"

double gaussian(double h,double w2,double a){
  double t = 1/(sqrt(2*M_PI) * sqrt(w2));
  double exp = -pow(a - h,2)/(2*w2);
  double e = pow(M_E,exp);
  //printf("h=%f,a=%f,dis:%f confidence=%f\n",h,a,h-a,t*e);
  return (t*e);
}

static void
deleteTokenTriple(tokenTripleT *t){
  if(t->next)
    deleteTokenTriple(t->next);
  free(t);
}

@implementation StrokeRefiner

-(id) init{
  matches = NULL;
  for(int i=0;i<31;i++)
    original.vector[i]=NSMakePoint(0,0);
  return [super init];
}

-(int) addMatchedToken:(Token *)t withL2:(double)l{
  tokenTripleT *i = matches,*next;
  tokenT *prop = [t getProperty];
  
  matchedNumber++;
  next = calloc(1,sizeof(tokenTripleT));

  for(int j=0;j<31;j++){
    next->vector[j] = prop->vector[j];
    next->press[j] = prop->press[j];
  }
  next->size = t.size;
  next->lambda = l;
  next->next = NULL;
  if(matches){
    for(i = matches;i->next != NULL;i=i->next){}
    i->next = next;
  }else
    matches = next;
  return 0;
}

-(int) setTargetToken:(tokenT *)t{
  tokenTripleT *index;
  index = matches;
  double l2=0,h;
  double c=1;
  while(index){
    l2 += index->lambda;
    c += 1;
    index = index->next;
  }
  h = l2/c;
  double w2 = 1.5;
  index = matches;
  while(index){
    index->lambda = gaussian(h,CONF_DISTRIBUTION,index->lambda);
    index = index->next;
  }
  original = *t;
  return 0;
}

-(int) unsetMatchedTokens{
  if(matches)
    deleteTokenTriple(matches);
  matchedNumber = 0;
  matches = NULL;
  return 0;
}

-(Stroke *) getOriginalStroke{
  Stroke *s = [[[Stroke alloc] init] autorelease];
  s.stroke = original.vector[30];
  s.press = original.press[30];
  s.eata = original.eata;
  s.flag = 0;
  s.refined = NSMakePoint(0,0);
  return s;
}

-(int) matchedNumber{
  return matchedNumber;
}

-(tokenTripleT *) matchedTokens{
  return matches;
}
@end
