# Extracting commands from GUI log
# Input/Output pins referenced from netlist aes_cipher_top.v in designdata
# Command manually tweaked for completeness
#
# Step 1: Input pins, on the left, clockwise from the bottom
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixedPin True -pinWidth 0.1 -pinDepth 0.6 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType start -spacing 4 -start 0.0 500.0 -pin {clk reset inst[0] inst[1] inst[2] inst[3] inst[4] inst[5] inst[6] inst[7] inst[8] inst[9] inst[10] inst[11] inst[12] inst[13] inst[14] inst[15] inst[16] inst[17] inst[18] mem_in[0] mem_in[1] mem_in[2] mem_in[3] mem_in[4] mem_in[5] mem_in[6] mem_in[7] mem_in[8] mem_in[9] mem_in[10] mem_in[11] mem_in[12] mem_in[13] mem_in[14] mem_in[15] mem_in[16] mem_in[17] mem_in[18] mem_in[19] mem_in[20] mem_in[21] mem_in[22] mem_in[23] mem_in[24] mem_in[25] mem_in[26] mem_in[27] mem_in[28] mem_in[29] mem_in[30] mem_in[31] mem_in[32] mem_in[33] mem_in[34] mem_in[35] mem_in[36] mem_in[37] mem_in[38] mem_in[39] mem_in[40] mem_in[41] mem_in[42] mem_in[43] mem_in[44] mem_in[45] mem_in[46] mem_in[47] mem_in[48] mem_in[49] mem_in[50] mem_in[51] mem_in[52] mem_in[53] mem_in[54] mem_in[55] mem_in[56] mem_in[57] mem_in[58] mem_in[59] mem_in[60] mem_in[61] mem_in[62] mem_in[63]}
setPinAssignMode -pinEditInBatch false

# Step 2: Output pins, on the right, anti-clockwise from the bottom
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixedPin True -pinWidth 0.1 -pinDepth 0.6 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 4 -spreadType start -spacing 4 -start 780.0 0.0 -pin {out[0] out[1] out[2] out[3] out[4] out[5] out[6] out[7] out[8] out[9] out[10] out[11] out[12] out[13] out[14] out[15] out[16] out[17] out[18] out[19] out[20] out[21] out[22] out[23] out[24] out[25] out[26] out[27] out[28] out[29] out[30] out[31] out[32] out[33] out[34] out[35] out[36] out[37] out[38] out[39] out[40] out[41] out[42] out[43] out[44] out[45] out[46] out[47] out[48] out[49] out[50] out[51] out[52] out[53] out[54] out[55] out[56] out[57] out[58] out[59] out[60] out[61] out[62] out[63] out[64] out[65] out[66] out[67] out[68] out[69] out[70] out[71] out[72] out[73] out[74] out[75] out[76] out[77] out[78] out[79] out[80] out[81] out[82] out[83] out[84] out[85] out[86] out[87] out[88] out[89] out[90] out[91] out[92] out[93] out[94] out[95] out[96] out[97] out[98] out[99] out[100] out[101] out[102] out[103] out[104] out[105] out[106] out[107] out[108] out[109] out[110] out[111] out[112] out[113] out[114] out[115] out[116] out[117] out[118] out[119] out[120] out[121] out[122] out[123] out[124] out[125] out[126] out[127] out[128] out[129] out[130] out[131] out[132] out[133] out[134] out[135] out[136] out[137] out[138] out[139] out[140] out[141] out[142] out[143] out[144] out[145] out[146] out[147] out[148] out[149] out[150] out[151] out[152] out[153] out[154] out[155] out[156] out[157] out[158] out[159]}
setPinAssignMode -pinEditInBatch false

getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixedPin True -pinWidth 0.1 -pinDepth 0.6 -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side Right -layer 3 -spreadType start -spacing 4 -start 920.0 300 -pin {sum_in[0] sum_in[1] sum_in[2] sum_in[3] sum_in[4] sum_in[5] sum_in[6] sum_in[7] sum_in[8] sum_in[9] sum_in[10] sum_in[11] sum_in[12] sum_in[13] sum_in[14] sum_in[15] sum_in[16] sum_in[17] sum_in[18] sum_in[19] sum_in[20] sum_in[21] sum_in[22] sum_in[23] sfp_sum_fifo_rd sum_out[0] sum_out[1] sum_out[2] sum_out[3] sum_out[4] sum_out[5] sum_out[6] sum_out[7] sum_out[8] sum_out[9] sum_out[10] sum_out[11] sum_out[12] sum_out[13] sum_out[14] sum_out[15] sum_out[16] sum_out[17] sum_out[18] sum_out[19] sum_out[20] sum_out[21] sum_out[22] sum_out[23]}
setPinAssignMode -pinEditInBatch false

saveDesign floor_power_pin.enc
