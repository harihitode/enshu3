#import "poseView.h"
#import "medal.h"
#import "ui.h"


@implementation PoseView

-(id)initWithFrame: (NSRect)frame{
  NSOpenGLPixelFormatAttribute attr[] = {
    NSOpenGLPFADoubleBuffer,
    NSOpenGLPFAAccelerated,
    NSOpenGLPFAStencilSize,32, // ステンシルバッファのビット数を32bitにする
    NSOpenGLPFAColorSize , 32, // 画像用バッファのビット数を32bitにする
    NSOpenGLPFADepthSize , 32, // デプスバッファのビット数を32bitにする
    0 // ターミネータ
  };
  for(int i=0;i<6;i++){
    priority[i] = i;
  }
  anime = 0;
  // timer = [NSTimer scheduledTimerWithTimeInterval:0.03
  // 					   target:self
  // 					 selector:@selector(drawAnimation:)
  // 					 userInfo:nil
  // 					  repeats:YES];
  NSOpenGLPixelFormat* pFormat;
  pFormat = [[[ NSOpenGLPixelFormat alloc] initWithAttributes : attr]
	      autorelease ];
  self = [ super initWithFrame : frame
		   pixelFormat : pFormat]; 
  [[self openGLContext] makeCurrentContext];
  center.width = frame.size.width/2.0;
  center.height = frame.size.height/2.0;

  for(int i=0;i<6;i++)
    calFlag[i] = YES;

  fig[HEAD_ID] = [[Medal alloc] initWithPosition:NSMakePoint(0,0.5)
					   Image:@"/Users/harihitode/smile.png"];
  fig[BODY_ID] = [[Medal alloc] initWithPosition:NSMakePoint(0.0,0.0)
					   Image:@"/Users/harihitode/body.png"];
  fig[LHND_ID] = [[Medal alloc] initWithPosition:NSMakePoint(-0.5,0.2)
					   Image:@"/Users/harihitode/lhand.png"];
  fig[RHND_ID] = [[Medal alloc] initWithPosition:NSMakePoint(0.5,0.2)
					   Image:@"/Usekrs/harihitode/rhand.png"];
  fig[LFOT_ID] = [[Medal alloc] initWithPosition:NSMakePoint(-0.2,-0.5)
					   Image:@"/Users/harihitode/lfoot.png"];
  fig[RFOT_ID] = [[Medal alloc] initWithPosition:NSMakePoint(0.2,-0.5)
					   Image:@"/Users/harihitode/rfoot.png"];
  head = [[[Circle alloc] init] autorelease];
  body = [[[Triangle alloc] init] autorelease];
  rarm = [[[Oresen alloc] init] autorelease];
  larm = [[[Oresen alloc] init] autorelease];
  rleg = [[[Oresen alloc] init] autorelease];
  lleg = [[[Oresen alloc] init] autorelease];
  medal = NO;

  selectingObject = -1;
  
  glClearColor(1.0,1.0,1.0,1.0);  
  glEnable(GL_TEXTURE_2D);
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glLineWidth(LINE_SIZE);
  glEnable(GL_POLYGON_SMOOTH);
  glEnable(GL_LINE_SMOOTH);

  [self transForm:nil];
  return self;
}

-(void)drawRect: (NSRect) bounds{
  GLuint texId;
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glInitNames();  
  if(medal){
    for(int i=0;i<6;i++){  
      glPushName(priority[i]);
      [fig[priority[i]] draw];
      glPopName();
    }
  }else{
    glPushName(HEAD_ID);
    [head draw];
    glPopName();
    glPushName(LHND_ID);        
    [larm draw];
    glPopName();
    glPushName(RHND_ID);
    [rarm draw];
    glPopName();
    glPushName(LFOT_ID);
    [lleg draw];
    glPopName();
    glPushName(RFOT_ID);
    [rleg draw];
    glPopName();
    [body draw];
  }
  glFinish();
  [[self openGLContext] flushBuffer];
}

-(void) mouseDown:(NSEvent *)event{
  NSPoint p = [event locationInWindow];
  p.x = (p.x - center.width)/center.width;
  p.y = (p.y - center.height)/center.height;
  selectingObject = [self selectedObject:p];  
  int t,new[6];
  t = selectingObject;

  if(t >= 0){
    printf("[%d]\n",t);    
    for(int i=0;i<6;i++){
      if(t == priority[i]){
	t = i;
	break;
      }
    }
    printf("[[%d]\n",t);
    for(int i=0;i<5;i++){
      if(i < t)
	new[i] = priority[i];
      else
	new[i] = priority[i+1];
    }
    new[5] = priority[t];
    for(int i=0;i<6;i++){
      priority[i] = new[i];
      printf("%d\n",new[i]);
    }
  }
}

-(void) mouseUp:(NSEvent *)event{  
  selectingObject = -1;
}

