`timescale 1ns/10ps
`include "proc.v"
`include "ctrl.v"
`include "cgate.v"
`include "f1.v"
`include "f2.v"
`include "f3.v"
`include "f4.v"
`include "f5.v"
`include "f6.v"
`include "f7.v"
`include "mux_out.v"

module IOTDF( clk, rst, in_en, iot_in, fn_sel, busy, valid, iot_out);
        input          clk;
        input          rst;
        input          in_en;
        input  [7:0]   iot_in;
        input  [2:0]   fn_sel;
        output         busy;
        output         valid;
        output [127:0] iot_out;

        wire [3:0] cnt_cycle;
        wire [2:0] cnt_data;
        wire out_en;
        wire clk_f1, clk_f2, clk_f3, clk_f4, clk_f5, clk_f6, clk_f7;
        wire f1_en, f2_en, f3_en, f4_en, f5_en, f6_en, f7_en;

        ctrl ctrl0(.clk(clk),
                   .rst(rst),
                   .in_en(in_en),
                   .fn_sel(fn_sel),
                   .out_en(out_en),
                   .busy(busy),
                   .valid(valid),
                   .cnt_cycle(cnt_cycle),
                   .cnt_data(cnt_data)
                   );

        proc proc0(.clk(clk),
                   .clk_f1(clk_f1),
                   .clk_f2(clk_f2),
                   .clk_f3(clk_f3),
                   .clk_f6(clk_f6),
                   .clk_f7(clk_f7),
                   .f1_en(f1_en),
                   .f2_en(f2_en),
                   .f3_en(f3_en),
                   .f4_en(f4_en),
                   .f5_en(f5_en),
                   .f6_en(f6_en),
                   .f7_en(f7_en),
                   .rst(rst),
                   .valid(valid),
                   .in_en(in_en),
                   .iot_in(iot_in),
                   .fn_sel(fn_sel),
                   .cnt_cycle(cnt_cycle),
                   .cnt_data(cnt_data),
                   .out_en(out_en),
                   .iot_out(iot_out)
                   );

        cgate cg_f1(.clk(clk),
                    .enable(fn_sel == 3'b001),
                    .clk_gate(clk_f1),
                    .func_en(f1_en)
                    );
        cgate cg_f2(.clk(clk),
                    .enable(fn_sel == 3'b010),
                    .clk_gate(clk_f2),
                    .func_en(f2_en)
                    );
        cgate cg_f3(.clk(clk),
                    .enable(fn_sel == 3'b011),
                    .clk_gate(clk_f3),
                    .func_en(f3_en)
                    );
        cgate cg_f4(.clk(clk),
                    .enable(fn_sel == 3'b100),
                    .clk_gate(clk_f4),
                    .func_en(f4_en)
                    );
        cgate cg_f5(.clk(clk),
                    .enable(fn_sel == 3'b101),
                    .clk_gate(clk_f5),
                    .func_en(f5_en)
                    );
        cgate cg_f6(.clk(clk),
                    .enable(fn_sel == 3'b110),
                    .clk_gate(clk_f6),
                    .func_en(f6_en)
                    );
        cgate cg_f7(.clk(clk),
                    .enable(fn_sel == 3'b111),
                    .clk_gate(clk_f7),
                    .func_en(f7_en)
                    );
endmodule
