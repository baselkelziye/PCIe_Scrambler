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
lfsr_gen3 = 0x1DBFBC
clock_period = 10
debug_on = 1

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


def set_bit(var, bit, val):
    """Set a specific bit to a given value asynchronously."""
    return var | ((val & 1) << bit)

def get_bit(var, bit):
    """Get the value of a specific bit asynchronously."""
    return (var >> bit) & 1

async def calc_next_lfsr():
    """Calculate the next LFSR value asynchronously using the global lfsr_gen3."""
    global lfsr_gen3
    next_lfsr = 0

    next_lfsr = set_bit(next_lfsr, 22, get_bit(lfsr_gen3, 14) ^ get_bit(lfsr_gen3, 16) ^ get_bit(lfsr_gen3, 18) ^ 
                                      get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 21) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr, 21, get_bit(lfsr_gen3, 13) ^ get_bit(lfsr_gen3, 15) ^ get_bit(lfsr_gen3, 17) ^ 
                                      get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 21))
    next_lfsr = set_bit(next_lfsr, 20, get_bit(lfsr_gen3, 12) ^ get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 21))
    next_lfsr = set_bit(next_lfsr, 19, get_bit(lfsr_gen3, 11) ^ get_bit(lfsr_gen3, 18) ^ get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr, 18, get_bit(lfsr_gen3, 10) ^ get_bit(lfsr_gen3, 17) ^ get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 21))
    next_lfsr = set_bit(next_lfsr, 17, get_bit(lfsr_gen3,  9) ^ get_bit(lfsr_gen3, 16) ^ get_bit(lfsr_gen3, 18) ^ 
                                      get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr, 16, get_bit(lfsr_gen3,  8) ^ get_bit(lfsr_gen3, 15) ^ get_bit(lfsr_gen3, 17) ^ 
                                      get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 21) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr, 15, get_bit(lfsr_gen3,  7) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr, 14, get_bit(lfsr_gen3,  6) ^ get_bit(lfsr_gen3, 21))
    next_lfsr = set_bit(next_lfsr, 13, get_bit(lfsr_gen3,  5) ^ get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr, 12, get_bit(lfsr_gen3,  4) ^ get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 21) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr, 11, get_bit(lfsr_gen3,  3) ^ get_bit(lfsr_gen3, 18) ^ get_bit(lfsr_gen3, 20) ^ 
                                      get_bit(lfsr_gen3, 21) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr, 10, get_bit(lfsr_gen3,  2) ^ get_bit(lfsr_gen3, 17) ^ get_bit(lfsr_gen3, 19) ^ 
                                      get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 21) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr,  9, get_bit(lfsr_gen3,  1) ^ get_bit(lfsr_gen3, 16) ^ get_bit(lfsr_gen3, 18) ^ 
                                      get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 21))
    next_lfsr = set_bit(next_lfsr,  8, get_bit(lfsr_gen3,  0) ^ get_bit(lfsr_gen3, 15) ^ get_bit(lfsr_gen3, 17) ^ 
                                      get_bit(lfsr_gen3, 18) ^ get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 20))
    next_lfsr = set_bit(next_lfsr,  7, get_bit(lfsr_gen3, 17) ^ get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 21))
    next_lfsr = set_bit(next_lfsr,  6, get_bit(lfsr_gen3, 16) ^ get_bit(lfsr_gen3, 18) ^ get_bit(lfsr_gen3, 19) ^ 
                                      get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr,  5, get_bit(lfsr_gen3, 15) ^ get_bit(lfsr_gen3, 17) ^ get_bit(lfsr_gen3, 18) ^ 
                                      get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 21) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr,  4, get_bit(lfsr_gen3, 17))
    next_lfsr = set_bit(next_lfsr,  3, get_bit(lfsr_gen3, 16))
    next_lfsr = set_bit(next_lfsr,  2, get_bit(lfsr_gen3, 15) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr,  1, get_bit(lfsr_gen3, 16) ^ get_bit(lfsr_gen3, 18) ^ get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 22))
    next_lfsr = set_bit(next_lfsr,  0, get_bit(lfsr_gen3, 15) ^ get_bit(lfsr_gen3, 17) ^ get_bit(lfsr_gen3, 19) ^ 
                                      get_bit(lfsr_gen3, 21) ^ get_bit(lfsr_gen3, 22))
    lfsr_gen3 = next_lfsr  # Update the global LFSR
    return next_lfsr

async  def scramble_gen3(data_in):
    """Scramble a byte, given the current LFSR value."""

    data_out = 0
    data_out = set_bit(data_out, 7, get_bit(data_in, 7) ^ get_bit(lfsr_gen3, 15) ^ get_bit(lfsr_gen3, 17) ^ 
                                get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 21) ^ get_bit(lfsr_gen3, 22))
    data_out = set_bit(data_out, 6, get_bit(data_in, 6) ^ get_bit(lfsr_gen3, 16) ^ get_bit(lfsr_gen3, 18) ^ get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 22))
    data_out = set_bit(data_out, 5, get_bit(data_in, 5) ^ get_bit(lfsr_gen3, 17) ^ get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 21))
    data_out = set_bit(data_out, 4, get_bit(data_in, 4) ^ get_bit(lfsr_gen3, 18) ^ get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 22))
    data_out = set_bit(data_out, 3, get_bit(data_in, 3) ^ get_bit(lfsr_gen3, 19) ^ get_bit(lfsr_gen3, 21))
    data_out = set_bit(data_out, 2, get_bit(data_in, 2) ^ get_bit(lfsr_gen3, 20) ^ get_bit(lfsr_gen3, 22))
    data_out = set_bit(data_out, 1, get_bit(data_in, 1) ^ get_bit(lfsr_gen3, 21))
    data_out = set_bit(data_out, 0, get_bit(data_in, 0) ^ get_bit(lfsr_gen3, 22))
    await calc_next_lfsr()  # Calculate the next LFSR value

    return data_out

