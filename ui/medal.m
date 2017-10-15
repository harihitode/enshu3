#import "medal.h"
#import <math.h>
#import <OpenGL/gl.h>

@implementation Medal
@synthesize position;

-(id) initWithPosition:(NSPoint)p Image:(NSString *) imagePath{
  [super init];
  position = p;
  size = MEDAL_SIZE;
  texId = [self loadImageToTexture:imagePath];
  return self;
}

-(GLuint) loadImageToTexture : (NSString *) imagePath{
  NSImage *original;
  NSBitmapImageRep *imgTexRep;
  GLuint tid;

  original = [[[NSImage alloc] initWithContentsOfFile:imagePath]
	      autorelease];  
  imgTexRep = [[NSBitmapImageRep alloc]
		initWithData:[original TIFFRepresentation]];

  glPixelStorei(GL_UNPACK_ALIGNMENT,1);
  glGenTextures(1,&tid);
  glBindTexture(GL_TEXTURE_2D,tid);
  glTexImage2D(GL_TEXTURE_2D,
  	       0, //mipmap
  	       GL_RGBA,TEX_SIZE,TEX_SIZE,//width and height
  	       0, //border
  	       [imgTexRep hasAlpha]?GL_RGBA:GL_RGB,
  	       GL_UNSIGNED_BYTE,
  	       [imgTexRep bitmapData]);
  
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);  
  
  glBindTexture(GL_TEXTURE_2D,0);
  return tid;
}

-(void) draw{
  int n = 100;

  glColor4f(0.0,0.0,0.0,1.0);
  glBegin(GL_POLYGON);
  for(int i=0;i<n;i++) {
    double rate = (double)i/n;
    double x = cos(2.0 * M_PI * rate); 
    double y = sin(2.0 * M_PI * rate);
    glVertex2f((size+0.02)*x+position.x,(size+0.02)*y+position.y);
  }
  glEnd();
  
  glBindTexture(GL_TEXTURE_2D,texId);
  glColor4f(1.0,1.0,1.0,1.0);
  glBegin(GL_POLYGON);
  for(int i=0;i<n;i++) {
    double rate = (double)i/n;
    double x = cos(2.0 * M_PI * rate);
    double y = sin(2.0 * M_PI * rate);
    glTexCoord2f((x+1.0)/2.0,(-y+1.0)/2.0);
    glVertex2f(size*x+position.x,size*y+position.y);
  }
  glEnd();

  glBindTexture(GL_TEXTURE_2D,0);
}

-(void) reDrawToPosition:(NSPoint)p{
  position = p;
  [self draw];
}
@end
