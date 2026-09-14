#include "vpi_user.h"
#include "sv_vpi_user.h"
static int successes=0;
static PLI_INT32 assertion_cb(PLI_INT32 reason,p_vpi_time time,vpiHandle assertion,
                             p_vpi_attempt_info info,PLI_BYTE8 *user) {
  (void)reason;(void)time;(void)assertion;(void)info;(void)user; successes++; return 0;
}
static PLI_INT32 initialized(p_cb_data unused) {
  (void)unused;
  vpiHandle assertion=vpi_handle_by_name("tb.a_ready",NULL);
  if(!assertion) {vpi_printf("VPI_FAILURE assertion unavailable\n"); vpi_control(vpiFinish,1); return 0;}
  if(!vpi_register_assertion_cb(assertion,cbAssertionSuccess,assertion_cb,NULL))
    vpi_printf("VPI_FAILURE assertion callback registration\n");
  return 0;
}
static PLI_INT32 count_call(PLI_BYTE8 *unused) {
  (void)unused; s_vpi_value v={0}; v.format=vpiIntVal; v.value.integer=successes;
  vpi_put_value(vpi_handle(vpiSysTfCall,NULL),&v,NULL,vpiNoDelay); return 0;
}
void register_lab_vpi(void) {
  s_vpi_systf_data fn={0}; fn.type=vpiSysFunc; fn.sysfunctype=vpiIntFunc;
  fn.tfname="$lab_assertion_count"; fn.calltf=count_call; vpi_register_systf(&fn);
  s_cb_data cb={0}; cb.reason=cbAssertionSysInitialized; cb.cb_rtn=initialized; vpi_register_cb(&cb);
}
void (*vlog_startup_routines[])(void)={register_lab_vpi,0};
