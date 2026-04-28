/**************************************************************************
*
*    File Name:  mt45w8mw16bgx.v
*        Model:  BUS Functional
*    Simulator:  Model Technology
*
* Dependencies:  parameters.v
*
*       Author:  Micron Technology, Inc.
*        Email:  modelsupport@micron.com
*  Part Number:  mt45w8mw16bgx
*
*  Description:  Micron 128Mb CellularRAM 1.5 (Async / Page / Burst)
*
*   Limitation:  Need to add timing checks
*
*         Note:  
*
*   Disclaimer: This software code and all associated documentation, comments
*               or other information (collectively "Software") is provided 
*               "AS IS" without warranty of any kind. MICRON TECHNOLOGY, INC. 
*               ("MTI") EXPRESSLY DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED,
*               INCLUDING BUT NOT LIMITED TO, NONINFRINGEMENT OF THIRD PARTY
*               RIGHTS, AND ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS
*               FOR ANY PARTICULAR PURPOSE. MTI DOES NOT WARRANT THAT THE
*               SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE OPERATION OF
*               THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. FURTHERMORE,
*               MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR THE
*               RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS,
*               ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT
*               OF USE OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO
*               EVENT SHALL MTI, ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE
*               LIABLE FOR ANY DIRECT, INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR
*               SPECIAL DAMAGES (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS
*               OF PROFITS, BUSINESS INTERRUPTION, OR LOSS OF INFORMATION)
*               ARISING OUT OF YOUR USE OF OR INABILITY TO USE THE SOFTWARE,
*               EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
*               Because some jurisdictions prohibit the exclusion or limitation
*               of liability for consequential or incidental damages, the above
*               limitation may not apply to you.
*               
*               Copyright 2006 Micron Technology, Inc. All rights reserved.
*               
* Rev  Author          Date        Changes
* ---  --------------------------  ----------------------------------------
* 1.0  SH              05/10/2003  - Initial release
*      
* 1.1  NB              06/15/2004  - Fixed problem with row crossing
*                                    functionality. 
*
* 1.2  PF              10/20/2004  - Changed default value of
*                                    operating_mode to match datasheet.
*                                    Conditioned sync operation on setting
*                                    operating_mode
*
* 1.3  dritz           01/20/2005  - Updated parameters, parameterized the model, corrected a few bugs.
*                                      populated BCR, RCR
*                                      added DIDR feature
*                                      fixed burst interrupt on ADV#
*                                      added CR1.0 1.5 features
* 1.4  dritz           10/04/2005  - Fixed sync 2 async transition 
*
* 1.5  dritz           11/31/2005  - Owait on async corrected.
*
* 1.6  dritz           02/16/2006  - Row boundary crossing fixed.
**************************************************************************/

