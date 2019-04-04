library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity border_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end border_object;

architecture behav of border_object is 
begin

process ( RESETn, CLK)
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
	elsif rising_edge(CLK) then
		mVGA_RGB	<=  "11111111";	
		if(oCoord_X <= 0 or oCoord_X >= 639 or oCoord_Y >= 479) then
			drawing_request	<= '1';
		else
			drawing_request	<= '0';
		end if;
	end if;
  end process;
end behav;		
		