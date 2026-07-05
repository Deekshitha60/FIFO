`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2026 19:30:31
// Design Name: 
// Module Name: tb_synchronous_fifo
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


`timescale 1ns / 1ps

module tb_synchronous_fifo;

    reg clk;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire full;
    wire empty;
    wire [3:0] fifo_cnt;

    // Instantiate the FIFO
    synchronous_fifo uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .fifo_cnt(fifo_cnt)
    );

    // Clock Generation (50MHz)
    always #10 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // Hold reset for 40ns
        #40;
        rst_n = 1;
        #20;
        
        // --- Test Case 1: Write data until FULL ---
        $display("Starting Writes...");
        write_data(8'hAA);
        write_data(8'hBB);
        write_data(8'hCC);
        write_data(8'hDD);
        write_data(8'hEE);
        write_data(8'hFF);
        write_data(8'h11);
        write_data(8'h22); // FIFO should be full now
        
        #20;
        
        // --- Test Case 2: Read data until EMPTY ---
        $display("Starting Reads...");
        read_data();
        read_data();
        read_data();
        read_data();
        read_data();
        read_data();
        read_data();
        read_data(); // FIFO should be empty now

        #40;
        $finish;
    end
    
    // Tasks for cleaner testbench code
    task write_data(input [7:0] data);
        begin
            @(posedge clk);
            if (!full) begin
                wr_en = 1;
                data_in = data;
            end
            @(posedge clk);
            wr_en = 0;
        end
    endtask

    task read_data();
        begin
            @(posedge clk);
            if (!empty) begin
                rd_en = 1;
            end
            @(posedge clk);
            rd_en = 0;
        end
    endtask
      
endmodule