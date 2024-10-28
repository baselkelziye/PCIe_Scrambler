
def print_lfsr8(lfsr8_reg):
    binary_string = ''.join(str(bit) for bit in lfsr8_reg)
    binary_value = int(binary_string, 2)
    hex_value = hex(binary_value)
    return hex_value


def lfsr8(lfsr8_reg):
    lfsr8_input = lfsr8_reg
    lfsr8_next = [0] * 16
    # Apply the logic from the Verilog code
    lfsr8_next[0] = lfsr8_reg[8]
    lfsr8_next[1] = lfsr8_reg[9]
    lfsr8_next[2] = lfsr8_reg[10]
    lfsr8_next[3] = lfsr8_reg[8] ^ lfsr8_reg[11]
    lfsr8_next[4] = lfsr8_reg[8] ^ lfsr8_reg[9] ^ lfsr8_reg[12]
    lfsr8_next[5] = lfsr8_reg[8] ^ lfsr8_reg[9] ^ lfsr8_reg[10] ^ lfsr8_reg[13]
    lfsr8_next[6] = lfsr8_reg[9] ^ lfsr8_reg[10] ^ lfsr8_reg[11] ^ lfsr8_reg[14]
    lfsr8_next[7] = lfsr8_reg[10] ^ lfsr8_reg[11] ^ lfsr8_reg[12] ^ lfsr8_reg[15]
    lfsr8_next[8] = lfsr8_reg[0] ^ lfsr8_reg[11] ^ lfsr8_reg[12] ^ lfsr8_reg[13]
    lfsr8_next[9] = lfsr8_reg[1] ^ lfsr8_reg[12] ^ lfsr8_reg[13] ^ lfsr8_reg[14]
    lfsr8_next[10] = lfsr8_reg[2] ^ lfsr8_reg[13] ^ lfsr8_reg[14] ^ lfsr8_reg[15]
    lfsr8_next[11] = lfsr8_reg[3] ^ lfsr8_reg[14] ^ lfsr8_reg[15]
    lfsr8_next[12] = lfsr8_reg[4] ^ lfsr8_reg[15]
    lfsr8_next[13] = lfsr8_reg[5]
    lfsr8_next[14] = lfsr8_reg[6]
    lfsr8_next[15] = lfsr8_reg[7]
    # Update the lfsr8_reg with the computed next state
    lfsr8_reg = lfsr8_next

    return lfsr8_reg


def main():
    lfsr8_reg  = [1] * 16
    lfsr8_hex = print_lfsr8(lfsr8_reg)
    print(f"LFSR state after Restart : {lfsr8_hex}")
    # lfsr8_hex =   print_lfsr8(lfsr8_reg)
    for i in range(8):
        lfsr8_next = lfsr8(lfsr8_reg)
        lfsr8_hex = print_lfsr8(lfsr8_next)
        print(f"LFSR state after iteration {i+1}: {lfsr8_hex}")
        lfsr8_reg = lfsr8_next

if __name__ == "__main__":
     main()
