module hw_traffic(
    input logic clk,
    input logic reset,
    input logic taorb,
    output logic [1:0] la,
    output logic [1:0] lb
);

typedef enum logic [1:0] {
    AG_BR,
    AY_BR,
    AR_BG,
    AR_BY
} state_t;

state_t state;
state_t next_state;

logic [2:0] timer;
logic timer_done;

assign timer_done = (timer == 3'd4);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        state <= AG_BR;
    else
        state <= next_state;
end

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        timer <= 3'd0;
    else begin
        case (state)
            AY_BR, AR_BY: begin
                if (next_state != state)
                    timer <= 3'd0;
                else
                    timer <= timer + 3'd1;
            end
            default: timer <= 3'd0;
        endcase
    end
end

always_comb begin
    next_state = state;

    case (state)
        AG_BR: begin
            if (taorb)
                next_state = AY_BR;
        end

        AY_BR: begin
            if (timer_done)
                next_state = AR_BG;
        end

        AR_BG: begin
            if (!taorb)
                next_state = AR_BY;
        end

        AR_BY: begin
            if (timer_done)
                next_state = AG_BR;
        end
    endcase
end

always_comb begin
    la = 2'b00;
    lb = 2'b00;

    case (state)
        AG_BR: begin
            la = 2'b10;
            lb = 2'b01;
        end

        AY_BR: begin
            la = 2'b11;
            lb = 2'b01;
        end

        AR_BG: begin
            la = 2'b01;
            lb = 2'b10;
        end

        AR_BY: begin
            la = 2'b01;
            lb = 2'b11;
        end
    endcase
end

endmodule