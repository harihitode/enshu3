#import <Cocoa/Cocoa.h>

#define SIZE_N 31
#define SIZE_N_1 30
#define SIZE_T 8
#define MERGE_TH 2.9
#define ALPHA 27.0
#define CARVE 2

#define CONF_DISTRIBUTION 0.24
#define CONF_RENDER_BLUR 1.5

#define RAND_SEARCH_SIZE 380

#define SIZE_W_X 600
#define SIZE_W_Y 300

typedef struct _tokenT{
  NSPoint vector[SIZE_N];
  double  press[SIZE_N];
  double  mag[SIZE_N];
  double  eata;  
  double  theta[SIZE_N];
  double  tddown[SIZE_N][SIZE_T];
  double  tdup[SIZE_N][SIZE_T];
} tokenT;
