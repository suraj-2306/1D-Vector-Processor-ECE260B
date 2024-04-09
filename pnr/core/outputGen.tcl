streamOut ${design}.gds2 -merge {../../latest_submodule_libraries/sram_w16_64_64bit.gds2 ../../latest_submodule_libraries/sram_w16_160_160bit.gds2}
write_lef_abstract -stripePin -PGPinLayers {7} -extractBlockPGPinLayers {7} ${design}.lef -specifyTopLayer 7
defOut -netlist -routing ${design}.def
saveNetlist ${design}.pnr.v

setAnalysisMode -setup
set_analysis_view -setup WC_VIEW -hold WC_VIEW
do_extract_model -view WC_VIEW -format dotlib ${design}_WC.lib
write_sdf -view WC_VIEW ${design}_WC.sdf

setAnalysisMode -hold
set_analysis_view -setup BC_VIEW -hold BC_VIEW
do_extract_model -view BC_VIEW -format dotlib ${design}_BC.lib
write_sdf -view BC_VIEW ${design}_BC.sdf
