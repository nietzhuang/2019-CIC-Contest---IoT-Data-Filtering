module f3(
        input                   clk,
        input                   rst,
        input                   f3_en,
        input                   valid,
        input [127:0]           data,
        input [3:0]             cnt_cycle,
        input [2:0]             cnt_data,

        output reg[127:0]       out_f3
        );

        reg [130:0]     buff;

        always@(posedge clk, posedge rst)begin
                if(rst)
                        buff <= 131'b0;
                else if((cnt_cycle == 4'd15) && (cnt_data != 3'd0))
                        buff <= buff + data;
                else if((cnt_cycle == 4'd0) &&(cnt_data == 3'd0))  // flush buffer.
                        buff <= 131'b0;
        end

        always@*begin
                if(f3_en)begin
                        if(valid)
                                out_f3 = ((buff+data) >> 3);
                        else
                                out_f3 = 128'b0;
                end
                else
                        out_f3 = 128'b0;
        end

endmodule
