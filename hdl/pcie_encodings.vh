//-----------------------------------------------------------------------------
// Title         : PCIe Encodings
// Project       : PCIe Scrambler
//-----------------------------------------------------------------------------
// File          : pcie_encodings.vh
// Author        : Basel Kelziye
// Created       : [Date]
//-----------------------------------------------------------------------------
// Description :
// This file contains the encoding definitions for the PCIe Scrambler project.
//-----------------------------------------------------------------------------
// Revision History:
// [Date] - Initial version
//-----------------------------------------------------------------------------

`ifndef pcie_encodings_vh
`define pcie_encodings_vh

        // Encoding definitions
        // `define D5_2      8'h45  // D5.2
        // `define D10_2     8'h4A  // D10.2
`define COM       8'hBC  // COMMA character = K28.5 =  8'hBC
`define SKP       8'h1C  // SKIP character  = K23.7 =  8'h1C
`define PAD_GEN12 8'hF7  // PAD character   = K28.1 =  8'hF7
`define IDL       8'h7C  // IDL character   = K28.3 =  8'h7C
        // `define EIE       8'hFC  // EIE character   = K28.7 =  8'hFC
`define SDP       8'h5C  // SDP character   = K28.2 =  8'h5C
`define STP       8'hFB  // STP character   = K27.7 =  8'hFB
`define TS1       8'h1E
`define TS2       8'h2D


`define ONE_BYTE	2'b00
`define TWO_BYTE	2'b01
`define THREE_BYTE  2'b10
`define pcie_gen1                1'b0
`define pcie_gen3                1'b1
        // `define END       8'hFD  // END character   = K29.7 =  8'hFD
        // `define EBD       8'hFE  // EDB character   = K30.7 =  8'hFE
        // `define PAD_GEN3  8'h3C  // PAD character   = K28.1 =  8'h3C

        // Add your encoding definitions here

`endif // PCIE_ENCODINGS_VH
