module f4(
        input                   f4_en,
        input [127:0]           data,
        input [3:0]             cnt_cycle,

        output reg              outf4_en,
        output reg[127:0]       out_f4
        );

        parameter LOW  = 128'h6FFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
        parameter HIGH = 128'hAFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;

        always@*begin
                if(f4_en)begin
                        if((cnt_cycle == 4'd1) && (data > LOW) && (data < HIGH))
                                outf4_en = 1'b1;
                        else
                                outf4_en = 1'b0;
                end
                else
                        outf4_en = 1'b0;
        end

        always@*begin
                if(outf4_en)
                        out_f4 = data;
                else
                        out_f4 = 128'b0;
        end
endmodule
