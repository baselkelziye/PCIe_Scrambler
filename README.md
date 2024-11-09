# PCIe_Scrambler
## 🔄 **Scrambler**
- **A Scrambler** is a method in communication systems to randomize data before transmission. Its purpose is to reduce predictable sequences in the data stream, which helps to prevent issues like electromagnetic interference (EMI) and signal distortion. Scramblers are used in many communicaton protocols such as PCI Express, SAS/SATA, USB, Bluetooth, etc. 
- **Scramblers** are implemented using LFSR (Linear Feedback Shift Register) which is pseudorandom number generator that implements certain polynomial that specifies the next state of the LFSR.

### 🔢 **PCIe GEN1 and GEN2 Scramblers**
The LFSR in PCIe GEN1 and GEN2  implements  The polynomial $$G(X) = (X^{16} + X^{5} + X^{4} + X^{3} + 1 )$$ more on [Linear Feedback Shift registers](https://www.youtube.com/watch?v=Ks1pw1X22y4&t)
![Scrambler Diagram](https://github.com/baselkelziye/PCIe_Scrambler/blob/main/images/scrambler_diagram.png?raw=true)

## 🛠️ Implementation Considerations
Since the LFSR advances 1 state per clock and in order to scramble 1 Byte of data the LFSR shall be advanced 8 times, To be able to scramble a byte of data in 250MHz speed we need a clock with 2GHZ speed which is impractical in FPGA. Further more our scramble shall be able to scramble 1,2 and 4 byte/s of data with one clock cycle in respect with the scrambling rules imposed by the PCIe Standart.
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
## 📜  Documentation 
The Inputs and Output Ports for the Scrambler Component, Each input is postfixed with "_i" and the output with "_o"

| Inputs | Outputs|
|--------|--------|
|clk_i| ----------------|
|rst_i| ----------------|
|datak_i| datak_o  |
|data_len_i| data_len_o|
|indata_i| scrambled_data_o|

Inputs Explanations:
At times, we may need to scramble 1 byte, 2 bytes, or 4 bytes. The input size is fixed at 32 bits, and the variable `data_len_i` is used to specify the desired size.

| data_len_i | Scramble The|
|------------|----------------------|
|**00**     | indata_i[7:0] is Valid|
|**01**     | indata_i[15:0] is Valid|
|**10**     | indata_i[31:0] is valid|

Now For the `datak_i` input

|datak_i | Control Byte|
|--------|-------------|
|**0001**| indata_i[7:0] is K Code|
|**0010**| indata_i[15:8] is K Code|
|**0100**| indata_i[23:16] is K Code|
|**1000**| indata_i[31:24] is K Code|
- `scrambler_top.v`: Wrapper module.
- `lfsr8.v`: Parallel LFSR, Takes the state as input, and advances the lfsr8 (if required)
- `scramble_data.v`: Scrambling Block, Scrambles according the specs
- `pcie_encodings.vh`: Verilog Header file for encodings of the PCIe Symbols.

### The design logic works as follows:

We use combinational logic to calculate the next state of the LFSR. Each LFSR8 module handles a specific byte of indata_i (e.g., LFSR8_1 processes the first byte indata_i[7:0], LFSR8_2 the second, and so on). Each LFSR8 generates its own next state and passes it forward to the subsequent LFSR8.

For instance, if an SKP symbol is detected at LFSR8_2, it outputs its input directly, and LFSR8_3 uses the latest output from LFSR8_2. With a maximum input of 4 bytes, we deploy 4 LFSR8 units. The final output is selected based on data_len: if only 1 byte of input data is valid, then LFSR8_1 is selected, and so forth.
A high level overview of the system is shown below:

![Circuit Diagram](https://github.com/baselkelziye/PCIe_Scrambler/blob/main/images/scrambler_high_level.png)
## 🧪 Testing and Verification
Given the Following meanings:
D =  1 Byte of Data
X = Don't Care
SKP = SKIP Symbol
COM = COMMA Symbol
The following Wave Diagram Issues the following Input Sequences:

|   | data_len_i| datak_i| indata_i|
|---|-----------|--------|---------|
|Posedge clk_i|  **2'b10**   | **4'b0_0_0_1**| **D_D_D_COM**|
|Posedge clk_i|  **2'b10**   | **4'b0_1_1_1**| **D_SKP_SKP_SKP**|
|Posedge clk_i|  **2'b00**   | **4'b0_0_0_0**| **X_X_X_D**|
|Posedge clk_i|  **2'b10**   | **4'b0_0_1_0**| **D_D_COM_D**|
|Posedge clk_i|  **2'b01**   | **4'b0_0_0_0**| **X_X_D_D**|

![Wavedrom Diagram](https://github.com/baselkelziye/PCIe_Scrambler/blob/main/images/wavedrom.png)

The initial 16-bit values of the LFSR for the first 128 LFSR advances following a reset are listed
below: 

|         | 0, 8  | 1, 9  | 2, A  | 3, B  |  4, C | 5, D  | 6, E  | 7, F |     
|---------|-------|-------|-------|-------|-------|-------|-------|-------
| **00**  | FFFF  | E817  | 0328  | 284B  | 4DE8  | E755  | 404F  | 4140  |
| **08**  | 4E79  | 761E  | 1466  | 6574  | 7DBD  | B6E5  | FDA6  | B165  |
| **10**  | 7D09  | 02E5  | E572  | 673D  | 34CF  | CB54  | 4743  | 4DEF  |
| **18**  | E055  | 40E0  | EE40  | 54BE  | B334  | 2C7B  | 7D0C  | 07E5  |
| **20**  | E5AF  | BA3D  | 248A  | 8DC4  | D995  | 85A1  | BD5D  | 4425  |
| **28**  | 2BA4  | A2A3  | B8D2  | CBF8  | EB43  | 5763  | 6E7F  | 773E  |
| **30**  | 345F  | 5B54  | 5853  | 5F18  | 14B7  | B474  | 6CD4  | DC4C  |
| **38**  | 5C7C  | 70FC  | F6F0  | E6E6  | F376  | 603B  | 3260  | 64C2  | 
| **40**  | CB84  | 9743  | 5CBF  | B3FC  | E47B  | 6E04  | 0C3E  | 3F2C  |
| **48**  | 29D7  | D1D1  | C069  | 7BC0  | CB73  | 6043  | 4A60  | 6FFA  |
| **50**  | F207  | 1102  | 01A9  | A939  | 2351  | 566B  | 6646  | 4FF6  |
| **58**  | F927  | 3081  | 85B0  | AC5D  | 478C  | 82EF  | F3F2  | E43B  |
| **60**  | 2E04  | 027E  | 7E72  | 79AE  | A501  | 1A7D  | 7F2A  | 2197  |
| **68**  | 9019  | 0610  | 1096  | 9590  | 8FCD  | D0E7  | F650  | 46E6  |
| **70**  | E8D6  | C228  | 3AB2  | B70A  | 129F  | 9CE2  | FC3C  | 2B5C  |
| **78**  | 5AA3  | AF6A  | 70C7  | CDF0  | E3D5  | C0AB  | B9C0  | D9C1  |

An 8-bit value of 0 repeatedly encoded with the LFSR after reset produces the following consecutive
8-bit values: 

|         |   00  |   01  |   02  |   03  |   04  |   05  |   06  |   07  |   08  |   09  |   0A  |   0B  |   0C  |   0D  |   0E  |   0F  |
|---------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
| **00**  | FF    | 17    | C0    | 14    | B2    | E7    | 02    | 82    | 72    | 6E    | 28    | A6    | BE    | 6D    | BF    | 8D    |
| **10**  | BE    | 40    | A7    | E6    | 2C    | D3    | E2    | B2    | 07    | 02    | 77    | 2A    | CD    | 34    | BE    | E0    |
| **20**  | A7    | 5D    | 24    | B1    | 9B    | A1    | BD    | 22    | D4    | 45    | 1D    | D3    | D7    | EA    | 76    | EE    |
| **30**  | 2C    | DA    | 1A    | FA    | 28    | 2D    | 36    | 3B    | 3A    | 0E    | 6F    | 67    | CF    | 06    | 4C    | 26    |
| **40**  | D3    | E9    | 3A    | CD    | 27    | 76    | 30    | FC    | 94    | 8B    | 03    | DE    | D3    | 06    | 52    | F6    |
| **50**  | 4F    | 88    | 80    | 95    | C4    | 6A    | 66    | F2    | 9F    | 0C    | A1    | 35    | E2    | 41    | CF    | 27    |
| **60**  | 74    | 40    | 7E    | 9E    | A5    | 58    | FE    | 84    | 09    | 60    | 08    | A9    | F1    | 0B    | 6F    | 62    |
| **70**  | 17    | 43    | 5C    | ED    | 48    | 39    | 3F    | D4    | 5A    | F5    | 0E    | B3    | C7    | 03    | 9D    | 9B    |
| **80**  | 8B    | 0D    | 8E    | 5C    | 33    | 98    | 77    | AE    | 2D    | AC    | 0B    | 3E    | DA    | 0B    | 42    | 7A    |
| **90**  | 7C    | D1    | CF    | A8    | 1C    | 12    | EE    | 41    | C2    | 3F    | 38    | 7A    | 0D    | 69    | F4    | 01    |
| **A0**  | DA    | 31    | 72    | C5    | A0    | D7    | 93    | 0E    | DC    | AF    | A4    | 55    | E7    | F0    | 72    | 16    |
| **B0**  | 68    | D5    | 38    | 84    | DD    | 00    | CD    | 18    | 9E    | CA    | 30    | 59    | 4C    | 75    | 1B    | 77    |
| **C0**  | 31    | C5    | ED    | CF    | 91    | 64    | 6E    | 3D    | FE    | E8    | 29    | 04    | CF    | 6C    | FC    | C4    |
| **D0**  | 0B    | 5E    | DA    | 62    | BA    | 5B    | AB    | DF    | 59    | B7    | 7D    | 37    | 5E    | E3    | 1A    | C6    |
| **E0**  | 88    | 14    | F5    | 4F    | 8B    | C8    | 56    | CB    | D3    | 10    | 42    | 63    | 04    | 8A    | B4    | F7    |
| **F0**  | 84    | 01    | A0    | 01    | 83    | 49    | 67    | EE    | 3E    | 2A    | 8B    | A4    | 76    | AF    | 14    | D5    |
| **100** | 4F    | AC    | 60    | B6    | 79    | D6    | 62    | B7    | 43    | E7    | E5    | 2A    | 40    | 2C    | 6E    | 7A    |
| **110** | 56    | 61    | 63    | 20    | 6A    | 97    | 4A    | 38    | 05    | E5    | DD    | 68    | 0D    | 78    | 4C    | 53    |
| **120** | 8B    | D6    | 86    | 57    | B2    | AA    | 1A    | 80    | 18    | DC    | BA    | FC    | 03    | A3    | 4B    | 30    |

## 📋✨ To Do ✨📋
- ✅ TS1 and TS2 Are scrambled in this implementation, these symbols shall not be scrambled.
- Add and verify the Descrambler circuit
- support for PCIe GEN3+ Scrambler 
- More robust verification
- adding tests using cocotb framework
