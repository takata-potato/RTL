#include "svdpi.h"
extern int sv_wait(int cycles,int *result);
int c_sum(const svOpenArrayHandle data) {
  int sum=0;
  for(int i=svLow(data,1);i<=svHigh(data,1);++i) {
    const int *element=(const int *)svGetArrElemPtr1(data,i);
    if(!element) return -1;
    sum+=*element;
  }
  return sum;
}
void c_copy4(const svLogicVecVal *a,svLogicVecVal *b) { b[0]=a[0]; }
int c_wait(int cycles,int *result) { return sv_wait(cycles,result); }
