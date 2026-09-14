`ifndef IEEE2017_LAB_SVH
`define IEEE2017_LAB_SVH
// X も不合格にする。即時assertは「今の値」を検査する。
`define CHECK(EXPR, MESSAGE) \
  begin \
    assert ((EXPR) === 1'b1) \
      else $fatal(1, "CHECK_FAIL %s [%s:%0d]", MESSAGE, `__FILE__, `__LINE__); \
    checks++; \
    $display("  OK: %s", MESSAGE); \
  end
`define DONE(ID) \
  begin \
    if ($test$plusargs("INJECT_FAIL")) $fatal(1, "INJECTED_FAILURE"); \
    $display("LAB_PASS %s checks=%0d", ID, checks); \
    $finish; \
  end
`endif
