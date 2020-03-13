module f1(
        input                   clk,
        input                   rst,
        input                   f1_en,
        input                   valid,
        input [127:0]           data,
        input [3:0]             cnt_cycle,
        input [2:0]             cnt_data,

        output reg[127:0]       out_f1
        );

        reg [127:0]     buff;

        always@(posedge clk, posedge rst)begin
                if(rst)
                        buff <= 128'b0;
                else if((cnt_cycle == 4'd15) && (cnt_data != 3'd0) && (data > buff))
                        buff <= data;
                else if((cnt_cycle == 4'd0) &&(cnt_data == 3'd0))  // flush buffer.
                        buff <= 128'b0;
        end

        always@*begin
                if(f1_en)begin
                        if(valid)
                                out_f1 = (buff > data)? buff:data;
                        else
                                out_f1 = 128'b0;
                end
                else
                        out_f1 = 128'b0;
        end
        
endmodule        
