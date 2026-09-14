#include <stdlib.h>
#include "svdpi.h"
extern int sv_double(int value);
int c_add(int a,int b) { return a+b; }
int c_roundtrip(int a) { return sv_double(a); }
void *c_create(int value) {
  int *p=(int *)malloc(sizeof *p);
  if(p) *p=value;
  return p;
}
int c_read(void *handle) { return handle ? *(int *)handle : -1; }
void c_destroy(void *handle) { free(handle); }
