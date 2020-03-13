module f7(
        input                   clk,
        input                   rst,
        input                   f7_en,
        input [127:0]           data,
        input [3:0]             cnt_cycle,
        input [2:0]             cnt_data,

        output reg              outf7_en,
        output reg[127:0]       out_f7
        );

        reg [127:0]             buff, buff_pmin;
        reg                     flag;

        always@(posedge clk, posedge rst)begin
                if(rst)
                        buff <= 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
                else if((cnt_cycle == 4'd15) && (cnt_data != 3'd0) && (data < buff) && (data != 128'b0))
                        buff <= data;
                else if((cnt_cycle == 4'd0) && (cnt_data == 3'd0) && (data != 128'b0))  // flush buffer.                
                        buff <= data;

        end
        always@(posedge clk, posedge rst)begin
                if(rst)begin
                        buff_pmin <= 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
                        flag <= 1'b0;
                end
                else if(/*(cnt_cycle == 4'd15) &&*/(buff < buff_pmin))begin
                        buff_pmin <= buff;
                        flag <= 1'b1;
                end
                else if(cnt_data == 3'd1)
                        flag <= 1'b0;

        end

        always@*begin
                if(f7_en)begin
                        if(flag && (cnt_data == 3'd0))
                                outf7_en = 1'b1;
                        else
                                outf7_en = 1'b0;
                end
                else
                        outf7_en = 1'b0;
        end
        always@*begin
                if(outf7_en)
                        out_f7 = (data<buff_pmin)? data:buff_pmin;    //buff_pmin;
                else
                        out_f7 = 128'b0;
        end
endmodule
