----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:34:25 01/29/2014 
-- Design Name: 
-- Module Name:    atlys_lab_video - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
 use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
 library UNISIM;
 use UNISIM.VComponents.all;

entity atlys_lab_video is
  port (
          clk   : in  std_logic; -- 100 MHz
          reset : in  std_logic;
          start    : in  std_logic;
          switch  : in  std_logic;
			 led: out std_logic;
          tmds  : out std_logic_vector(3 downto 0);
          tmdsb : out std_logic_vector(3 downto 0)
  );
end atlys_lab_video;




architecture barnett of atlys_lab_video is

	signal row_sig, col_sig , col_reg, col_next_1, col_next_2, row_reg, row_next_1, row_next_2 : unsigned (10 downto 0);
	signal button_sig, v_com_sig, pixel_clk, serialize_clk, serialize_clk_n, h_sync,  v_sync, blank, blank_reg, blank_next_1, blank_next_2, clock_s, red_s, green_s, blue_s : std_logic;
	signal red, blue, green : std_logic_vector (7 downto 0);

begin


 -- Clock divider - creates pixel clock from 100MHz clock
   	inst_DCM_pixel: DCM
    generic map(
                   CLKFX_MULTIPLY => 2,
                   CLKFX_DIVIDE   => 8,
                   CLK_FEEDBACK   => "1X"
               )
    port map(
                clkin => clk,
                rst   => reset,
                clkfx => pixel_clk
            );

    -- Clock divider - creates HDMI serial output clock
    inst_DCM_serialize: DCM
    generic map(
                   CLKFX_MULTIPLY => 10, -- 5x speed of pixel clock
                   CLKFX_DIVIDE   => 8,
                   CLK_FEEDBACK   => "1X"
               )
    port map(
                clkin => clk,
                rst   => reset,
                clkfx => serialize_clk,
                clkfx180 => serialize_clk_n
            );


Inst_vga_sync: entity work.vga_sync(Behavioral) PORT MAP(
		clk => pixel_clk,
		reset => reset,
		h_sync => h_sync,
		v_sync => v_sync,
		v_completed => v_com_sig,
		blank => blank,
		row => row_sig,
		column => col_sig
	);

Inst_character_gen: entity work.character_gen(Behavioral) PORT MAP(
		clk => pixel_clk,
		blank => blank_reg ,
		row => std_logic_vector(row_sig),
		column => std_logic_vector(col_sig),
		ascii_to_write => "00000011",
		write_en => button_sig,
		r => red,
		g => green,
		b => blue 
	);
	
	Inst_input_to_pulse: entity work.input_to_pulse(moore) PORT MAP(
		clk => pixel_clk,
		reset => reset,
		button => start,
		button_pulse => button_sig
	);	

		process(pixel_clk) is 
			begin
				if(rising_edge(pixel_clk)) then
					blank_next_1 <= blank;
					end if;
		end process;

		process(pixel_clk) is
			begin
				if(rising_edge(pixel_clk)) then
					blank_next_2 <= blank_next_1;
					end if;
		end process;

		process(pixel_clk) is
			begin
				if(rising_edge(pixel_clk)) then
					blank_reg <= blank_next_2;
					end if;
		end process;



    -- TODO: VGA component instantiation
    -- TODO: Pixel generator component instantiation

    -- Convert VGA signals to HDMI (actually, DVID ... but close enough)
    inst_dvid: entity work.dvid
    port map(
                clk       => serialize_clk,
                clk_n     => serialize_clk_n, 
                clk_pixel => pixel_clk,
                red_p     => red,
                green_p   => green,
                blue_p    => blue,
                blank     => blank,
                hsync     => h_sync,
                vsync     => v_sync,
                -- outputs to TMDS drivers
                red_s     => red_s,
                green_s   => green_s,
                blue_s    => blue_s,
                clock_s   => clock_s
            );

    -- Output the HDMI data on differential signalling pins
    OBUFDS_blue  : OBUFDS port map
        ( O  => TMDS(0), OB => TMDSB(0), I  => blue_s  );
    OBUFDS_red   : OBUFDS port map
        ( O  => TMDS(1), OB => TMDSB(1), I  => green_s );
    OBUFDS_green : OBUFDS port map
        ( O  => TMDS(2), OB => TMDSB(2), I  => red_s   );
    OBUFDS_clock : OBUFDS port map
        ( O  => TMDS(3), OB => TMDSB(3), I  => clock_s );

end barnett;
