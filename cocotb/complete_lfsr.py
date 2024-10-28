# Global variables for COMMA and SKIP
COMMA = 0xBC  # Equivalent to 8'hBC in Verilog
SKIP = 0x1C   # Equivalent to 8'h1C in Verilog
lfsr = 0xFFFF  # 16-bit short for polynomial


def scramble_byte(inbyte, TrainingSequence=False):
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
    print(f"LFSR = 0x{lfsr:04X}")
    lfsr = 0
    for i in range(16):
        lfsr += (bit_out[i] << i)
    
    

    # Convert the scrambled data back to an integer
    outbyte = 0
    for i in range(8):
        outbyte += (scrambit[i] << i)

    return outbyte


def main():
    input_data = 0x00  # 8'h00 in Verilog notation
    print(f"Input Data: {hex(input_data)}")

    # Perform scrambling 10 times, ignoring the initial 0xFFFF LFSR
    for i in range(10):
        scrambled_data = scramble_byte(input_data)  # Call the scramble_byte function
        # Print the scrambled data and LFSR in 4-digit hex format
        print(f"Iteration {i+1}: Scrambled Data = {hex(scrambled_data)}")

if __name__ == "__main__":
    main()
