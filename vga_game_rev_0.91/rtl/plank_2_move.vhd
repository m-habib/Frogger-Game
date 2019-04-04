library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 
-- Dudy Nov 13 2017


entity plank_2_move is
port 	(
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		timer_done		: in std_logic;
		level				: in integer;
		level_up 		: in std_logic;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer ;
		speed				: out integer
	);
end plank_2_move;

architecture behav of plank_2_move is 

constant StartX : integer := 640;   -- starting point
constant StartY : integer := 154;   
constant object_X_size : integer := 115;
constant speed_constant : integer := -2;
signal speed_const : integer := speed_constant;  --plank speed
signal ObjectStartX_t : integer range -5000 to 5000;  --vga screen size 
signal ObjectStartY_t : integer range 0 to 480;
begin
		process ( RESETn,CLK)
		begin
			if RESETn = '0' then
				ObjectStartX_t	<= StartX;
				ObjectStartY_t	<= StartY;
				speed_const <= speed_constant;
			elsif rising_edge(CLK) then
				if level_up = '1' then
					speed_const <= speed_const - level;
				end if;
				if timer_done = '1' then
					ObjectStartX_t <= ObjectStartX_t + speed_const;
					ObjectStartY_t <= ObjectStartY_t;
					if (ObjectStartX_t <= -object_X_size) then
						ObjectStartX_t <= 256 - object_X_size;
					end if;
				end if;
			end if;
		end process ;
ObjectStartX	<= ObjectStartX_t;		-- copy to outputs 	
ObjectStartY	<= ObjectStartY_t;	
speed 			<= speed_const;

end behav;