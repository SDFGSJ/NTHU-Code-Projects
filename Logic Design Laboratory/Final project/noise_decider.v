module noise_decider (
    input [11:0] ibeatNum,
    input right_button_de,
    input left_button_de,
    output reg is_noise
);

always @(*) begin
    is_noise = 0;
    if (ibeatNum < 4) begin //15
        is_noise = 0;
        if(left_button_de) begin
            is_noise = 1;
        end
    end else if (ibeatNum < 8) begin
        is_noise = 0;
    end else if (ibeatNum < 12) begin
        is_noise = 0;
    end else if (ibeatNum < 16) begin   //12
        is_noise = 0;
    end else if (ibeatNum < 20) begin
        is_noise = 1;
    end else if (ibeatNum < 24) begin
        is_noise = 0;
    end else if (ibeatNum < 28) begin
        is_noise = 0;
        if(left_button_de) begin
            is_noise = 1;
        end
    end else if (ibeatNum < 32) begin   //8
        is_noise = 0;
    end else if (ibeatNum < 36) begin
        is_noise = 0;
    end else if (ibeatNum < 40) begin
        is_noise = 0;
    end else if (ibeatNum < 44) begin
        is_noise = 0;
        if(left_button_de) begin
            is_noise = 1;
        end
    end else if (ibeatNum < 48) begin   //4
        is_noise = 0;
    end else if (ibeatNum < 52) begin
        is_noise = 1;
        if(left_button_de) begin
            is_noise = 1;
        end
    end else if (ibeatNum < 56) begin
        is_noise = 0;
    end else if (ibeatNum < 60) begin
        is_noise = 0;
        if(right_button_de || left_button_de) begin
            is_noise = 1;
        end
    end else if (ibeatNum < 64) begin   //0
        is_noise = 0;
    end
end
    
endmodule