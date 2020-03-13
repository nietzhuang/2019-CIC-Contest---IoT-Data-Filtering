module cgate(
        input   clk,
        input   enable,

        output  clk_gate,
        output  func_en
        );

        assign clk_gate = (enable)? clk:1'b0;
        assign func_en  = (enable)? 1'b1:1'b0;

endmodule
