`timescale 1ns/100ps
module lab2_2(
    input clk,
    input rst,
    input carA,
    input carB,
    output reg [2:0] lightA,
    output reg [2:0] lightB
);

    parameter [2:0] RED=3'b100, YELLOW=3'b010, GREEN=3'b001;
    
    reg [2:0] lightA_next=0,lightB_next=0;
    reg lightA_green_cycle=0,lightB_green_cycle=0;
    reg lightA_green_cycle_next=0,lightB_green_cycle_next=0;
    
    //flip-flop
    always @(posedge clk,posedge rst) begin
        if(rst) begin
            lightA<=GREEN;
            lightB<=RED;
            lightA_next<=GREEN;
            lightB_next<=RED;

            lightA_green_cycle<=0;
            lightB_green_cycle<=0;
            lightA_green_cycle_next<=0;
            lightB_green_cycle_next<=0;
        end else begin
            lightA<=lightA_next;
            lightB<=lightB_next;
            lightA_green_cycle<=lightA_green_cycle_next;
            lightB_green_cycle<=lightB_green_cycle_next;
        end
    end

    //combinational block
    always @(*) begin
        if({carA,carB}==2'b01) begin
            if({lightA,lightB}=={GREEN,RED}) begin
                if(lightA_green_cycle) begin //green has stayed at least 2 cycles
                    lightA_next=YELLOW;
                    lightB_next=RED;
                end else begin
                    lightA_green_cycle_next = lightA_green_cycle + 1;
                end
            end else if({lightA,lightB}=={YELLOW,RED}) begin
                lightA_next=RED;
                lightB_next=GREEN;
                lightA_green_cycle_next=0;
            end else if({lightA,lightB}=={RED,GREEN}) begin
                lightA_next=RED;
                lightB_next=GREEN;
            end
        end else if({carA,carB}==2'b10) begin
            if({lightA,lightB}=={RED,GREEN}) begin
                if(lightB_green_cycle) begin //green has stayed at least 2 cycles
                    lightA_next=RED;
                    lightB_next=YELLOW;
                end else begin
                    lightB_green_cycle_next = lightB_green_cycle + 1;
                end
            end else if({lightA,lightB}=={RED,YELLOW}) begin
                lightA_next=GREEN;
                lightB_next=RED;
                lightB_green_cycle_next=0;
            end else if({lightA,lightB}=={GREEN,RED}) begin
                lightA_next=GREEN;
                lightB_next=RED;
            end
        end else begin  //even if there's no car(00) or have 2 cars(11) on both street,still have to care about the green light cycle
            if(lightA==GREEN && lightA_green_cycle==0) begin
                lightA_green_cycle_next=lightA_green_cycle+1;
            end
            if(lightB==GREEN && lightB_green_cycle==0) begin
                lightB_green_cycle_next=lightB_green_cycle+1;
            end
            lightA_next=lightA;
            lightB_next=lightB;
        end
    end
endmodule