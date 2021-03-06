library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity mid_and_bottom_pass_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		ObjectStartX	: in integer;
		ObjectStartY 	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end mid_and_bottom_pass_object;

architecture behav of mid_and_bottom_pass_object is 

constant	y_frame	: integer :=	479;

begin

process ( RESETn, CLK)
   begin
	if RESETn = '0' then
	   mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
	elsif rising_edge(CLK) then
		mVGA_RGB	<=  "00000010";	
		if (oCoord_Y > 227 and oCoord_Y <= 257) or (oCoord_Y > 449 and oCoord_Y <= y_frame) then
			drawing_request	<= '1';
		else
			drawing_request	<= '0';
		end if;
	end if;

  end process;

		
end behav;		
		