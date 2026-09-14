#include "vpi_user.h"
static int changes=0;
static s_vpi_time callback_time={vpiSimTime,0,0,0};
static s_vpi_value callback_value={vpiIntVal,{0}};
static PLI_INT32 change_cb(p_cb_data data) {
  s_vpi_time now={vpiSimTime,0,0,0}; vpi_get_time(data->obj,&now); changes++;
  vpi_printf("VPI_CHANGE time=%u:%u value=%d\n",now.high,now.low,data->value->value.integer);
  return 0;
}
static PLI_INT32 start_cb(p_cb_data unused) {
  (void)unused;
  vpiHandle obj=vpi_handle_by_name("tb.target",NULL);
  if(!obj) {vpi_printf("VPI_FAILURE target unavailable\n"); vpi_control(vpiFinish,1); return 0;}
  s_cb_data cb={0}; cb.reason=cbValueChange; cb.cb_rtn=change_cb;
  cb.obj=obj; cb.time=&callback_time; cb.value=&callback_value;
  vpi_register_cb(&cb); return 0;
}
static PLI_INT32 count_call(PLI_BYTE8 *unused) {
  (void)unused; s_vpi_value value={0}; value.format=vpiIntVal; value.value.integer=changes;
  vpi_put_value(vpi_handle(vpiSysTfCall,NULL),&value,NULL,vpiNoDelay); return 0;
}
void register_lab_vpi(void) {
  s_vpi_systf_data fn={0}; fn.type=vpiSysFunc; fn.sysfunctype=vpiIntFunc;
  fn.tfname="$lab_callback_count"; fn.calltf=count_call; vpi_register_systf(&fn);
  s_cb_data cb={0}; cb.reason=cbStartOfSimulation; cb.cb_rtn=start_cb; vpi_register_cb(&cb);
}
void (*vlog_startup_routines[])(void)={register_lab_vpi,0};
