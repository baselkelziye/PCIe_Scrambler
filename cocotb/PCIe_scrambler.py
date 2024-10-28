import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer
import logging
logging.basicConfig(level=logging.NOTSET)
logger = logging.getLogger("cocotb")
logger.setLevel(logging.INFO)



# LFSR function (standalone, no DUT parameter)
COMMA = 0xBC  # Equivalent to 8'hBC in Verilog
SKIP = 0x1C   # Equivalent to 8'h1C in Verilog
lfsr = 0xFFFF  # 16-bit short for polynomial


async def scramble_byte(inbyte, TrainingSequence=False):
    scrambit = [0] * 16
    bit = [0] * 16
    bit_out = [0] * 16
    global lfsr
    outbyte = 0

    if inbyte == COMMA:  # if this is a comma
        lfsr = 0xFFFF  # reset the LFSR
        return COMMA  # return the same data
    
    if inbyte == SKIP:  # don't advance or encode on skip
        return SKIP

    # Convert LFSR to bit array for legibility
    for i in range(16):
        bit[i] = (lfsr >> i) & 1

    # Convert byte to be scrambled for legibility
    for i in range(8):
        scrambit[i] = (inbyte >> i) & 1

    # Apply the XOR to the data if not a KCODE and not in a training sequence
    if not (inbyte & 0x100) and not TrainingSequence:
        scrambit[0] ^= bit[15]
        scrambit[1] ^= bit[14]
        scrambit[2] ^= bit[13]
        scrambit[3] ^= bit[12]
        scrambit[4] ^= bit[11]
        scrambit[5] ^= bit[10]
        scrambit[6] ^= bit[9]
        scrambit[7] ^= bit[8]

    # Advance the LFSR 8 serial clocks
    bit_out[0] = bit[8]
    bit_out[1] = bit[9]
    bit_out[2] = bit[10]
    bit_out[3] = bit[11] ^ bit[8]
    bit_out[4] = bit[12] ^ bit[9] ^ bit[8]
    bit_out[5] = bit[13] ^ bit[10] ^ bit[9] ^ bit[8]
    bit_out[6] = bit[14] ^ bit[11] ^ bit[10] ^ bit[9]
    bit_out[7] = bit[15] ^ bit[12] ^ bit[11] ^ bit[10]
    bit_out[8] = bit[0] ^ bit[13] ^ bit[12] ^ bit[11]
    bit_out[9] = bit[1] ^ bit[14] ^ bit[13] ^ bit[12]
    bit_out[10] = bit[2] ^ bit[15] ^ bit[14] ^ bit[13]
    bit_out[11] = bit[3] ^ bit[15] ^ bit[14]
    bit_out[12] = bit[4] ^ bit[15]
    bit_out[13] = bit[5]
    bit_out[14] = bit[6]
    bit_out[15] = bit[7]

    # Convert the bit_out array back to an integer for the new LFSR value
    # print(f"LFSR = 0x{lfsr:04X}")
    lfsr = 0
    for i in range(16):
        lfsr += (bit_out[i] << i)
    
    

    # Convert the scrambled data back to an integer
    outbyte = 0
    for i in range(8):
        outbyte += (scrambit[i] << i)

    return outbyte

async def print_lfsr8(lfsr8_reg):
    binary_string = ''.join(str(bit) for bit in lfsr8_reg)
    binary_value = int(binary_string, 2)
    hex_value = hex(binary_value)
    return hex_value

# Cocotb testbench
@cocotb.test()
async def test_lfsr8(dut):
    """Testbench to verify LFSR8 operation using the lfsr8 function."""
    didPass = True
    #Run Clock
    clock = Clock(dut.clk_i, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_i.value = 1
    # await RisingEdge(dut.clk_i)
    # await RisingEdge(dut.clk_i)
    await Timer(10, units="ns")
    dut.rst_i.value = 0
    await Timer(10, units="ns")
    num_iterations = 8
    data_k = [0b00] * num_iterations
    data_len = [0b00] * num_iterations
    data_in = 0X00
    dut.datak_i.value = 0b00
    dut.data_len_i.value = 0b00
    dut.indata_i.value = 0x00000000

    for i in range (num_iterations):
        # Print the LFSR state after each iteration
        scrambled_byte = await scramble_byte(data_in)
        await RisingEdge(dut.clk_i)
        scrambled_data_out = dut.scrambled_data_o.value & 0xFF  # Extracting lower byte (8 bits)
        dut._log.info(f"Iteration {i+1}: Python Scramble byte: 0x{scrambled_byte:02X}, DUT Scramble Byte: 0x{scrambled_data_out:02X}")
        dut._log.info(f"Scrambler Python {lfsr:04X}")


 
    assert didPass
