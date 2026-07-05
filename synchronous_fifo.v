`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2026 19:29:46
// Design Name: 
// Module Name: synchronous_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module synchronous_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = 3 // 2^3 = 8 locations
)(
    input  wire                    clk,       // Clock signal
    input  wire                    rst_n,     // Active-low reset
    input  wire                    wr_en,     // Write Enable
    input  wire                    rd_en,     // Read Enable
    input  wire [DATA_WIDTH-1:0]   data_in,   // Data to be written
    output reg  [DATA_WIDTH-1:0]   data_out,  // Data to be read
    output wire                    full,      // FIFO is full flag
    output wire                    empty,     // FIFO is empty flag
    output reg  [ADDR_WIDTH:0]     fifo_cnt   // Keeps track of elements in FIFO
);

    // Internal Memory Array
    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];
    
    // Internal Pointers
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;

    // 1. Generate Full and Empty Flags
    assign empty = (fifo_cnt == 0);
    assign full  = (fifo_cnt == DEPTH);

    // 2. Manage FIFO Counter (Tracks how many items are inside)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fifo_cnt <= 0;
        end else begin
            case ({wr_en, rd_en})
                2'b10: if (!full)  fifo_cnt <= fifo_cnt + 1; // Write only
                2'b01: if (!empty) fifo_cnt <= fifo_cnt - 1; // Read only
                2'b11: fifo_cnt <= fifo_cnt;                 // Concurrent Write & Read
                default: fifo_cnt <= fifo_cnt;               // No operation
            endcase
        end
    end

    // 3. Write Operation & Write Pointer Update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            memory[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1; // Wraps around automatically because of size
        end
    end

    // 4. Read Operation & Read Pointer Update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr   <= 0;
            data_out <= 0;
        end else if (rd_en && !empty) begin
            data_out <= memory[rd_ptr];
            rd_ptr   <= rd_ptr + 1; // Wraps around automatically
        end
    end

endmodule
