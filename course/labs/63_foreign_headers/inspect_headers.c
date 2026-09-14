#include <stdio.h>
#include "svdpi.h"
#include "vpi_user.h"
int main(void) {
  printf("PLI_INT32=%zu svLogic=%zu svBitVecVal=%zu svLogicVecVal=%zu\n",
    sizeof(PLI_INT32),sizeof(svLogic),sizeof(svBitVecVal),sizeof(svLogicVecVal));
  return sizeof(PLI_INT32)!=4;
}
