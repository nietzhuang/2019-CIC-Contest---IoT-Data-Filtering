module ctrl(
        input                   clk,
        input                   rst,
        input                   in_en,
        input      [2:0]        fn_sel,
        input                   out_en,

        output reg              busy,
        output reg              valid,
        output reg [3:0]        cnt_cycle,  // used to count 16 cycle.
        output reg [2:0]        cnt_data  // used to count 8 number of data.
        );

        parameter WAIT = 2'b00, IN_CAL = 2'b01, OUT = 2'b10;
        reg [1:0] cstate, nstate;


        //  Counter
        always@(posedge clk, posedge rst)begin
                if(rst)
                        cnt_cycle <= 4'b0;
                else if(cstate == IN_CAL)
                        cnt_cycle <= cnt_cycle + 1;
        end
        always@(posedge clk, posedge rst)begin
                if(rst)
                        cnt_data <= 3'b0;
                else if(cnt_cycle == 4'd15)
                        cnt_data <= cnt_data + 1;
        end

        // State
        always@(posedge clk, posedge rst)begin
                if(rst)
                        cstate <= WAIT;
                else
                        cstate <= nstate;
        end

        always@*begin
                case(cstate)
                        WAIT:begin
                                nstate = IN_CAL;
                        end
                        IN_CAL:begin
                                case(fn_sel)
                                        3'b001, 3'b010, 3'b011:begin
                                                if((cnt_cycle == 4'd15)&&(cnt_data == 3'd7))
                                                        nstate = OUT;
                                                else if(cnt_cycle == 4'd15)
                                                        nstate = WAIT;
                                                else
                                                        nstate = IN_CAL;
                                        end
                                        3'b100, 3'b101, 3'b110, 3'b111:begin// F4 Extract, F5 Exclude, F6 Peak Maximum, F7 Peak Minimum.
                                                if(cnt_cycle == 4'd15)
                                                        nstate = WAIT;
                                                else
                                                        nstate = IN_CAL;
                                        end
                                endcase
                        end
                        OUT:
                                nstate = IN_CAL;
                endcase
        end

        always@*begin  // Notice the output condition for F6, F7.
                case(cstate)
                        WAIT:begin
                                busy = 1'b0;
                                valid = (out_en  && (fn_sel != 3'b111));
                        end
                        IN_CAL:begin
                                busy = (cnt_cycle == 4'd15);
                                if(fn_sel == 3'b111)
                                        valid = (out_en && (cnt_cycle == 4'd1));
                                else
                                        valid = out_en;
                        end
                        OUT:begin
                                busy = 1'b0;
                                valid = 1'b1;
                        end
                endcase
        end
        
endmodule
