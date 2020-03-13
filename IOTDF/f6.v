module f6(
        input                   clk,
        input                   rst,
        input                   f6_en,
        input [127:0]           data,
        input [3:0]             cnt_cycle,
        input [2:0]             cnt_data,

        output reg              outf6_en,
        output reg[127:0]       out_f6
        );

        reg [127:0]             buff, buff_pmax;
        reg                     flag;

        always@(posedge clk, posedge rst)begin
                if(rst)
                        buff <= 128'b0;
                else if((cnt_cycle == 4'd1) && (cnt_data != 3'd0) && (data > buff))
                        buff <= data;
                else if((cnt_cycle == 4'd0) && (cnt_data == 3'd0))  // flush buffer.                
                        buff <= data;

        end
        always@(posedge clk, posedge rst)begin
                if(rst)begin
                        buff_pmax <= 128'b0;
                        flag <= 1'b0;
                end
                else if(/*(cnt_cycle == 4'd15) &&*/ (buff > buff_pmax))begin
                        buff_pmax <= buff;
                        flag <= 1'b1;
                end
        end

        always@*begin
                if(f6_en)begin
                        if(flag && (cnt_data == 3'b0))
                                outf6_en = 1'b1;
                        else
                                outf6_en = 1'b0;
                end
                else
                        outf6_en = 1'b0;
        end
        always@*begin
                if(outf6_en)
                        out_f6 = buff_pmax;
                else
                        out_f6 = 128'b0;
        end
endmodule
