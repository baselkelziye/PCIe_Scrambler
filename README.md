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

## 📜 Scrambling Rules

The following are the key scrambling rules imposed by the PCIe Standard:

1. The COM Symbol initializes the LFSR
2. The LFSR value is advanced eight serial shifts for each Symbol except the SKP. 
3. All data Symbols (D codes) except those within a Training Sequence Ordered Sets (e.g., TS1,TS2) and the Compliance Pattern are scrambled.
4. All special Symbols (K codes) are not scrambled. 
5. The initialized value of an LFSR seed (D0-D15) is FFFFh. Immediately after a COM exits the
Transmit LFSR, the LFSR on the Transmit side is initialized. Every time a COM enters the
Receive LFSR on any Lane of that Link, the LFSR on the Receive side is initialized.

Check out the [PCIe 2.0 Base Specification](https://community.intel.com/cipcp26785/attachments/cipcp26785/fpga-intellectual-property/8220/1/PCI_Express_Base_Specification_v20.pdf) for more information on scrambling rules.
