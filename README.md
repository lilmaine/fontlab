ECE 383 Font Controller Lab
===========================


Purpose
==========

The purpose if this lab was to develop a simple controller for the VGA controler I already created. The controller will
allow a user to write any ASCII character to a 30 character by 80 character grid on a monitor accepting a DVI signal. To
get a C on this lab I had to display a single character in every grid location. B was to be able to change the character
displayed at any given location using the switches on the FPGA to determine the numeric value of the ASCII character and
the buttons to either submit or switch locations. A was to be able to scroll through different ASCII selections as well
as the other B functionality requirements using a NES controller


Implementation
====================

Below is a top level view of the code used in this lab

![schematic](schematic.png)


The main additions to this lab were the 8x1 mux as well as the character generator. The mux was pretty straight forward:


+```VHDL
++process(mux_out, blank) is
++begin
++		r <= (others => '0');
++		b <= (others => '0');
++		g <= (others => '0');
++	if(blank = '0') then
++		if(mux_out = '1') then
++			r <= (others => '1');
++		end if;
++	end if;	
++end process;
 +```