async def get_length_from_data_len(data_len_i):
    """
    Convert a 2-bit binary input to a corresponding integer value.
    Args:
        data_len_i (int): A 2-bit binary number (0b00, 0b01, or 0b10).
    Returns:
        int: Returns 1 for 0b00, 2 for 0b01, and 4 for 0b10.
    """
    if data_len_i == 0b00:
        return 1
    elif data_len_i == 0b01:
        return 2
    elif data_len_i == 0b10:
        return 4
    else:
        raise ValueError("Invalid input: data_len_i must be a 2-bit binary number (0b00, 0b01, or 0b10).")


@cocotb.test()
async def gen1_2_lfsr(dut):
    """Testing LFSR GEN1/2 On for 0x00 Data"""
    didPass = True
    global lfsr
    lfsr = 0xFFFF
    #Run Clock
    clock = Clock(dut.clk_i, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.datak_i.value = 0b0000
    dut.data_len_i.value = 0b00
    dut.indata_i.value = 0x00000000
    dut.training_sequence_i.value = 0b0000
    dut.rst_i.value = 1
    dut.scramble_enable_i.value = 0b1
    dut.pcie_gen.value = 0b0
    # await RisingEdge(dut.clk_i)
    # await RisingEdge(dut.clk_i)
    await Timer(clock_period, units="ns")
    dut.rst_i.value = 0
    await Timer(clock_period, units="ns")

    num_iterations = 300
    data_k = [0b00] * num_iterations
    data_len = [0b00] * num_iterations
    data_in = 0X00
    
    for i in range (num_iterations):
        # Print the LFSR state after each iteration
        await RisingEdge(dut.clk_i)
        scrambled_byte = await scramble_byte(data_in)
        dut._log.info(f"DUT DATA: {dut.scrambled_data_o.value}")
        dut._log.info(f"DUR LFSR: {dut.gen1_scrambler_u.g1_lfsr_reg.value}")

        dut_scrambled_byte = dut.scrambled_data_o.value & 0xFF
        dut_lfsr_value = dut.gen1_scrambler_u.g1_lfsr_reg.value & 0xFFFF

        if(scrambled_byte != dut_scrambled_byte):
            didPass = False
            break
        if((not didPass) or debug_on):
            dut._log.info(f"Python Scramble byte: 0x{scrambled_byte:02X}, DUT Scramble Byte: 0x{dut_scrambled_byte:02X}")
            dut._log.info(f"Python LFSR: {lfsr:04X}, DUT LFSR: {dut_lfsr_value:04X}")
            
    assert didPass


@cocotb.test()
async def gen3_scrambler_test(dut):
    """Testing GEN3 scrambler for 0x00 data with pcie_gen = 1."""
    didPass = True
    debug_on = False
    global lfsr_gen3
    lfsr_gen3 = 0x1DBFBC
    clock_period = 10  # ns

    # Start Clock
    clock = Clock(dut.clk_i, clock_period, units="ns")
    cocotb.start_soon(clock.start())

    # Set initial input values
    dut.datak_i.value = 0b00
    dut.data_len_i.value = 0b00
    dut.indata_i.value = 0x00
    dut.training_sequence_i.value = 0b0
    dut.rst_i.value = 1
    dut.pcie_gen.value = 0b1  # Set PCIE_GEN to 1 for GEN3 scrambler

    # Apply reset
    await Timer(clock_period, units="ns")
    dut.rst_i.value = 0
    await Timer(clock_period, units="ns")

    # Test parameters
    num_iterations = 300
    # lfsr = 0x1DBFBC  # Initial LFSR value for GEN3
    data_in = 0x00  # Test data

    for i in range(num_iterations):
        await RisingEdge(dut.clk_i)

        # Python scrambler reference model
        scrambled_byte = await scramble_gen3(data_in)

        # Read DUT outputs
        dut_scrambled_byte = dut.scrambled_data_o.value & 0xFF
        dut_lfsr_value = dut.gen3_scrambler_u.g3_lfsr_reg.value & 0x7FFFFF

        # Compare outputs
        if scrambled_byte != dut_scrambled_byte:
            didPass = False
            dut._log.error(f"Discrepancy at iteration {i}: Python Scrambled Byte = 0x{scrambled_byte:02X}, DUT Scrambled Byte = 0x{dut_scrambled_byte:02X}")
            break

        if lfsr_gen3 != dut_lfsr_value:
            didPass = False
            dut._log.error(f"Discrepancy at iteration {i}: Python LFSR = 0x{lfsr_gen3:06X}, DUT LFSR = 0x{dut_lfsr_value:06X}")
            break

        # if debug_on:
        dut._log.info(f"Iteration {i}: Python Scrambled Byte = 0x{scrambled_byte:02X}, DUT Scrambled Byte = 0x{dut_scrambled_byte:02X}")
        dut._log.info(f"Iteration {i}: Python LFSR = 0x{lfsr_gen3:06X}, DUT LFSR = 0x{dut_lfsr_value:06X}")

    assert didPass, "GEN3 scrambler test failed!"

