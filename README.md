# Vector Dot Product Implementation on FPGA

A hardware implementation of vector dot product computation using a Multiply-Accumulate (MAC) unit on the Basys3 FPGA board.

##  Overview

This project implements the dot product calculation of two 4-element vectors using reusable MAC (Multiply-Accumulate) units. The design takes two input vectors A and B, each containing four 8-bit positive integers, and computes:

**Dot Product = Σ(A[i] × B[i])** for i = 0 to 3

##  Features

- **Reusable MAC Unit**: Efficient multiply-accumulate operations
- **Vector Input Handling**: Support for 4-element vectors with 8-bit elements
- **Multiple Display Modes**: 
  - Binary output on LEDs
  - Hexadecimal display on 7-segment displays
- **Time-Multiplexed Display**: Smooth 7-segment display cycling (60Hz-1kHz refresh)
- **Reset Functionality**: System reset with visual feedback
- **Active-Low Design**: Compatible with Basys3 board conventions

##  Hardware Interface

### Input Mapping
- **SW[7:0]**: 8-bit data input for vector elements
- **SW[9:8]**: 2-bit index selector (00→index 0, 01→index 1, 10→index 2, 11→index 3)
- **SW[13]**: Write enable for Vector A
- **SW[14]**: Write enable for Vector B  
- **SW[15]**: Read enable
- **BTNC**: System reset button

### Output Mapping
- **LED[15:0]**: Binary representation of dot product result
- **7-Segment Display**: Hexadecimal representation with time-multiplexing
  - **seg[6:0]**: Active-low segment outputs (a-g)
  - **an[3:0]**: Active-low digit enables
  - **dp**: Decimal point control

##  Getting Started

### Prerequisites
- Xilinx Vivado (for synthesis and implementation)
- Basys3 FPGA Development Board
- USB cable for programming

### Files Structure
```
├── dot_product.v          # Main design file
|── testbench.v            # Simulation testbench
|── basys3.xdc            # Pin constraints for Basys3
├──dot_product.bit       # Pre-compiled bitstream
└── README.md
```

### Usage Instructions

1. **Loading Vectors**:
   - Set SW[13] high to enable Vector A writing
   - Use SW[9:8] to select element index (0-3)
   - Set SW[7:0] to desired 8-bit value
   - Repeat for all 4 elements of Vector A
   - Set SW[14] high to enable Vector B writing
   - Repeat the process for Vector B

2. **Computing Dot Product**:
   - Set SW[15] high to enable read mode
   - The dot product will be automatically calculated and displayed

3. **Reset System**:
   - Press BTNC to reset all registers
   - Display shows "-rSt" for 5 seconds during reset

### Example Calculation

**Input:**
- Vector A: [11, 13, 14, 15]
- Vector B: [10, 9, 8, 7]

**Calculation:**
```
Dot Product = (11×10) + (13×9) + (14×8) + (15×7)
            = 110 + 117 + 112 + 105
            = 444 (decimal)
            = 1BC (hexadecimal)
```

## Synthesis Results

### Resource Utilization
- **LUTs**: 506 total (LUT6: 152, LUT2: 125, LUT3: 85, etc.)
- **Flip-Flops**: 75 used (0.18% utilization)
- **Carry Logic**: 71 CARRY4 primitives
- **DSPs**: 0 (pure LUT-based implementation)
- **Memory**: 32 distributed RAM elements

### Timing
- **Clock Frequency**: Configurable via clock divider
- **Display Refresh**: 1-16ms period (60Hz-1kHz)
- **Reset Duration**: 5 seconds

##  Testing

The design has been verified through:
- **Behavioral Simulation**: Comprehensive testbench coverage
- **Hardware Testing**: Successfully programmed and tested on Basys3
- **Functional Verification**: Multiple vector combinations tested

Run simulation:
```bash
# In Vivado TCL Console
run_simulation
```

##  Repository Contents

- `dot_product.v` - Main Verilog design file
- `testbench.v` - Simulation testbench
- `basys3.xdc` - Constraint file for Basys3 board
- `dot_product.bit` - Pre-compiled bitstream file

##  Contributing

This project was developed as part of COL215 - Digital Logic and System Design course at IIT Delhi.


