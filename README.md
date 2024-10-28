# PCIe_Scrambler
## 🔄 **Scrambler**
- **A Scrambler** is a method in communication systems to randomize data before transmission. Its purpose is to reduce predictable sequences in the data stream, which helps to prevent issues like electromagnetic interference (EMI) and signal distortion. Scramblers are used in many communicaton protocols such as PCI Express, SAS/SATA, USB, Bluetooth, etc. 
- **Scramblers** are implemented using LFSR (Linear Feedback Shift Register) which is pseudorandom number generator that implements certain polynomial that specifies the next state of the LFSR.

### 🔢 **PCIe GEN1 and GEN2 Scramblers**
The LFSR in PCIe GEN1 and GEN2  implements  The polynomial $$G(X) = (X^{16} + X^{5} + X^{4} + X^{3} + 1 )$$ more on [Linear Feedback Shift registers](https://www.youtube.com/watch?v=Ks1pw1X22y4&t)
![Scrambler Diagram](https://github.com/baselkelziye/PCIe_Scrambler/blob/main/images/scrambler_diagram.png?raw=true)

## 🛠️ Implementation Considerations
Since the LFSR advances 1 state per clock and in order to scramble 1 Byte of data in 250MHz speed we need a clock with 2GHZ speed which is impractical in FPGA, And Since PCIe GEN3 uses a 32 bit width LFSR it requires 8GHZ clock speed to scramble a byte of data. Further more our scramble shall be able to scramble 1,2 and 4 byte/s of data with one clock cycle in respect with the scrambling rules imposed by the PCIe Standart.
### 🔧 Implemented Solution
LFSR can be parallelized easily and we will use parallelized LFSR to scramble 1,2 and 4 byte/s of data in one clock cycle. For more information on paralleled LFSR please check this [website](http://outputlogic.com/?page_id=205) 
