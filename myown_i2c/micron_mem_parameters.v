/****************************************************************************************
*
*   Disclaimer   This software code and all associated documentation, comments or other 
*  of Warranty:  information (collectively "Software") is provided "AS IS" without 
*                warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
*                DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
*                TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMPLIED WARRANTIES 
*                OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
*                WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
*                OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
*                FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
*                THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
*                ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
*                OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
*                ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
*                INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
*                WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
*                OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
*                THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
*                DAMAGES. Because some jurisdictions prohibit the exclusion or 
*                limitation of liability for consequential or incidental damages, the 
*                above limitation may not apply to you.
*
*                Copyright 2005 Micron Technology, Inc. All rights reserved.
*
****************************************************************************************/

// Timing parameters based on Speed Grade

`ifdef sg701                              // Timing Parameters for speed group -701
    `ifdef Denali
        parameter tCLK      =      9.70;      //103.95MHz
    `else
        parameter tCLK      =      9.62;      //103.95MHz
    `endif
    parameter tAADV     =     70.00;      // units in ns for all values
    parameter tACLK     =      7.00;      // units in ns for all values
    parameter tAVH      =      2.00;
    parameter tAVS      =      5.00;
    parameter tAW       =     70.00;
    parameter tBW       =     70.00;
    parameter tCBPH     =      5.00;
    parameter tCEM      =    4000.0;
    parameter tCEW      =       7.5;      // tCEM MAX
    parameter tCKA      =     70.00;      // ???
    parameter tCO       =     70.00;
    parameter tCW       =     70.00;
    parameter tDH       =      0.00;
    parameter tDW       =     20.00;
    parameter tHZ       =      8.00;
    parameter tOE       =     20.00;
    parameter tOHZ      =      8.00;
    parameter tPC       =     20.00;
    parameter tPU       =    150000;      // Power-up delay 150us
    parameter tRC       =     70.00;
    parameter tVP       =      5.00;
    parameter tVPH      =     10.00;
    parameter tWC       =     70.00;
    parameter tWP       =     45.00;
    parameter tWPH      =     10.00;
`else `ifdef sg708
    `ifdef Denali
        parameter tCLK      =     12.50;
    `else
        parameter tCLK      =     12.50;
    `endif
    parameter tAADV     =     70.00;      // units in ns for all values
    parameter tACLK     =      9.00;      // units in ns for all values
    parameter tAVH      =      2.00;
    parameter tAVS      =      5.00;
    parameter tAW       =     70.00;
    parameter tBW       =     70.00;
    parameter tCBPH     =      6.00;
    parameter tCEM      =    4000.0;
    parameter tCEW      =       7.5;      // tCEM MAX
    parameter tCKA      =     70.00;  // ???
    parameter tCO       =     70.00;
    parameter tCW       =     70.00;
    parameter tDH       =      0.00;
    parameter tDW       =     20.00;
    parameter tHZ       =      8.00;
    parameter tOE       =     20.00;
    parameter tOHZ      =      8.00;
    parameter tPC       =     20.00;
    parameter tPU       =    150000;      // Power-up delay 150us
    parameter tRC       =     70.00;
    parameter tVP       =      5.00;
    parameter tVPH      =     10.00;
    parameter tWC       =     70.00;
    parameter tWP       =     45.00;
    parameter tWPH      =     10.00;
`else `ifdef sg856
    `ifdef Denali
        parameter tCLK      =     15.00;
    `else
        parameter tCLK      =     15.00;
    `endif
    parameter tAADV     =     85.00;      // units in ns for all values
    parameter tACLK     =     11.00;      // units in ns for all values
    parameter tAVH      =      2.00;
    parameter tAVS      =      5.00;
    parameter tAW       =     85.00;
    parameter tBW       =     85.00;
    parameter tCBPH     =      8.00;
    parameter tCEM      =    4000.0;
    parameter tCEW      =       7.5;      // tCEM MAX
    parameter tCKA      =     70.00;  // ???
    parameter tCO       =     85.00;
    parameter tCW       =     85.00;
    parameter tDH       =      0.00;
    parameter tDW       =     20.00;
    parameter tHZ       =      8.00;
    parameter tOE       =     20.00;
    parameter tOHZ      =      8.00;
    parameter tPC       =     25.00;
    parameter tPU       =    150000;      // Power-up delay 150us
    parameter tRC       =     85.00;
    parameter tVP       =      7.00;
    parameter tVPH      =     10.00;
    parameter tWC       =     85.00;
    parameter tWP       =     55.00;
    parameter tWPH      =     10.00;
`endif `endif `endif 

// Size Parameters based on Part Width
`ifdef x16
    parameter addr_bits      =      23;
    parameter data_bits      =      16;
    parameter mem_sizes      = 8388608;
 `else `define x32 
    // no need for this at this time, skip for now.
`endif
