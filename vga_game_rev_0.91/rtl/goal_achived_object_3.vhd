library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity goal_achived_object_3 is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end goal_achived_object_3;

architecture behav of goal_achived_object_3 is 
begin

process ( RESETn, CLK)

  		
   begin
	if RESETn = '0' then
	   mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
	elsif rising_edge(CLK) then
		mVGA_RGB	<=  "11111110";
		if(oCoord_X >= 290 and oCoord_X < 350 and oCoord_Y >= 33 and oCoord_Y < 69) then
			drawing_request	<= '1';
		else
			drawing_request	<= '0';
		end if;
	end if;

  end process;

		
end behav;		
		