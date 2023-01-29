module clock_divider #(parameter n=25)(
    input clk,
    output clk_div
);
    reg [n-1:0] num=0;
    wire [n-1:0] next_num;

    always @(posedge clk) begin
        num <= next_num;
    end
    assign next_num = num+1;
    assign clk_div = num[n-1];
endmodule

module mem_addr_gen(
   input clk,
   input rst,
   input en,
   input dir,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output [16:0] pixel_addr
);
    
    reg [7:0] position;
  
    assign pixel_addr = ((h_cnt>>1)+320*(v_cnt>>1)+ position*320 )% 76800;  //640*480 --> 320*240 

    always @(posedge clk,posedge rst) begin
        if(rst) begin
            position<=0;
        end else begin
            position<=position;
            if(en) begin
                if(!dir) begin  //scrolls up
                    if(position<239) begin
                        position<=position+1;
                    end else begin
                        position<=0;
                    end
                end else begin  //scrolls down
                    if(position>1) begin
                        position<=position-1;
                    end else begin
                        position<=240;
                    end
                end
            end
        end
    end
endmodule

module lab7_1(
    input clk,
    input rst,
    input en,
    input dir,
    input nf,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue,
    output hsync,
    output vsync
);
    wire [11:0] data;
    wire clk_25MHz;
    wire clk_22;
    wire [16:0] pixel_addr;
    wire [11:0] pixel;
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480

    //assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel:12'h0;
    always @(*) begin
        if(valid) begin
            if(nf) begin
                {vgaRed, vgaGreen, vgaBlue} = ~pixel;
            end else begin
                {vgaRed, vgaGreen, vgaBlue} = pixel;
            end
        end else begin
            {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        end
    end
    assign data = {vgaRed, vgaGreen, vgaBlue};

    clock_divider #(.n(2)) c25MHz(.clk(clk), .clk_div(clk_25MHz)); //100/4 = 25Mhz
    clock_divider #(.n(22)) c22(.clk(clk), .clk_div(clk_22));

    mem_addr_gen mem_addr_gen_inst(
        .clk(clk_22),
        .rst(rst),
        .en(en),
        .dir(dir),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .pixel_addr(pixel_addr)
    );
    
    blk_mem_gen_0 blk_mem_gen_0_inst(
        .clka(clk_25MHz),
        .wea(0),
        .addra(pixel_addr),
        .dina(data[11:0]),
        .douta(pixel)
    ); 

    vga_controller vga_inst(
        .pclk(clk_25MHz),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .valid(valid),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt)
    );
endmodule