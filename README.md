# fpgaFM_matrix
Ground-up reimplementation of the DE10-Lite synthesizer

While technically successful in synthesizing audio signals, my initial attempt at a synthesizer for FPGA suffered
from a clumsy architecture wherein a peripheral I/O module was instantiated for each note that could be played on
the USB keyboard, with these peripherals updated with new frequencies each time the 'octave up' or 'octave down'
key was pressed. Generally, the structure was needlessly complicated and non-standard, and modules were too often
kludged together into odd interrelations which made it difficult to completely isolate their functions. 
The redesign is additionally influenced by concepts encountered as I work through Pong P. Chu's 'FPGA Prototyping
by SystemVerilog Example', 'FPGA-Based Implementation of Signal Processing Systems' by Woods, McAllister,
Lightbody & Yi, and Gary Stringham's 'Hardware/Firmware Interface Design: Best Practices for Improving Embedded
Systems Development'.

I'm currently solidifying an interim, graphics-free interface through which a user can access and modify parameters
and routing, with documentation to follow.
