# PCIe_Scrambler
## 🔄 **Scrambler**
- **A Scrambler** is a method in communication systems to randomize data before transmission. Its purpose is to reduce predictable sequences in the data stream, which helps to prevent issues like electromagnetic interference (EMI) and signal distortion. Scramblers are used in many communicaton protocols such as PCI Express, SAS/SATA, USB, Bluetooth, etc. 
- **Scramblers** are implemented using LFSR (Linear Feedback Shift Register) which is pseudorandom number generator that implements certain polynomial that specifies the next state of the LFSR.

### 🔢 **PCIe GEN1 and GEN2 Scramblers**
The LFSR in PCIe GEN1 and GEN2  implements  The polynomial $$G(X) = (X^{16} + X^{5} + X^{4} + X^{3} + 1 )$$ 
![Scrambler Diagram](https://github.com/baselkelziye/PCIe_Scrambler/blob/main/images/scrambler_diagram.png?raw=true)
