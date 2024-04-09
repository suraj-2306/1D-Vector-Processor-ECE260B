# Floorplan
floorPlan -s 900 1200 10.0 10.0 10.0 10.0
#createPlaceBlockage -box [list 10 90 40 170]
#createPlaceBlockage -box [list 45 90 75 170]
#createPlaceBlockage -box [list 185 90 215 170]
#createPlaceBlockage -box [list 220 90 250 170]

setObjFPlanBox Instance kmem_instance 51.218 881.5915 201.218 1161.5915
setObjFPlanBox Instance qmem_instance 51.22 546.1355 201.22 826.1355
setObjFPlanBox Instance psum_mem_instance 113.4255 48.741 783.4255 198.741

#setObjFPlanBox Instance qmem_instance 50 400 330 660
#setObjFPlanBox Instance kmem_instance 50 800 330 1060
#setObjFPlanBox Instance psum_mem_instance 150 125 830 285

setObjFPlanBox Module mac_array_instance 238.000 875.800 869.507 1174.600
setObjFPlanBox Module ofifo_inst 244.200 681.400 869.507 850.600
setObjFPlanBox Module sfp_instance 239.951 233.200 871.400 650.800

flipOrRotateObject -rotate R90 -name qmem_instance
flipOrRotateObject -flip MY -name qmem_instance
flipOrRotateObject -rotate R90 -name kmem_instance
flipOrRotateObject -flip MY -name kmem_instance

flipOrRotateObject -flip MY -name psum_mem_instance
flipOrRotateObject -flip MX -name psum_mem_instance

addHaloToBlock {3 3 3 3} qmem_instance
addHaloToBlock {3 3 3 3} kmem_instance
addHaloToBlock {3 3 3 3} psum_mem_instance

timeDesign -preplace -prefix preplace

globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose

addRing -type block_rings -nets {VSS VDD} -around each_block -spacing {top 0.5 bottom 0.5 left 0.5 right 0.5} -width {top 1 bottom 1 left 1 right 1} -layer {top M3 bottom M3 left M2 right M2}

#addRing -spacing {top 2 bottom 2 left 2 right 2} -width {top 3 bottom 3 left 3 right 3} -layer {top M1 bottom M1 left M2 right M2} -center 1 -type core_rings -nets {VSS VDD}

globalNetConnect VDD -type pgpin -pin VDD -sinst qmem_instance -verbose -override
globalNetConnect VSS -type pgpin -pin VSS -sinst qmem_instance -verbose -override
globalNetConnect VDD -type pgpin -pin VDD -sinst kmem_instance -verbose -override
globalNetConnect VSS -type pgpin -pin VSS -sinst kmem_instance -verbose -override
globalNetConnect VDD -type pgpin -pin VDD -sinst psum_mem_instance -verbose -override
globalNetConnect VSS -type pgpin -pin VSS -sinst psum_mem_instance -verbose -override

#setAddStripeMode -break_at {block_ring}

addStripe -nets {VDD VSS} -layer M7 -direction horizontal -width 2 -spacing 6 -number_of_sets 40 -start_from left -start 20 -stop 1180

sroute
