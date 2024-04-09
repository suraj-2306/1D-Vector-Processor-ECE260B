# Load design
set desdir 		"../../verilog_dualcore"
set libdir 		"/home/linux/ieng6/ee260bwi24/public/PDKdata"
set design 		"core"
set netlist 		"../../syn/core/${design}_2ns_4cycle.out.v"
set sdc 		"../../syn/core/constraints/${design}_pnr.sdc"
set best_timing_lib 	"$libdir/lib/tcbn65gplusbc.lib ../../latest_submodule_libraries/sram_w16_64_64bit_BC.lib ../../latest_submodule_libraries/sram_w16_160_160bit_BC.lib"
set worst_timing_lib 	"$libdir/lib/tcbn65gpluswc.lib ../../latest_submodule_libraries/sram_w16_64_64bit_WC.lib ../../latest_submodule_libraries/sram_w16_160_160bit_WC.lib"
set lef 		"$libdir/lef/tcbn65gplus_8lmT2.lef ../../latest_submodule_libraries/sram_w16_64_64bit.lef ../../latest_submodule_libraries/sram_w16_160_160bit.lef"
set best_captbl 	"$libdir/captbl/cln65g+_1p08m+alrdl_top2_cbest.captable"
set worst_captbl 	"$libdir/captbl/cln65g+_1p08m+alrdl_top2_cworst.captable"

# default settings
set init_pwr_net "VDD"
set init_gnd_net "VSS"

# default settings
set init_verilog "$netlist"
set init_design_netlisttype "Verilog"
set init_design_settop 1
set init_top_cell "$design"
set init_lef_file "$lef"

# MCMM setup
create_library_set -name WC_LIB -timing $worst_timing_lib
create_library_set -name BC_LIB -timing $best_timing_lib
create_rc_corner -name Cmax -cap_table $worst_captbl -T 125
create_rc_corner -name Cmin -cap_table $best_captbl -T -40
create_delay_corner -name WC -library_set WC_LIB -rc_corner Cmax
create_delay_corner -name BC -library_set BC_LIB -rc_corner Cmin
create_constraint_mode -name CON -sdc_file [list $sdc]
create_analysis_view -name WC_VIEW -delay_corner WC -constraint_mode CON
create_analysis_view -name BC_VIEW -delay_corner BC -constraint_mode CON
init_design -setup {WC_VIEW} -hold {BC_VIEW}

set_interactive_constraint_modes {CON}
setDesignMode -process 65

setMaxRouteLayer 7