// DO NOT CHANGE THE TIMESCALE
// MAKE SURE YOUR SIMULATOR USE "PS" RESOLUTION
`timescale 1ns / 1ps

module mt45w8mw16bgx ( // model_verilog
              Addr, 
              Adv_n, 
              Ce_n, 
              Clk, 
              Cre, 
              Dq, 
              Lb_n, 
              Oe_n, 
              oWait, 
              Ub_n,
              We_n 
              ); 

`define CR15
//`define sg708
`define sg701
//`define sg856
`define x16

`include "micron_mem_parameters.v"

    // Display debug message
    parameter debug          =    0;
    parameter debug2         =    0;
    parameter debug3         =    0;
    parameter debugcecw      =    0;
    
    // Port declarations
    inout     [data_bits - 1 : 0] Dq;
    output                        oWait; // Wait is a keyword in HDL
    input                         Clk;
    input     [addr_bits - 1 : 0] Addr;
    input                         Ce_n;
    input                         We_n;
    input                         Adv_n;
    input                         Oe_n;
    input                         Cre;
    input                         Ub_n;
    input                         Lb_n;

    // Memory arrays
    reg                   [7 : 0] Bank0 [0 : mem_sizes];
    reg                   [7 : 0] Bank1 [0 : mem_sizes];

    // Software access registers
    reg                   [7 : 0] software_access_unlock1;
    reg                   [7 : 0] software_access_unlock2;
    reg                   [1 : 0] software_access_which_reg;

    // System registers
    reg                           sys_clk, sys_reset;

    // Asynchronous registers
    reg                           async_data_out_enable;
    reg                           async_config_enable;
    reg                           async_data_enable;
    reg       [addr_bits - 1 : 0] async_addr_in;
    reg       [data_bits - 1 : 0] async_data_in;
    reg       [data_bits - 1 : 0] async_data_out;

    // Synchronous registers
    reg                           sync_data_in_enable;
    reg                           sync_data_out_enable;
    reg                           sync_config_read;
    reg       [addr_bits - 1 : 0] sync_addr_in;
    reg       [data_bits - 1 : 0] sync_data_out;
    reg                           bwait, rwait;
    reg                           lb_reg, ub_reg;
    integer                       counter;

    // Sync to Async transition registers
    reg                   [2:0]   Sync2AsyncConfig;

    // Continuous row end delay
    reg                           row_start;
    reg                           row_end;
    reg                           row_wait;
    integer                       row_count;

    // Row End Corner Case
    reg       [data_bits - 1 : 0] CornerCase;
    reg                           LatchCornerCaseLb_n;
    reg                           LatchCornerCaseUb_n;
    reg                   [7 : 0] LatchCornerCaseLower;
    reg                   [7 : 0] LatchCornerCaseUpper;
    reg                           StartBurstOnLastAddr;

    // Refresh Collision
    time                          ref_collision;

    // Output register
    reg       [data_bits - 1 : 0] data_out;

    // Latency counter pipeline
    // 00 = Write, 01 = Read, 10 = Mode, 11 = don't care
    reg                   [1 : 0] latency_counter_pipeline [0 : 13];
    
    reg  [addr_bits-1:0] latch_data_in_register;
    // Bus Configuration Register
    reg  [addr_bits-1:0] bus_conf_register;
    wire           [2:0] burst_length           = bus_conf_register [2:0];
    wire                 burst_wrap             = bus_conf_register [3];
    wire           [1:0] drive_strength         = bus_conf_register [5:4];     // dritz added
    wire                 clock_configuration    = bus_conf_register [6];       // Reserved
    wire                 reserved_1             = bus_conf_register [7];       // Reserved dritz added
    wire                 wait_configuration     = bus_conf_register [8];   
    wire                 hold_data_out          = bus_conf_register [9];       // Reserved dritz added
    wire                 wait_polarity          = bus_conf_register [10];
    wire           [2:0] latency_counter        = bus_conf_register [13:11];
    wire                 initial_latency        = bus_conf_register [14];      // dritz added  //For CR1.0 this is OKAY -> for CR1.5
    wire                 operating_mode         = bus_conf_register [15]; 
    wire           [1:0] reserved_2             = bus_conf_register [17:16];   // Reserved dritz added
    wire           [1:0] register_select_BCR    = bus_conf_register [19:18];   // dritz added
    wire           [2:0] reserved_3             = bus_conf_register [22:20];   // Reserved dritz added

    // Refresh Configuration Register
    reg  [addr_bits-1:0] ref_conf_register;
    wire           [2:0] partial_array_refresh  = ref_conf_register [2:0];
    wire                 reserved_4             = ref_conf_register [3];       // dritz added
    wire                 deep_power_down        = ref_conf_register [4];
    wire           [1:0] reserved_5             = ref_conf_register [6:5];     // Reserved per data sheet dritz added
    wire                 page_mode              = ref_conf_register [7];
    wire           [9:0] reserved_6             = ref_conf_register [17:8];    // Reserved per data sheet dritz added
    wire           [1:0] register_select_RCR    = ref_conf_register [19:18];   // dritz added
    wire           [2:0] reserved_7             = ref_conf_register [22:20];   // Reserved dritz added


    // Device ID Register READ ONLY
    reg  [addr_bits-1:0] didr_conf_register = 0;
    reg            [4:0] vendor_ID              = 5'b00011;    // Micron
    reg            [2:0] generation             = 3'b010;      // 010= *CR1.5*
    reg            [2:0] density                = 3'b011;      // 128Mb
    reg            [3:0] version                = 4'b0100;     // arbitary

    // Internal wires
    wire #1 last_adv_n = Adv_n;
    wire #1 last_oe_n  = Oe_n;
    wire #1 last_ce_n  = Ce_n;
    wire #1 last_we_n  = We_n;
    wire #1 last_lb_n  = Lb_n;
    wire #1 last_ub_n  = Ub_n;
    wire #1 last_cre   = Cre;
    wire #tCLK last_row_end   = row_end;
    wire #tCLK last_row_end2  = last_row_end;
    wire [data_bits - 1 : 0] #1 last_Dq    = Dq;

    // Wait buffer
    assign  oWait = bwait;

    // Output buffer
    assign Dq = (sync_data_out_enable || async_data_out_enable) ? data_out : 16'bz;

    // Initial condition
    initial begin
        CornerCase           = 'b0;
        StartBurstOnLastAddr = 'b0;
        LatchCornerCaseLb_n  = 'bz;
        LatchCornerCaseUb_n  = 'bz;
        LatchCornerCaseLower = 'bz;
        LatchCornerCaseUpper = 'bz;
        Sync2AsyncConfig = 3'b000;
        software_access_unlock1   = 1'b0;
        software_access_unlock2   = 1'b0;
        software_access_which_reg = 'bz;
        sys_clk = 1'b0;
        sys_reset = 1'b0;
        async_data_out = 16'bz;
        async_data_out_enable = 1'b0;
        async_config_enable = 1'b0;
        sync_config_read = 1'b0;
        async_data_enable = 1'b0;
        sync_data_out = 16'bz;
        sync_data_in_enable = 1'b0;
        sync_data_out_enable = 1'b0;
        row_end = 1'b0;
        bwait = 1'bz;
        rwait = 1'bz;
        ref_collision = 0;
        //  BUS CONF REGISTER   210 98 76 5 4 321 0 9 8 76 54 3 210 
        bus_conf_register = 23'b000_10_00_1_0_011_1_0_1_00_01_1_111;   //Default powerup values
        latch_data_in_register = 23'hzzzzzz;
        //didr_conf_register = READONLY
        ref_conf_register = 'h0010;   //Default powerup values
        didr_conf_register = {version, density, generation, vendor_ID};
    end

    // Asynchronous Wait signal
    always @ (posedge Ce_n or negedge Ce_n) begin
        if (debug2) $display("Edge detected on ce_n");
        if (~Ce_n) begin
            if (debug) $display("===============================================================");
            if (debug3) $display ($time, "  oWait Trigger 1");
            rwait = wait_polarity;
        end else begin
            if (debug3) $display ($time, "  oWait Trigger 2");
            if (Adv_n == 1'b0) begin
               rwait = 1'bz;
            end else begin
               rwait = 1'bz;
            end
            sync_data_out = 16'bz;
            sync_data_in_enable = 1'b0;
            sync_data_out_enable = 1'b0;
            sync_config_read = 1'b0;
            CornerCase = 'b0;
            LatchCornerCaseLower = 'bz;
            LatchCornerCaseUpper = 'bz;
            LatchCornerCaseLb_n = 'bz;
            LatchCornerCaseUb_n = 'bz;
            StartBurstOnLastAddr = 'b0;
        end
    end

    // Asynchronous data latch
    always @ (Dq) begin
        if (debug2) $display("Asynchronous data latch");
        async_data_in <= #1 Dq;
    end

    // Asynchronous address latch
    always @ (Adv_n or Addr) begin
        if (debug2) $display("Asynchronous address latch");
        if (~last_adv_n && Adv_n) begin
            async_addr_in <= #1 Addr;
        end else if (~Adv_n) begin
            async_addr_in <= #1 Addr;
        end
    end

    // Main Asynchronous block
    always @ (Addr or Ce_n or We_n or Oe_n or Lb_n or Ub_n or Adv_n or sys_reset) begin
        if (debug2) $display("Main Asynchronous Block");
        if (sys_reset) begin
            async_data_out_enable = 1'b0;
            async_config_enable = 1'b0;
            async_data_enable = 1'b0;
            async_data_out = 16'bz;
        end else begin
            // Read Burst (done)
            if (((~last_ce_n && Ce_n) || (~last_oe_n && Oe_n) || (~last_ub_n && Ub_n) || (~last_lb_n && Lb_n)) &&((async_data_out_enable))) begin
                async_data_out_enable = #tHZ 1'b0;
                async_data_out = 16'bz;
            end
            
        // Config Read 
        //else if (~Adv_n && ~Ce_n && (~Lb_n || ~Ub_n) && We_n && Cre && async_config_enable) begin
        else if (~Ce_n && We_n && ~Oe_n  && async_config_enable) begin
            if (debug) $display ($time, "Caught Async Config Read");

            case (latch_data_in_register[19:18])
                2'b00    : begin
                               async_data_out = ref_conf_register;  // 00 = RCR
                               if (debug) $display ($time, "   RCR read, RCR=%h", ref_conf_register);
                           end
                2'b01    : begin
                               async_data_out = didr_conf_register; // 01 = DIDR
                               if (debug) $display ($time, "   DIDR read, DIDR=%h", didr_conf_register);
                           end
                2'b10    : begin
                               async_data_out = bus_conf_register;  // 10 = BCR
                               if (debug) $display ($time, "   BCR read, BCR=%h", bus_conf_register);
                           end
                default  : begin
                               async_data_out = {data_bits{1'bx}};
                               if (debug) $display ($time, "   Error: while reading conf regs ADDR[19:18] not valid");
                           end
            endcase

            // Lower byte
            //if (Lb_n) async_data_out [7 : 0] = 8'bz;
            // Upper byte
            //if (Ub_n) async_data_out [15 : 8] = 8'bz;

            // Enable data out
            if (debug) $display ($time, "Enable async data_out_enable for Async Config Read");
            async_data_out_enable = 1'b1;

            async_config_enable = 1'b0;

            // Display debug message
            if (debug) $display ($time, " ns.  Note: Async - CONFIG Read, Addr = %h, Data = %h", latch_data_in_register, async_data_out);
        end

        // Read Burst
        else if (~Ce_n && (~Lb_n || ~Ub_n) && We_n && ~Oe_n && async_data_enable) begin
            if (debug) $display ($time, "Caught Async Read");

            if (latch_data_in_register === 23'h7fffff) 
                begin
                   if (software_access_unlock2 == 1) begin 
                       //trigger config read here
                       if (debug) $display ($time, " ns. SOFTWARE ACCESS READ Reg =  %h", software_access_which_reg);
                       case (software_access_which_reg)
                           2'b00    : begin
                                          async_data_out = ref_conf_register;  // 00 = RCR
                                          if (debug) $display ($time, "   RCR read, RCR=%h", ref_conf_register);
                                      end
                           2'b10    : begin
                                          async_data_out = didr_conf_register; // 01 = DIDR
                                          if (debug) $display ($time, "   DIDR read, DIDR=%h", didr_conf_register);
                                      end
                           2'b01    : begin
                                          async_data_out = bus_conf_register;  // 10 = BCR
                                          if (debug) $display ($time, "   BCR read, BCR=%h", bus_conf_register);
                                      end
                           default  : begin
                                          async_data_out = {data_bits{1'bx}};
                                          if (debug) $display ($time, "   Error: while reading conf regs ADDR[19:18] not valid");
                                      end
                       endcase
                       async_data_out_enable = 1'b1;
                       software_access_unlock1 = 1'b0;
                       software_access_unlock2 = 1'b0;
                       software_access_which_reg = 2'bzz;
                   end else begin
                       if (debug) $display ($time, " ns. SOFTWARE ACCESS UNLOCK1  =", software_access_unlock1);
                       software_access_unlock1 = software_access_unlock1 + 1;
                   end



                end else begin 
                    // Lower byte
                    case (Lb_n)
                        1'b0    : async_data_out [7 : 0] = Bank0 [latch_data_in_register];
                        //default : async_data_out [7 : 0] = 8'bz;
                        default : begin
                                     async_data_out [7 : 0] = Bank0 [latch_data_in_register];
                                     $display ($time, "ERROR:  Lb_n must be zero for read");
                                  end
                    endcase

                    // Upper byte
                    case (Ub_n)
                        1'b0    : async_data_out [15 : 8] = Bank1 [latch_data_in_register];
                        //default : async_data_out [15 : 8] = 8'bz;
                        default : begin
                                     async_data_out [15 : 8] = Bank1 [latch_data_in_register];
                                     $display ($time, "ERROR:  Ub_n must be zero for read");
                                  end
                    endcase

                    // Enable data out
                    if (debug) $display ($time, "Enable async data_out_enable for Async Read");
                    async_data_out_enable = 1'b1;
        
                    async_data_enable = 1'b0;
        
                    // Display debug message
                    if (debug) $display ($time, " ns.  Note: Async - Read, Addr = %h, Data = %h", latch_data_in_register, async_data_out);
                end
        end

        // Initialize async access
        else if (~Adv_n && ~Ce_n && (~Lb_n || ~Ub_n) && ~Cre && ~async_data_enable) begin
            // Display debug message
            if (debug) $display ($time, " ns.  Note: Async - Initiate Async Access");

            // Terminate Read
            async_data_out_enable = 1'b0;
            async_data_out = 16'bz;

            // Latch Data:
            latch_data_in_register = Addr;
            if (debug) $display ($time, " ns.  Latch data for config access=%h", latch_data_in_register);
            if (debug) $display ($time, " ns.  Async_addr_in=%h", Addr);

            async_data_enable = 1'b1;

        end

        // Write burst
        else if (((~last_ce_n && Ce_n) || (~last_lb_n && Lb_n) || (~last_ub_n && Ub_n) || (~last_we_n && We_n)) && async_data_enable) begin
            if (debugcecw) $display ($time, " ns. debug1 ce_n ctrld write");
            //if ((async_addr_in === 23'h7fffff) && ~last_we_n && We_n)
            if ((async_addr_in === 23'h7fffff) && ((~last_we_n && We_n && ~Ce_n) || (~last_ce_n && Ce_n && ~We_n) ||
                                                   (~last_we_n && We_n && ~last_ce_n && Ce_n)))
                begin
                    if (debugcecw) $display ($time, " ns. debug2 ce_n ctrld write");
                    if (software_access_unlock1 >= 2) begin 
                       if (debugcecw) $display ($time, " ns. debug3 ce_n ctrld write");
                       if (software_access_unlock2 === 1'b1) begin 
                           if (debugcecw) $display ($time, " ns. debug4 ce_n ctrld write");
                           //trigger config write here
                           if (debug) $display ($time, " ns. SOFTWARE ACCESS WRITE Reg = %h", software_access_which_reg);
                           case (software_access_which_reg)
                               2'b00    : begin
                                             ref_conf_register = last_Dq;
                                             $display ("  SOFTWARE ACCESS Programming Refresh Configuration Register");
                                          end
                               2'b01    : begin
                                             bus_conf_register = last_Dq;
                                             $display ("  SOFTWARE ACCESS Programming Bus Configuration Register");
                                          end
                               2'b10    : begin
                                             $display ("  Error: SOFTWARE ACCESS DIDR Configuration Register is read-only");
                                          end
                               default  : $display ("   Error:  SOFTWARE ACCESS config_register reserved bits used [19:18]");
                           endcase
                           if (debugcecw) $display ($time, " ns. debug5 ce_n ctrld write");
                           software_access_unlock1 = 1'b0;
                           software_access_unlock2 = 1'b0;
                           software_access_which_reg = 2'bzz;
                       end else begin
                           software_access_unlock2 = software_access_unlock2 + 1;
                           software_access_which_reg = async_data_in [1:0];
                           if (debugcecw) $display ($time, " ns. debug6 ce_n ctrld write - WHICH=%d",async_data_in [1:0]);
                           if (debug) $display ($time, " ns. SOFTWARE ACCESS UNLOCK2  =", software_access_unlock2);
                       end
                    end
                end else begin
                // Lower Byte
                if (~Lb_n) begin
                    Bank0 [async_addr_in] = async_data_in [7 : 0];
                end
    
                // Upper Byte
                if (~Ub_n) begin
                    Bank1 [async_addr_in] = async_data_in [15 : 8];
                end
    
                // Display debug message
                if (debug) $display ($time, " ns.  Note: Async - Write, Addr = %h, Data = %h", async_addr_in, async_data_in);
    
                async_data_enable = 1'b0;
            end

        end

        // Initialize configuration register access
        else if (~Adv_n && ~Ce_n && Oe_n && Cre && ~async_config_enable) begin
            // Display debug message
            if (debug) $display ($time, " ns.  Note: Async - Initiate Configuration Register Access");

            // Latch Data:
            latch_data_in_register = Addr;
            if (debug) $display ($time, " ns.  Latch data for config access=%h", latch_data_in_register);
            if (debug) $display ($time, " ns.  Async_addr_in=%h", Addr);

            // Init read or write to config - sync or async
            async_config_enable = 1'b1;
        end

        // Write configuration register
        //if ((Ce_n ||  We_n || ~Cre) && async_config_enable) begin
        else if (~Ce_n && ~We_n && async_config_enable) begin
            // BCR or RCR or DIDR dependng on Addr[19:18]
            $display ("case for BSR RCR DIDR = 0x%d", async_addr_in[19:18] );
            case (latch_data_in_register[19:18])
                2'b00    : begin
                              ref_conf_register = latch_data_in_register;
                              $display ("  Programming Refresh Configuration Register");
                           end
                2'b10    : begin
                              bus_conf_register = latch_data_in_register;
                              $display ("  Programming Bus Configuration Register");
                           end
                2'b01    : begin
                              didr_conf_register = latch_data_in_register;
                              $display ("  Error:  DIDR Configuration Register is read-only");
                           end
                default  : $display ("   Error:  config_register reserved bits used [19:18]");
            endcase

            // Done configuration register write
            async_config_enable = 1'b0;

            // Display debug message
            if (debug) $display ($time, 
            " ns.  Note: Async - Configuration Register Write Complete, Addr = %h", async_addr_in);
   
            // Bus Configuration Register error checking 
            case (burst_length [2:0])
               3'b001  : $display ("Param: Burst Length =  4 words");
               3'b010  : $display ("Param: Burst Length =  8 words");
               3'b011  : $display ("Param: Burst Length = 16 words");
               3'b100  : $display ("Param: Burst Length = 32 words");  // *CR1.5* ONLY
               3'b111  : $display ("Param: Burst Length = continuous");  // default
               default : $display (" Error: Param: Burst Length used is not supported");
            endcase

            case (burst_wrap)
               1'b0    : $display ("Param: Burst Wrap = Wrap on ");
               1'b1    : $display ("Param: Burst Wrap = Wrap off ");  // default
            endcase

            case (drive_strength [1:0])  // *CR1.5* ONLY
               2'b00   : $display ("Param: Drive Strength= Full");  // default
               2'b01   : $display ("Param: Drive Strength= 1/2");  
               2'b10   : $display ("Param: Drive Strength= 1/4");  
               default : $display (" Error: Param: Drive Strength used is not supported");
            endcase
            
            case (clock_configuration)
               1'b0    :  begin end // do nothing
               default : $display (" Error: Param: Bus_Config_Reg[6] is resereved");
            endcase

            case (reserved_1)
               1'b0    :  begin end // do nothing
               default : $display (" Error: Param: Bus_Config_Reg[7] is resereved");
            endcase

            case (wait_configuration)
               1'b0    : $display ("Param: Wait Config = asserted during delay"); 
               1'b1    : $display ("Param: Wait Config = asserted one data cycle before delay ");  // default
            endcase

            case (hold_data_out)
               1'b0    :  begin end // do nothing
               default : $display (" Error: Param: Bus_Config_Reg[9] is resereved");
            endcase

            case (wait_polarity)
               1'b0    : $display ("Param: Wait Polarity = Active (low)"); 
               1'b1    : $display ("Param: Wait Polarity = Active (high)");  // default
            endcase

            case (latency_counter [2:0])
               3'b010  : $display ("Param: Latency Counter =  Code 2");
               3'b011  : $display ("Param: Latency Counter =  Code 3");   // default
               3'b100  : $display ("Param: Latency Counter =  Code 4");
               3'b101  : $display ("Param: Latency Counter =  Code 5");
               3'b110  : $display ("Param: Latency Counter =  Code 6");
               default : $display (" Error: Param: Latency Counter = Value used is reserved");
            endcase

            case (initial_latency)
               1'b0    : $display ("Param: Initial Latency = Variable");  // default
               1'b1    : $display ("Param: Initial Latency = Fixed");
            endcase

            case (operating_mode)
               1'b0    : $display ("Param: Operating Mode = Syncronous burst access");
               1'b1    : $display ("Param: Operating Mode = Asyncronous burst access");  //default
            endcase

            case (reserved_2 [1:0])
               2'b00   : begin end // do nothing
               default : $display (" Error: Param: Bus_Config_Reg[17:16] is resereved");
            endcase

            case (register_select_BCR [1:0])
               2'b00   : $display ("Param: REG SELCT = RCR");
               2'b10   : $display ("Param: REG SELCT = BCR");
               2'b01   : $display ("Param: REG SELCT = DIDR");
               default : $display (" Error: Param: REG SELCT value used is resereved");
            endcase

            case (reserved_3 [2:0])
               3'b000  : begin end // do nothing
               default : $display (" Error: Param: Bus_Config_Reg[22:20] is resereved");
            endcase

            // Refresh Configuration Register error checking
            case (partial_array_refresh [2:0])
               3'b000  : $display ("Param: Partial Array Refresh = Full array");
               3'b001  : $display ("Param: Partial Array Refresh = Bottom 1/2 array");
               3'b010  : $display ("Param: Partial Array Refresh = Bottom 1/4 array");
               3'b011  : $display ("Param: Partial Array Refresh = Bottom 1/8 array");
               3'b100  : $display ("Param: Partial Array Refresh = None");
               3'b101  : $display ("Param: Partial Array Refresh = Top 1/2 array");
               3'b110  : $display ("Param: Partial Array Refresh = Top 1/4 array");
               3'b111  : $display ("Param: Partial Array Refresh = Top 1/8 array");
            endcase

            case (reserved_4)
               1'b0    : begin end // do nothing
               default : $display (" Error: Param: ref_conf_Reg[3] is resereved");
            endcase

            case (deep_power_down)
               1'b0    : $display ("Param: deep_power_down = ON");
               1'b1    : $display ("Param: deep_power_down = OFF");
            endcase

            case (reserved_5 [1:0])
               2'b00    : begin end // do nothing
               default : $display (" Error: Param: ref_conf_Reg[6:5] is resereved");
            endcase

            case (page_mode)
               1'b0    : $display ("Param: page_mode = OFF");
               1'b1    : $display ("Param: page_mode = ON");
            endcase

            case (reserved_6 [9:0])
               10'b0000000000 : begin end // do nothing
               default : $display (" Error: Param: ref_conf_Reg[17:8] is resereved");
            endcase
            case (register_select_RCR [1:0])
               2'b00   : $display ("Param: REG SELCT = RCR");
               2'b10   : $display ("Param: REG SELCT = BCR");
               2'b01   : $display ("Param: REG SELCT = DIDR");
               default : $display (" Error: Param: REG SELCT value used is resereved");
            endcase

            case (reserved_7 [2:0])
               3'b000  : begin end // do nothing
               default : $display (" Error: Param: ref_conf_register[22:20] is resereved");
            endcase
            end
        end
    end

    // Synchronous internal command pipeline
    task synchronous_internal_command_pipeline;
        integer counter;
    begin
        if (debug2) $display("synchronous_internal_command_pipeline");
        // Latency counter pipeline
        for (counter = 0; counter < 13; counter = counter + 1) begin
            latency_counter_pipeline[counter] = latency_counter_pipeline[counter+1];
        end
        
        latency_counter_pipeline [13] = 2'b11;

        // Internal command ready
        case (latency_counter_pipeline [0])
            2'b00   : begin
                         sync_data_in_enable = 1'b1;   //SYNC WRITE
                         //$display("SYNC WRITE synchronous_internal_command_pipeline");
                      end 
            2'b01   : begin
                         sync_data_out_enable = 1'b1;  //SYNC READ
                         //$display("SYNC READ synchronous_internal_command_pipeline");
                      end 
            default : begin
                         //$display($time, "- SYNC UNMATCHED = %d synchronous_internal_command_pipeline", latency_counter_pipeline [0] );
                      end 
        endcase
    end
    endtask

    // Synchronous initial burst read
    task synchronous_initial_burst_read;
        integer random_delay;
    begin
        if (debug2) $display("synchronous_internal_burst_read");
        if (~Adv_n && ~Ce_n && We_n && ~Cre && (~Lb_n || ~Ub_n)) begin
            // Initialize random delay
            random_delay = 0;
            
            // Clear row crossing with a new access
            if (row_end == 1'b1) begin
                row_end = 1'b0;
            end
            
            // This should only be evaluated when in variable latency mode.
            // Random refresh cycle collision generator
            if (~initial_latency & (($time - ref_collision) >= tCEM)) begin
                ref_collision = $time;
                random_delay = latency_counter;

                if (debug) $display ($time, 
                " ns. Note: Synch - Initialize Read, Wait = %d",random_delay);
            end

            // Set wait state
            if (debug3) $display ($time, "  oWait Trigger 3");
            rwait = wait_polarity;

            // Latch address
            sync_addr_in = Addr;
            if (Addr [6:0] === 127) begin
                StartBurstOnLastAddr = 1'b1;
            end

            // Reset counter
            counter = 0;

            // Register byte write
            lb_reg = Lb_n;
            ub_reg = Ub_n;

// should be different for variable and fixed
            // Latency counter
            case (latency_counter)
                3'b010 : latency_counter_pipeline [3 + random_delay] = 2'b01;
                3'b011 : latency_counter_pipeline [4 + random_delay] = 2'b01;
                3'b100 : latency_counter_pipeline [5 + random_delay] = 2'b01;
                3'b101 : latency_counter_pipeline [6 + random_delay] = 2'b01;
                3'b110 : latency_counter_pipeline [7 + random_delay] = 2'b01;
            endcase

            // Display debug message
            if (debug) $display ($time,
                " ns.  Note: Synch - Initialize Read, Addr = %h",Addr);
        end
    end
    endtask

    // Synchronous initial burst write
    task synchronous_initial_burst_write;
        integer random_delay;
    begin
        if (debug2) $display("synchronous_initial_burst_write");
        if (~Adv_n && ~Ce_n && Oe_n && ~We_n && ~Cre) begin
            // Initialize random delay
            random_delay = 0;

            // Clear row crossing with a new access
            if (row_end == 1'b1) begin
                row_end = 1'b0;
            end

            // CR1.5 writes are always fixed latency
            // CR1.0 has variable latency during initial writes
            `ifdef CR10
                // Random refresh cycle collision generator
                if (($time - ref_collision) >= tCEM) begin
                    ref_collision = $time;
                    random_delay = latency_counter;
                    if (debug) $display ($time, " ns.  Note: 
                       Sync - Initialize Write, Wait fixed 
                       latency, thus always zero = %d",random_delay);
                end
            `endif

            // Set wait state
            if (debug3) $display ($time, "  oWait Trigger 4");
            rwait = wait_polarity;

            // Latch address
            sync_addr_in = Addr;
            if (Addr [6:0] === 127) begin
                StartBurstOnLastAddr = 1'b1;
            end
            row_start = Addr[7];

            // Reset counter
            counter = 0;

            // Latency counter
            case (latency_counter)
                3'b010 : latency_counter_pipeline [3 + random_delay] = 2'b00;
                3'b011 : latency_counter_pipeline [4 + random_delay] = 2'b00;
                3'b100 : latency_counter_pipeline [5 + random_delay] = 2'b00;
                3'b101 : latency_counter_pipeline [6 + random_delay] = 2'b00;
                3'b110 : latency_counter_pipeline [7 + random_delay] = 2'b00;
            endcase

            // Display debug message
            if (debug) $display ($time, 
                " ns.  Note: Sync - Initialize Write, Addr = %h", Addr);
        end
    end
    endtask

    // Synchronous configuration register
    task synchronous_configuration_register;
        begin
        if (debug2) $display("synchronous_configuration_register");
        if (~Ce_n && We_n && async_config_enable) begin
            if (debug3) $display ($time, "  oWait Trigger 5a (sync config read)");
                sync_config_read = 1'b1;
                // Set wait state
                rwait = wait_polarity;

                // Latency counter
                case (latency_counter)
                    3'b010 : latency_counter_pipeline [3] = 2'b01;
                    3'b011 : latency_counter_pipeline [4] = 2'b01;
                    3'b100 : latency_counter_pipeline [5] = 2'b01;
                    3'b101 : latency_counter_pipeline [6] = 2'b01;
                    3'b110 : latency_counter_pipeline [7] = 2'b01;
                endcase

                // Read configuration register
                if (Addr [19:18] == 2'b10) begin
                    sync_data_out = bus_conf_register;
                end 
                if (Addr [19:18] == 2'b00) begin
                    sync_data_out = ref_conf_register;
                end
                if (Addr [19:18] == 2'b01) begin
                    sync_data_out = didr_conf_register;
                end

                // Display debug message
                if (debug) $display ($time, 
                " ns.  Note: Sync - Configuration Register Read, Addr[19:18] = %h",
                Addr[19:18]);
            end
        if (~Adv_n && ~Ce_n && Oe_n && ~We_n && Cre) begin
            if (debug3) $display ($time, "  oWait Trigger 5b (sync config write)");
                // Set wait state
                rwait = wait_polarity;

                // Latency counter
                case (latency_counter)
                    3'b010 : latency_counter_pipeline [3] = 2'b00;
                    3'b011 : latency_counter_pipeline [4] = 2'b00;
                    3'b100 : latency_counter_pipeline [5] = 2'b00;
                    3'b101 : latency_counter_pipeline [6] = 2'b00;
                    3'b110 : latency_counter_pipeline [7] = 2'b00;
                endcase

                // Write configuration register
                if (Addr [19:18] == 2'b10) begin
                    bus_conf_register = Addr;
                end 
                if (Addr [19:18] == 2'b00) begin
                    ref_conf_register = Addr;
                end

                // Display debug message
                if (debug) $display ($time, 
                " ns.  Note: Sync - Configuration Register Write, Addr = %h",
                Addr);
        end
    end
    endtask

    // Synchronous wait controller
    task synchronous_wait_controller;
        begin
            if (debug2) $display("synchronous_wait_controller");
            if (~wait_configuration) begin
                if (StartBurstOnLastAddr) begin
                    if (latency_counter_pipeline [0] === 2'b01) begin
                    rwait = wait_polarity;
                    StartBurstOnLastAddr = 'b0;
                    end
                end
                if ((latency_counter_pipeline [1] === 2'b00) ||
                    (latency_counter_pipeline [1] === 2'b01) ||
                    (latency_counter_pipeline [2] === 2'b10)) begin
                    if (debug3) $display ($time, "  oWait Trigger 6");
                    rwait = ~wait_polarity;
                end
            end else begin
                if (StartBurstOnLastAddr) begin
                    if (latency_counter_pipeline [1] === 2'b01) begin
                    rwait = wait_polarity;
                    StartBurstOnLastAddr = 'b0;
                    end
                end
                if ((latency_counter_pipeline [2] === 2'b00) ||
                    (latency_counter_pipeline [2] === 2'b01) ||
                    (latency_counter_pipeline [3] === 2'b10)) begin
                    if (debug3) $display ($time, "  oWait Trigger 7");
                    rwait = ~rwait;
                end
            end
        end
    endtask

    // Synchronous CE# termination
    task synchronous_ce_termination;
        begin
            if (debug2) $display("synchronous_ce_termination");
            if (Ce_n) begin
                // Terminate read
                if (sync_data_out_enable) begin
                    sync_data_out_enable = 1'b0;
                end

                // Terminate write
                if (sync_data_in_enable) begin
                    sync_data_in_enable = 1'b0;
                end

                // Clear row end, since access is complete
                if (row_end == 1'b1) begin
                    row_end = 1'b0;
                end

                // Terminate wait
                    if (debug3) $display ($time, "  oWait Trigger 8");
                rwait = 1'bz;
            end
            if (Adv_n==1'b0) begin
                // Terminate read
                if (sync_data_out_enable) begin
                    sync_data_out_enable = 1'b0;
                end

                // Terminate write
                if (sync_data_in_enable) begin
                    sync_data_in_enable = 1'b0;
                end

                // Clear row end, since access is complete
                if (row_end == 1'b1) begin
                    row_end = 1'b0;
                end
            end
        end
    endtask

    // Synchronous read burst
    task synchronous_read_burst;
        begin
            if (debug2) $display("synchronous_read_burst");
            if (sync_data_out_enable === 1'b1 && row_end === 1'b0 && !sync_config_read) begin
                if (sync_addr_in [6:0] !== 127) begin
                    // Set Wait
                        if (debug3) $display ($time, "  oWait Trigger 9");
                    rwait = ~wait_polarity;
                end
                // Lower byte
                case (lb_reg)
                    1'b0    : sync_data_out [7 : 0] = Bank0 [sync_addr_in];
                    //default : sync_data_out [7 : 0] = 8'bz;
                    default : begin
                                 sync_data_out [7 : 0] = Bank0 [sync_addr_in];
                                 $display ($time, "ERROR:  Lb_n must be zero for read");
                              end
                endcase

                // Upper byte
                case (ub_reg)
                    1'b0    : sync_data_out [15 : 8] = Bank1 [sync_addr_in];
                    //default : sync_data_out [15 : 8] = 8'bz;
                    default : begin
                                 sync_data_out [15 : 8] = Bank1 [sync_addr_in];
                                 $display ($time, "ERROR:  Ub_n must be zero for read");
                              end
                endcase

                // Advance counter
                counter = counter + 1;

                // Register new byte write
                if (counter >= 1) begin
                    lb_reg = Lb_n;
                    ub_reg = Ub_n;
                end

                // Terminate write depending on burst length
                if (((counter >  4) && (burst_length === 3'b001)) ||
                    ((counter >  8) && (burst_length === 3'b010)) ||
                    ((counter > 16) && (burst_length === 3'b011)) ||
                    ((counter > 32) && (burst_length === 3'b100))) begin
                    sync_data_out_enable = 1'b0;
                end

                // Display debug message
                if (~lb_reg && ~ub_reg && sync_data_out_enable) begin
                    if (debug) 
                       $display ($time, " ns.  ** Note: Sync - Read, Addr = %h, Data = %h", sync_addr_in, sync_data_out);
                end

                // Advance address
                if (burst_wrap === 1'b0) begin
                    // Wrap within the burst length
                    case (burst_length)
                        3'b001  : sync_addr_in [1 : 0] = sync_addr_in [1 : 0] + 1;
                        3'b010  : sync_addr_in [2 : 0] = sync_addr_in [2 : 0] + 1;
                        3'b011  : sync_addr_in [3 : 0] = sync_addr_in [3 : 0] + 1;
                        3'b100  : sync_addr_in [4 : 0] = sync_addr_in [4 : 0] + 1;
                        default : sync_addr_in         = sync_addr_in         + 1;
                    endcase
                end else begin
                    // Row end
                    if ((sync_data_out_enable === 1'b1) && (burst_wrap === 1'b1)) begin
                        if (sync_addr_in [6:0] === 127) begin
                            row_end = 1'b1;
                            row_count = latency_counter + 1;
                            if (~wait_configuration) begin
                                if (debug3) $display ($time, "  oWait Trigger 10a");
                                rwait = wait_polarity;
                            end
                        end else if (sync_addr_in [6:0] === 126) begin 
                            if (wait_configuration) begin
                                if (debug3) $display ($time, "  oWait Trigger 10b");
                                rwait = wait_polarity;
                            end
                        end
                    end

                    // Burst no wrap
                    sync_addr_in = sync_addr_in + 1;
                end

            end else if (sync_data_out_enable === 1'b1 && row_end === 1'b1) begin
                sync_data_out = 16'bz;
                if (debug3) $display ($time, "  oWait Trigger 11");
                rwait = wait_polarity;
                row_count = row_count - 1;

                if (row_count <= 1) begin
                    row_end = 1'b0;
                end

                if (row_count <= 1 && ~wait_configuration) begin
                    //if (wait_configuration) begin
                        if (debug3) $display ($time, "  oWait Trigger 12a");
                        rwait = ~wait_polarity;
                    //end
                end 
                if (row_count <= 2 && wait_configuration) begin
                    //if (wait_configuration) begin
                        if (debug3) $display ($time, "  oWait Trigger 12b");
                        rwait = ~wait_polarity;
                    //end
                end
            end
        end
    endtask

    // Synchronous Write burst
    task synchronous_write_burst;
        begin
            if (debug2) $display("synchronous_write_burst");
            if (sync_data_in_enable) begin
            //if (sync_data_in_enable && (wait_polarity === ~oWait) && (row_end === 1'b0)) begin
                if (CornerCase === latency_counter)begin
                    // Lower Byte
                    if (~LatchCornerCaseLb_n) begin
                        Bank0 [sync_addr_in] = LatchCornerCaseLower;
                    end
    
                    // Upper Byte
                    if (~LatchCornerCaseUb_n) begin
                        Bank1 [sync_addr_in] = LatchCornerCaseUpper;
                    end
    
                    // Display debug message
                    if (debug && (~LatchCornerCaseLb_n || ~LatchCornerCaseUb_n)) $display ($time, 
                        " ns.  * CORNER CASE *: Sync - Write, Addr = %h, LData = %h UData = %h", 
                          sync_addr_in, LatchCornerCaseLower, LatchCornerCaseUpper);
                    //CornerCase = 'b0;
                    CornerCase = CornerCase + 1;
                    LatchCornerCaseLower = 'bz;
                    LatchCornerCaseUpper = 'bz;
                    LatchCornerCaseLb_n = 'bz;
                    LatchCornerCaseUb_n = 'bz;

                    // Advance address
                    if (wait_configuration === 1'b0) sync_addr_in = sync_addr_in + 1;
                end else if ((wait_polarity === ~oWait) && (row_end === 1'b0))begin
                    // Lower Byte
                    if (~Lb_n) begin
                        Bank0 [sync_addr_in] = Dq [7 : 0];
                    end

                    // Upper Byte
                    if (~Ub_n) begin
                        Bank1 [sync_addr_in] = Dq [15 : 8];
                    end

                    // Display debug message
                    if (debug && (~Lb_n || ~Ub_n)) $display ($time, 
                        " ns.  ## Note: Sync - Write, Addr = %h, Data = %h", 
                        sync_addr_in, Dq);
                end
            end
            if (sync_data_in_enable && (wait_polarity === ~oWait) && (row_end === 1'b0)) begin
                if (burst_wrap === 1'b0) begin
                    // Wrap within the burst length
                    //$display ("%t burst_wrap=0, burst_length %d (0x%h)", $time, burst_length, burst_length);
                    case (burst_length)
                        3'b001  : sync_addr_in [1 : 0] = sync_addr_in [1 : 0] + 1;
                        3'b010  : sync_addr_in [2 : 0] = sync_addr_in [2 : 0] + 1;
                        3'b011  : sync_addr_in [3 : 0] = sync_addr_in [3 : 0] + 1;
                        3'b100  : sync_addr_in [4 : 0] = sync_addr_in [4 : 0] + 1;
                        default : sync_addr_in         = sync_addr_in         + 1;
                    endcase
                end else begin
                    // Row end
                    //$display ("%t burst_wrap/=0, burst_length %d (0x%h)", $time, burst_length, burst_length);
                    if ((sync_data_in_enable === 1'b1) &&
                        (sync_addr_in [6 : 0] === 127) && 
                        (burst_wrap === 1'b1)) begin
                        if (wait_configuration) begin
                            if (debug3) $display ($time, "  oWait Trigger 13");
                            rwait = wait_polarity;
                        end
                        row_end = 1'b1;
                        row_count = latency_counter + 1;
                    end

                    // Burst no wrap
                    sync_addr_in = sync_addr_in + 1;
                end

            end else if ((sync_data_in_enable === 1'b1) && (row_end === 1'b1)) begin
                sync_data_out = 16'bz;
                if (
                    (CornerCase === 'b0) 
                     //&& 
                    //(wait_configuration === 1'b1)
                     //||
                    //((wait_configuration === 1'b0) && (row_end === 1'b1) && (last_row_end === 1'b1) && (last_row_end2 === 1'b0))
                   ) begin
                    if (debug) $display ($time, "--------Write Across Row Boundary Corner Case---------");
                    LatchCornerCaseLb_n  = Lb_n;
                    LatchCornerCaseUb_n  = Ub_n;
                    LatchCornerCaseLower = Dq [7 : 0];
                    LatchCornerCaseUpper = Dq [15 : 8];
                    if (debug) $display ($time, " Latch Next Row - Col 0 : Ldata = %h : Udata = %h", LatchCornerCaseLower, LatchCornerCaseUpper);
                end
            //end else if ((sync_data_in_enable === 1'b1) && (row_end === 1'b1)) begin

                CornerCase = CornerCase + 1;

                if (debug3) $display ($time, "  oWait Trigger 14");
                rwait = wait_polarity;
                row_count = row_count - 1;

                if ((row_count <= 1) && wait_configuration) begin
                    row_end = 1'b0;
                    if (debug3) $display ($time, "  oWait Trigger 15a");
                    rwait = ~wait_polarity;
                end
                if ((row_count <= 0) && ~wait_configuration) begin
                    row_end = 1'b0;
                    if (debug3) $display ($time, "  oWait Trigger 15b");
                    rwait = ~wait_polarity;
                end
            end
        end
    endtask


    always @ (posedge operating_mode) begin
        Sync2AsyncConfig = latency_counter;
    end

    // Main Synchronous block
    always @ (posedge sys_clk) begin
        if (~operating_mode || Sync2AsyncConfig) begin   // Sync
            if (debug2) $display ("Main Synchronous Block");
       	    synchronous_internal_command_pipeline;

            synchronous_initial_burst_read;

            synchronous_initial_burst_write;

            synchronous_configuration_register;

            synchronous_wait_controller;

            synchronous_ce_termination;

            synchronous_read_burst;

            synchronous_write_burst;

            if (Sync2AsyncConfig > 3'b000) begin
                Sync2AsyncConfig = Sync2AsyncConfig - 1;
            end
	end

        sys_reset = ~Ce_n;
    end

    // System clock generator
    always @ (Clk) begin
       sys_clk =  Clk;
    end
        //case (clock_configuration)
            //1'b1    : sys_clk = ~Clk;
            //1'b0    : sys_clk =  Clk;
            //default : sys_clk =  Clk;
        //endcase
    //end

    // Wait buffer
    always @ (rwait) begin
        bwait <= #tCEW rwait;
        //bwait <= rwait;
    end

    always @ (negedge last_row_end2) begin
        CornerCase = 'b0;
    end

    // Output buffer
    always @ (async_data_out or sync_data_out) begin
        case (sys_reset)
            1'b0    : data_out = async_data_out;
            default : data_out = sync_data_out;
        endcase
    end

endmodule