-(int) selectedObject:(NSPoint)p {
  int selectBufferLength = 100;  
  unsigned int selectBuff[100];
  int ret = -1;
  if(selectingObject < 0){
    glSelectBuffer(selectBufferLength,selectBuff);
    glLoadIdentity();
    double dv = 0.01;
    glOrtho(p.x-dv,p.x+dv,p.y-dv,p.y+dv,-1.0,1.0);
    glRenderMode(GL_SELECT);
    [self drawRect:NSMakeRect(0,0,0,0)];
    glLoadIdentity();
    int hit = glRenderMode(GL_RENDER);
    if(hit > 0)
      ret = selectBuff[4*hit-1];
  }else
    ret = selectingObject;
  return ret;
}

-(void) mouseDragged:(NSEvent *)event{
  NSPoint p = [event locationInWindow];
  p.x = (p.x - center.width)/center.width;
  p.y = (p.y - center.height)/center.height;
  if(p.x > 1.0-MEDAL_SIZE/2.0)
    p.x = 1.0-MEDAL_SIZE/2.0;
  else if(p.x < -1.0+MEDAL_SIZE/2.0)
    p.x = -1.0+MEDAL_SIZE/2.0;
  if(p.y > 1.0-MEDAL_SIZE/2.0)
    p.y = 1.0-MEDAL_SIZE/2.0;
  else if(p.y < -1.0+MEDAL_SIZE/2.0)
    p.y = -1.0+MEDAL_SIZE/2.0;    
  selectingObject = [self selectedObject:p];
  if(medal){
    if(selectingObject >= 0){
      [fig[selectingObject] reDrawToPosition:NSMakePoint(p.x,p.y)];
      if(selectingObject == HEAD_ID ||
	 selectingObject == BODY_ID){
	for(int i=0;i<6;i++)
	  calFlag[i] = YES;    
      }
      calFlag[selectingObject] = YES;  
    }
  }else{
    switch(selectingObject){
    case HEAD_ID:
      [head reDrawToPosition:p];
      break;
    case LHND_ID:
      [larm selectDraw:p];
      break;
    case RHND_ID:
      [rarm selectDraw:p];
      break;
    case LFOT_ID:
      [lleg selectDraw:p];
      break;
    case RFOT_ID:
      [rleg selectDraw:p];
      break;      
    default:
      break;
    }
  }
  [self setNeedsDisplay:YES];
}

-(void) drawAnimation: (NSTimer*) aTimer{
  // anime++;
  // if(anime > 100)
  //   anime = 0;

  // double rate = (double)anime/100.0;
  // double x = 0.5*cos(2.0 * M_PI * rate);
  // double y = 0.5*sin(2.0 * M_PI * rate);
 
  // [medal reDrawToPosition:NSMakePoint(x,y)];
  // [self display];
}

-(IBAction) transForm:(id) sender{
  if(medal)
    medal = NO;
  else
    medal = YES;
  NSPoint v1,v2;
  NSPoint hdp = fig[HEAD_ID].position;
  NSPoint bdp = fig[BODY_ID].position;
  NSPoint rap = fig[RHND_ID].position;
  NSPoint lap = fig[LHND_ID].position;
  NSPoint rlp = fig[RFOT_ID].position;
  NSPoint llp = fig[LFOT_ID].position;
  v1.x = bdp.x - hdp.x;
  v1.y = bdp.y - hdp.y;

  double l = sqrt(v1.x*v1.x + v1.y*v1.y);
  if(l == 0)
    l = 1.0;
  if(l){
    v1.x /= l;
    v1.y /= l;
  }else{
    v1.x = 0.0;
    v1.y = -1.0;
  }
  v2.x = -v1.y;
  v2.y = v1.x;
    
  NSPoint ba,bb,bc;
  ba.x = hdp.x + BODY_HEIGHT * v1.x;
  ba.y = hdp.y + BODY_HEIGHT * v1.y;  
  bb.x = hdp.x + HEAD_BODY * v1.x + KATA_HABA * v2.x;
  bb.y = hdp.y + HEAD_BODY * v1.y + KATA_HABA * v2.y;
  bc.x = hdp.x + HEAD_BODY * v1.x - KATA_HABA * v2.x;
  bc.y = hdp.y + HEAD_BODY * v1.y - KATA_HABA * v2.y;

  body.a = ba;
  body.b = bb;
  body.c = bc;

  larm.a = bc;
  larm.b = lap;

  rarm.a = bb;
  rarm.b = rap;
  
  lleg.a = ba;
  lleg.b = llp;
  
  rleg.a = ba;
  rleg.b = rlp;
  if(calFlag[HEAD_ID])
    head.position = hdp;        
  if(calFlag[LHND_ID])
    [larm calculate];
  if(calFlag[RHND_ID])
    [rarm calculate];
  if(calFlag[LFOT_ID])
    [lleg calculate];     
  if(calFlag[RFOT_ID])
    [rleg calculate];
  for(int i=0;i<6;i++)
    calFlag[i] = NO;
  [self setNeedsDisplay:YES];
}

-(BOOL) acceptsFirstResponder{
 return YES;
}

- (void)keyDown:(NSEvent*)event
{
  switch ([event keyCode]){
  case 49:
    [self transForm:nil];
    break;
  case 36:
    [self transForm:nil];
    break;    
  default:
    break;
 }
}

@end
