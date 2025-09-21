// main module that calculates the dot product

module dot_product(
    input clk,
    input btnc,
    input [15:0] sw,
    output wire [15:0] led,
    output wire [6:0] seg,
    output wire [3:0] an,
    output dp
);
    wire [7:0] sw_data = sw[7:0];
    //to indicate which elements (a/b0, a/b1, a/b2, a/b3) is taken as input
    wire [1:0] sw_idx = sw[9:8];
    //switches to write the different components of vector
    wire we_a = sw[12];
    wire we_b = sw[13];
    //to display components of the vector, if both switches are on then display dot product on ssd.
    wire re_a = sw[14];
    wire re_b = sw[15];
    wire reset;
    wire oflo;
    reg [7:0] vec_a [0:3];
    reg [7:0] vec_b [0:3];
    reg [2:0] counter = 0;
    reg [2:0] ind = 0;
    //flag variable to signal the module that all four components of both vector have been inputed and we can start the computation of dot product.
    reg initiate_mac = 0;
    //will be enabled 4 times to calculate a[i]*b[i] for i : 0 to 3.
    reg mac_enable = 0;
    wire [15:0] dot_product;
    //to keep track which i in a[i]&b[i] has been inputed.
    reg [3:0] a_wr= 4'b0000;
    reg [3:0] b_wr = 4'b0000;
    reg [15:0] seven_seg_data = 16'd0;
    
    //initiating debouncer for clean input of reset button(btnc)
    debouncer dbs (.clk(clk), .noisy(btnc), .clean(reset));
    //initiating mac unit when mac variable changes and accumulates the prod a[i]*b[i] to led
    MAC_unit mac_u (.clk(clk), .reset(reset), .mac_enable(mac_enable), .in_a(vec_a[ind]), .in_b(vec_b[ind]), .mac_output(led), .overflow(oflo));
    
    sevenseg_driver ssd (.clk(clk), .reset_flag(reset), .show_oflo(oflo), .display_data(seven_seg_data), .seg(seg), .an(an));
    
    assign dp = 1; //for the decimal point in ssd
    
    always @(posedge clk) begin
        if (reset) begin  
            a_wr<= 4'b0000;
            b_wr<= 4'b0000;
            ind <= 0;
            counter <= 0;
            initiate_mac <= 0;
            mac_enable <= 0;
        end else begin
            if (we_a) begin  //if switch 12 is slided up, store value in vec_a for i= sw_idx
                vec_a[sw_idx] <= sw_data;
                a_wr[sw_idx] <= 1;
            end
            if (we_b) begin               //if switch 13 is slided up, store value in vec_a for i= sw_idx
                vec_b[sw_idx] <= sw_data;
                b_wr[sw_idx] <= 1;
            end
            if (a_wr == 4'b1111 && b_wr == 4'b1111) begin    //when all a[i] and b[i]'s are inputed update value of initiate_mac
                initiate_mac <= 1;
            end
            if (initiate_mac) begin               //start accumulating a[i]*b[i] using mac_unit module 
                if (counter < 3'b100) begin
                    mac_enable <= 1;
                    counter <= counter + 1;       //counter makes sure the prouduct is accumulated for i=0 to 3
                end else begin
                    mac_enable <=0;
                    initiate_mac <= 0;
                    counter <= 0;
                end
            end
        end
    end
    always @(*) begin
        seven_seg_data = 16'd0;
        if (re_a && !re_b) begin
            seven_seg_data = {8'h00, vec_a[sw_idx]};      //only display value of a[sw_idx]
        end else if (re_b && !re_a) begin
            seven_seg_data = {8'h00, vec_b[sw_idx]};      //only display value of b[sw_idx]
        end else if (re_a && re_b) begin
            seven_seg_data = led;                        //displays final dot product
        end
    end
endmodule
module debouncer(
    input clk,
    input noisy,
    output reg clean
);
    reg [7:0] count = 0;
    reg state = 0;
    always @(posedge clk) begin
        if(noisy != state) begin
            count <= count + 1;
            if(count == 8'd255) begin    //acc to hardware 255 || tb 5
                state <= noisy;
                clean <= noisy;
                count <= 0;
            end
        end else begin
            count <= 0;
        end
    end
endmodule


module MAC_unit(
    input clk,
    input reset,
    input mac_enable,
    input [7:0] in_a,
    input [7:0] in_b,
    output wire [15:0] mac_output,
    output wire overflow
);
    wire [15:0] product;
    multiplier mul(.b(in_a), .c(in_b), .prod(product));
    accumulator accu(.clk(clk), .reset(reset), .en(mac_enable), .data(product), .acc(mac_output), .overflow(overflow));
endmodule
module multiplier(
    input [7:0] b,
    input [7:0] c,
    output [15:0] prod
);
    assign prod = b * c;
endmodule
module accumulator(
    input clk,
    input reset,
    input en,
    input [15:0] data,
    output reg overflow,
    output reg [15:0] acc
);
    
    always @(posedge clk) begin
        if(reset) begin
            acc <= 16'd0;
            overflow <= 1'b0;
        end else if(en) begin
            if((acc + data) < acc) begin
                overflow <= 1'b1;
            end else begin
                overflow <= 1'b0;
            end
            acc <= acc + data;
        end
       
    end
endmodule

module sevenseg_driver#(reset_count = 30'd4000000000)( // acc to hardware 4000000000 ||tb 40
    input clk,
    input reset_flag,
    input show_oflo,
    input [15:0] display_data,
    output reg [6:0] seg,
    output reg [3:0] an
);
    reg [29:0] timer = 0;
    reg [1:0] digit = 0;
    reg reset = 0;
    reg [3:0] reset_display = 0;
    
    always @(posedge clk) begin
        if (reset_flag) begin
            reset <= 1;
            timer <= 0;
            reset_display <= 0;
            digit <= 0;
        end else if (reset) begin
            if (timer >= reset_count) begin
                reset <= 0;
                timer <= 0;
            end else begin
                timer <= timer + 1;
    
                if (timer % 100000  == 0) begin             // acc to hardware 100000 || tb 5      
                    reset_display <= reset_display+ 1;
                    if(reset_display == 3'd4) reset_display <= 3'b0;
                end
            end
        end else begin
            if (timer >= 16'd100000) begin      //persistence of vision acc to hardware 100000 || tb 5
                timer <= 0;
                digit <= digit + 1;
            end else begin
                timer <= timer+ 1;
            end
        end
    end
    function [6:0] hex_seg;
        input [3:0] hexv;
        case (hexv)
            4'h0: hex_seg = 7'b0000001;
            4'h1: hex_seg = 7'b1001111;
            4'h2: hex_seg = 7'b0010010;
            4'h3: hex_seg = 7'b0000110;
            4'h4: hex_seg = 7'b1001100;
            4'h5: hex_seg = 7'b0100100;
            4'h6: hex_seg = 7'b0100000;
            4'h7: hex_seg = 7'b0001111;
            4'h8: hex_seg = 7'b0000000;
            4'h9: hex_seg = 7'b0000100;
            4'hA: hex_seg = 7'b0001000;
            4'hB: hex_seg = 7'b1100000;
            4'hC: hex_seg = 7'b0110001;
            4'hD: hex_seg = 7'b1000010;
            4'hE: hex_seg = 7'b0110000;
            4'hF: hex_seg = 7'b0111000;
            default: hex_seg = 7'b1111111;
        endcase
    endfunction
    always @(*) begin
        an = 4'b1111;
        seg = 7'b1111111;
        if (reset) begin
            case (reset_display)
                2'd0: begin seg = 7'b1110000; an = 4'b1110; end
                2'd1: begin seg = 7'b0100100; an = 4'b1101; end
                2'd2: begin seg = 7'b1111010; an = 4'b1011; end
                2'd3: begin seg = 7'b1111110; an = 4'b0111; end
            endcase
        end else if (show_oflo) begin
            case (digit)
                2'd0: begin seg = 7'b0000001; an = 4'b1110; end
                2'd1: begin seg = 7'b1110001; an = 4'b1101; end
                2'd2: begin seg = 7'b0111000; an = 4'b1011; end
                2'd3: begin seg = 7'b0000001; an = 4'b0111; end
            endcase
        end else begin
            case (digit)
                2'd0: begin seg = hex_seg(display_data[3:0]); an = 4'b1110; end
                2'd1: begin seg = hex_seg(display_data[7:4]); an = 4'b1101; end
                2'd2: begin seg = hex_seg(display_data[11:8]); an = 4'b1011; end
                2'd3: begin seg = hex_seg(display_data[15:12]); an = 4'b0111; end
            endcase
        end
    end
endmodule
