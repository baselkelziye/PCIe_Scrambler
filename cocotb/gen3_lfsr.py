def set_bit(var, bit, val):
    """Set bit number 'bit' of 'var' to the value 'val'. Bit 'bit' of 'var' must start cleared."""
    return var | ((val & 1) << bit)

def get_bit(var, bit):
    """Return the value of bit number 'bit' of 'var'."""
    return (var >> bit) & 1

def calc_next_lfsr(lfsr):
    """Calculate the next LFSR value."""
    next_lfsr = 0
    next_lfsr = set_bit(next_lfsr, 22, get_bit(lfsr, 14) ^ get_bit(lfsr, 16) ^ get_bit(lfsr, 18) ^ 
                                      get_bit(lfsr, 20) ^ get_bit(lfsr, 21) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr, 21, get_bit(lfsr, 13) ^ get_bit(lfsr, 15) ^ get_bit(lfsr, 17) ^ 
                                      get_bit(lfsr, 19) ^ get_bit(lfsr, 20) ^ get_bit(lfsr, 21))
    next_lfsr = set_bit(next_lfsr, 20, get_bit(lfsr, 12) ^ get_bit(lfsr, 19) ^ get_bit(lfsr, 21))
    next_lfsr = set_bit(next_lfsr, 19, get_bit(lfsr, 11) ^ get_bit(lfsr, 18) ^ get_bit(lfsr, 20) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr, 18, get_bit(lfsr, 10) ^ get_bit(lfsr, 17) ^ get_bit(lfsr, 19) ^ get_bit(lfsr, 21))
    next_lfsr = set_bit(next_lfsr, 17, get_bit(lfsr,  9) ^ get_bit(lfsr, 16) ^ get_bit(lfsr, 18) ^ 
                                      get_bit(lfsr, 20) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr, 16, get_bit(lfsr,  8) ^ get_bit(lfsr, 15) ^ get_bit(lfsr, 17) ^ 
                                      get_bit(lfsr, 19) ^ get_bit(lfsr, 21) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr, 15, get_bit(lfsr,  7) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr, 14, get_bit(lfsr,  6) ^ get_bit(lfsr, 21))
    next_lfsr = set_bit(next_lfsr, 13, get_bit(lfsr,  5) ^ get_bit(lfsr, 20) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr, 12, get_bit(lfsr,  4) ^ get_bit(lfsr, 19) ^ get_bit(lfsr, 21) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr, 11, get_bit(lfsr,  3) ^ get_bit(lfsr, 18) ^ get_bit(lfsr, 20) ^ 
                                      get_bit(lfsr, 21) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr, 10, get_bit(lfsr,  2) ^ get_bit(lfsr, 17) ^ get_bit(lfsr, 19) ^ 
                                      get_bit(lfsr, 20) ^ get_bit(lfsr, 21) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr,  9, get_bit(lfsr,  1) ^ get_bit(lfsr, 16) ^ get_bit(lfsr, 18) ^ 
                                      get_bit(lfsr, 19) ^ get_bit(lfsr, 20) ^ get_bit(lfsr, 21))
    next_lfsr = set_bit(next_lfsr,  8, get_bit(lfsr,  0) ^ get_bit(lfsr, 15) ^ get_bit(lfsr, 17) ^ 
                                      get_bit(lfsr, 18) ^ get_bit(lfsr, 19) ^ get_bit(lfsr, 20))
    next_lfsr = set_bit(next_lfsr,  7, get_bit(lfsr, 17) ^ get_bit(lfsr, 19) ^ get_bit(lfsr, 20) ^ get_bit(lfsr, 21))
    next_lfsr = set_bit(next_lfsr,  6, get_bit(lfsr, 16) ^ get_bit(lfsr, 18) ^ get_bit(lfsr, 19) ^ 
                                      get_bit(lfsr, 20) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr,  5, get_bit(lfsr, 15) ^ get_bit(lfsr, 17) ^ get_bit(lfsr, 18) ^ 
                                      get_bit(lfsr, 19) ^ get_bit(lfsr, 21) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr,  4, get_bit(lfsr, 17))
    next_lfsr = set_bit(next_lfsr,  3, get_bit(lfsr, 16))
    next_lfsr = set_bit(next_lfsr,  2, get_bit(lfsr, 15) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr,  1, get_bit(lfsr, 16) ^ get_bit(lfsr, 18) ^ get_bit(lfsr, 20) ^ get_bit(lfsr, 22))
    next_lfsr = set_bit(next_lfsr,  0, get_bit(lfsr, 15) ^ get_bit(lfsr, 17) ^ get_bit(lfsr, 19) ^ 
                                      get_bit(lfsr, 21) ^ get_bit(lfsr, 22))
    return next_lfsr

def scramble_data(lfsr, data_in):
    """Scramble a byte, given the current LFSR value."""
    data_out = 0
    data_out = set_bit(data_out, 7, get_bit(data_in, 7) ^ get_bit(lfsr, 15) ^ get_bit(lfsr, 17) ^ 
                                get_bit(lfsr, 19) ^ get_bit(lfsr, 21) ^ get_bit(lfsr, 22))
    data_out = set_bit(data_out, 6, get_bit(data_in, 6) ^ get_bit(lfsr, 16) ^ get_bit(lfsr, 18) ^ get_bit(lfsr, 20) ^ get_bit(lfsr, 22))
    data_out = set_bit(data_out, 5, get_bit(data_in, 5) ^ get_bit(lfsr, 17) ^ get_bit(lfsr, 19) ^ get_bit(lfsr, 21))
    data_out = set_bit(data_out, 4, get_bit(data_in, 4) ^ get_bit(lfsr, 18) ^ get_bit(lfsr, 20) ^ get_bit(lfsr, 22))
    data_out = set_bit(data_out, 3, get_bit(data_in, 3) ^ get_bit(lfsr, 19) ^ get_bit(lfsr, 21))
    data_out = set_bit(data_out, 2, get_bit(data_in, 2) ^ get_bit(lfsr, 20) ^ get_bit(lfsr, 22))
    data_out = set_bit(data_out, 1, get_bit(data_in, 1) ^ get_bit(lfsr, 21))
    data_out = set_bit(data_out, 0, get_bit(data_in, 0) ^ get_bit(lfsr, 22))
    return data_out

def main():
    """Simulate LFSR and scrambling for 128 iterations."""
    lfsr = 0x1DBFBC  # Initial LFSR value
    unscrambled_data = 0x00  # Unscrambled data
    
    print(f"{'Iteration':<10} {'LFSR':<10} {'Next LFSR':<10} {'Scrambled Data':<15}")
    print("-" * 45)
    
    for i in range(128):
        scrambled_data = scramble_data(lfsr, unscrambled_data)
        next_lfsr = calc_next_lfsr(lfsr)
        print(f"{i:<10} {lfsr:06X}    {next_lfsr:06X}    {scrambled_data:02X}")
        lfsr = next_lfsr

if __name__ == "__main__":
    main()
