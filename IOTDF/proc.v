module proc(
        input                   clk,
        input                   clk_f1,
        input                   clk_f2,
        input                   clk_f3,
        input                   clk_f6,
        input                   clk_f7,
        input                   f1_en,
        input                   f2_en,
        input                   f3_en,
        input                   f4_en,
        input                   f5_en,
        input                   f6_en,
        input                   f7_en,
        input                   rst,
        input                   in_en,
        input                   valid,
        input [7:0]             iot_in,
        input [2:0]             fn_sel,
        input [3:0]             cnt_cycle,
        input [2:0]             cnt_data,

        output                  out_en,
        output reg[127:0]       iot_out
        );
        
        integer i;
        wire [127:0]    out_f1, out_f2, out_f3, out_f4, out_f5, out_f6, out_f7;
        wire            outf4_en, outf5_en, outf6_en, outf7_en;
        reg  [127:0]    mem;
        reg  [7:0]      buf_in[14:0];
        
        
        f1 max(.clk(clk_f1),
               .rst(rst),
               .f1_en(f1_en),
               .data(mem),
               .valid(valid),
               .cnt_cycle(cnt_cycle),
               .cnt_data(cnt_data),
               .out_f1(out_f1)
               );
        f2 min(.clk(clk_f2),
               .rst(rst),
               .f2_en(f2_en),
               .data(mem),
               .valid(valid),
               .cnt_cycle(cnt_cycle),
               .cnt_data(cnt_data),
               .out_f2(out_f2)
               );
        f3 avg(.clk(clk_f3),
               .rst(rst),
               .f3_en(f3_en),
               .valid(valid),
               .data(mem),
               .cnt_cycle(cnt_cycle),
               .cnt_data(cnt_data),
               .out_f3(out_f3)
               );
       f4 ext(.f4_en(f4_en),
               .data(mem),
               .cnt_cycle(cnt_cycle),
               .outf4_en(outf4_en),
               .out_f4(out_f4)
               );
        f5 exc(.f5_en(f5_en),
               .data(mem),
               .cnt_cycle(cnt_cycle),
               .outf5_en(outf5_en),
               .out_f5(out_f5)
               );
        f6 p_max(.clk(clk_f6),
                 .rst(rst),
                 .f6_en(f6_en),
                 .data(mem),
                 .cnt_cycle(cnt_cycle),
                 .cnt_data(cnt_data),
                 .outf6_en(outf6_en),
                 .out_f6(out_f6)
                 );
        f7 p_min(.clk(clk_f7),
                 .rst(rst),
                 .f7_en(f7_en),
                 .data(mem),
                 .cnt_cycle(cnt_cycle),
                 .cnt_data(cnt_data),
                 .outf7_en(outf7_en),
                 .out_f7(out_f7)
                 );
                 
       mux_out mux_out(.outf4_en(outf4_en),
                        .outf5_en(outf5_en),
                        .outf6_en(outf6_en),
                        .outf7_en(outf7_en),
                        .fn_sel(fn_sel),
                        .out_en(out_en)
                        );
        // IOT input
        always@(posedge clk, posedge rst)begin
                if(rst)begin
                        mem <= 128'b0;
                        for(i = 0; i < 15; i = i + 1)
                                buf_in[i] <= 8'b0;
                end
                else if(cnt_cycle == 4'd15)
                        mem <= {buf_in[0],  buf_in[1],  buf_in[2],   buf_in[3], buf_in[4], buf_in[5],
                                buf_in[6],  buf_in[7],  buf_in[8],   buf_in[9], buf_in[10], buf_in[11],
                                buf_in[12], buf_in[13], buf_in[14],  iot_in};
                else if(in_en)begin
                        buf_in[cnt_cycle] <= iot_in;
                end
        end

        // IOT output 
        always@*begin
                case(fn_sel)
                        3'b001:iot_out = out_f1;
                        3'b010:iot_out = out_f2;
                        3'b011:iot_out = out_f3;
                        3'b100:iot_out = out_f4;
                        3'b101:iot_out = out_f5;
                        3'b110:iot_out = out_f6;
                        3'b111:iot_out = out_f7;
                        default: iot_out = 128'd0;
                endcase
        end
        
endmodule
