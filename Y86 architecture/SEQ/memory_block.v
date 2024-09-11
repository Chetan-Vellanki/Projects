module memory_mod(input wire [63:0] bits_to_write, output reg [63:0] bits_read,input wire [14:0] flag_range,input wire button_for_write,input wire button_for_read,output reg out_of_bound_flag, output reg both_read_write_buttons_same);

  reg [63:0] arr [0:32767];
    reg safe_flag;

    always @(posedge button_for_read or posedge button_for_write) begin
        if (button_for_read == button_for_write) begin
            safe_flag <= 0;
        end else begin
            safe_flag <= 1;
        end

        if (safe_flag) begin
            if (button_for_read) begin
                if (flag_range < 32768) begin
                    bits_read <= arr[flag_range];
                end else begin
                  out_of_bound_flag <= 1;
                end
            end

            if (button_for_write) begin
                if (flag_range < 32768) begin
                    arr[flag_range] <= bits_to_write;
                end else begin
                    out_of_bound_flag <= 1;
                end
            end
        end else begin
            bits_read <= 64'hDEADBEEFDEADBEEF;
            arr[flag_range] <= 64'hDEADBEEFDEADBEEF;
            both_read_write_buttons_same <=1;
        end
    end

endmodule




module memory_mod_tb;

  reg [63:0] bits_to_write;
  wire [63:0] bits_read;
  reg [14:0] flag_range;
  reg button_for_write;
  reg button_for_read;
  wire out_of_bound_flag;
  wire both_read_write_buttons_same;

  // Instantiate the memory_mod module
  memory_mod uut (
    .bits_to_write(bits_to_write),
    .bits_read(bits_read),
    .flag_range(flag_range),
    .button_for_write(button_for_write),
    .button_for_read(button_for_read),
    .out_of_bound_flag(out_of_bound_flag),
    .both_read_write_buttons_same(both_read_write_buttons_same)
  );

  // Clock generation (not used in this simple example)
  reg clk = 0;
  always #5 clk = ~clk;

  // Initial block for stimulus
  initial begin


    // Initialize inputs
    bits_to_write = 64'h123456789ABCDEF0;
    flag_range = 16'h0000;
    button_for_write = 0;
    button_for_read = 0;

    // Apply stimulus
    #10 button_for_write = 1; // Trigger a write operation
    #10 button_for_write = 0;

    #10 button_for_read = 1; // Trigger a read operation
    #10 button_for_read = 0;

    // Add more test cases as needed

    // Stop the simulation after some time
    #100 $stop;
  end

  // Monitor block for observing outputs
  always @(posedge button_for_read or posedge button_for_write) begin
    $display("bits_read = %b, out_of_bound_flag = %b, both_read_write_buttons_same = %b", bits_read, out_of_bound_flag, both_read_write_buttons_same);
  end

endmodule