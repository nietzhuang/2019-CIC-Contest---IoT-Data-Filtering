module mux_out(
        input           outf4_en,
        input           outf5_en,
        input           outf6_en,
        input           outf7_en,
        input   [2:0]   fn_sel,

        output reg      out_en
        );

        always@*begin
                case(fn_sel)
                        3'b100:out_en = outf4_en;
                        3'b101:out_en = outf5_en;
                        3'b110:out_en = outf6_en;
                        3'b111:out_en = outf7_en;
                        default:out_en = 1'b0;
                endcase
        end
endmodule
