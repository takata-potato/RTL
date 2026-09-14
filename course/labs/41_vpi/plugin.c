#include <string.h>
#include "vpi_user.h"
static PLI_INT32 peek_call(PLI_BYTE8 *user) {
  (void)user;
  vpiHandle call=vpi_handle(vpiSysTfCall,NULL);
  vpiHandle args=vpi_iterate(vpiArgument,call);
  vpiHandle arg=args?vpi_scan(args):NULL;
  s_vpi_value name={0},value={0};
  name.format=vpiStringVal;
  if(!arg) { vpi_printf("VPI_FAILURE missing argument\n"); vpi_control(vpiFinish,1); return 0; }
  vpi_get_value(arg,&name);
  vpiHandle signal=vpi_handle_by_name(name.value.str,NULL);
  if(args) vpi_free_object(args);
  if(!signal) { vpi_printf("VPI_FAILURE unknown signal\n"); vpi_control(vpiFinish,1); return 0; }
  value.format=vpiIntVal; vpi_get_value(signal,&value);
  vpi_printf("VPI name=%s width=%d value=%d\n",vpi_get_str(vpiFullName,signal),vpi_get(vpiSize,signal),value.value.integer);
  vpi_put_value(call,&value,NULL,vpiNoDelay);
  return 0;
}
void register_lab_vpi(void) {
  s_vpi_systf_data fn={0};
  fn.type=vpiSysFunc; fn.sysfunctype=vpiIntFunc;
  fn.tfname="$lab_peek"; fn.calltf=peek_call;
  vpi_register_systf(&fn);
}
void (*vlog_startup_routines[])(void)={register_lab_vpi,0};
