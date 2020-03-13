module f5(
        input                   f5_en,
        input [127:0]           data,
        input [3:0]             cnt_cycle,

        output reg              outf5_en,
        output reg[127:0]       out_f5
        );

        parameter LOW  = 128'h7FFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
        parameter HIGH = 128'hBFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;

        always@*begin
                if(f5_en)begin
                        if((cnt_cycle == 4'd1) && (data[15:0] != 16'd0) && ((data < LOW) || (data > HIGH)))
                                outf5_en = 1'b1;
                        else
                                outf5_en = 1'b0;
                end
                else
                        outf5_en = 1'b0;
        end

        always@*begin
                if(outf5_en)
                        out_f5 = data;
                else
                        out_f5 = 128'b0;
        end
endmodule
