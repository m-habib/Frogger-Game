library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity timebar_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  					: in std_logic;
		RESETn				: in std_logic;
		restartN				: in std_logic;
		oCoord_X				: in integer;
		oCoord_Y				: in integer;
		start					: in std_logic;
		level_up				: in std_logic;
		onesec				: in std_logic;
		blink_N				: in std_logic;
		master				: in std_logic;
		drawing_request	: out std_logic;
		mVGA_RGB 			: out std_logic_vector(7 downto 0) 
	);
end timebar_object;

architecture behav of timebar_object is 
constant timebar_width_const : integer := 297;
signal timebar_width : integer;
signal counter : integer;
signal counting : std_logic;
begin
process ( RESETn, CLK, start, restartN)
   begin
	if RESETn = '0' or restartN = '0' or level_up = '1'then
		timebar_width <= timebar_width_const;
		counting <= '0';
		mVGA_RGB <= "11111111" ;
	elsif rising_edge(CLK) then
		if start = '1' then
			counting <= '1';
		end if;
		if counting = '1' then

			if onesec = '1' then
				timebar_width <= timebar_width - 3;
			end if;
			--timebar
			drawing_request <= '0';
			mVGA_RGB <= "11111111" ;
			if master = '1' then
				mVGA_RGB <= "11100000" ;
			end if;
			if oCoord_Y >= 6 and oCoord_Y < 14 then
				if oCoord_X >= 6 and oCoord_X < timebar_width + 6 then
					drawing_request <= '1' and blink_N;
				end if;
			end if;
			
			-- timebar border 
			if oCoord_Y = 6 or oCoord_Y = 7 or oCoord_Y = 12 or oCoord_Y = 13 then
				if oCoord_X >= 6 and oCoord_X < timebar_width_const + 6 then
					drawing_request <= '1' and blink_N;
				end if;
			end if;
			
			if oCoord_X = 6 or oCoord_X = 7 or oCoord_X = timebar_width_const + 4  or oCoord_X = timebar_width_const + 5  then
				if oCoord_Y >= 6 and oCoord_Y < 14then
					drawing_request <= '1' and blink_N;
				end if;
			end if;
			
			
		else
			timebar_width <= timebar_width_const;
			drawing_request <= '0';
			if oCoord_Y >= 6 and oCoord_Y < 14 then
				if oCoord_X >= 0 and oCoord_X < timebar_width then
					drawing_request <= '1' and blink_N;
				end if;
			end if;
		end if;
	end if;
  end process;
end behav;		
		