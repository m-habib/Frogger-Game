library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 
-- Dudy Nov 13 2017


entity smileyfacemove is
port 	(
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		timer_done		: in std_logic;
		KBD_in : in std_logic_vector(7 downto 0);
		make : in std_logic;
		break : in std_logic;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end smileyfacemove;

architecture behav of smileyfacemove is 

constant StartX : integer := 290;   -- starting point
constant StartY : integer := 400;   

type action_type is (move_up, move_down, move_left, move_right, action_stop); --enumerated type for action
signal action : action_type;
signal ObjectStartX_t : integer range 0 to 640;  --vga screen size 
signal ObjectStartY_t : integer range 0 to 480;
begin
		process ( RESETn,CLK)
		begin
			if RESETn = '0' then
				ObjectStartX_t	<= StartX;
				ObjectStartY_t	<= StartY ;
				action <= action_stop;
			elsif rising_edge(CLK) then
				if (KBD_in = "00011101" and make = '1') then --1D = W
					action <= move_up;
				elsif (KBD_in = "00011011" and make = '1') then --1B = S
					action <= move_down;
				elsif (KBD_in = "00011100" and make = '1') then --1C = A
					action <= move_left;
				elsif (KBD_in = "00100011" and make = '1') then --23 = D
					action <= move_right;
					
				elsif (KBD_in = "00011101" and break = '1') then --1D = W
					action <= action_stop;
				elsif (KBD_in = "00011011" and break = '1') then --1B = S
					action <= action_stop;
				elsif (KBD_in = "00011100" and break = '1') then --1C = A
					action <= action_stop;
				elsif (KBD_in = "00100011" and break = '1') then --23 = D
					action <= action_stop;
				
				elsif (KBD_in = "00101001" and make = '1') then --29 = space
					action <= action_stop;
				end if;
			
				if timer_done = '1' then
					case action is
						when move_up =>
							ObjectStartX_t  <= ObjectStartX_t;
							ObjectStartY_t  <= ObjectStartY_t - 3; -- move up
						when move_down =>
							ObjectStartX_t  <= ObjectStartX_t;
							ObjectStartY_t  <= ObjectStartY_t + 3; -- move down
						when move_left =>
							ObjectStartY_t  <= ObjectStartY_t;
							ObjectStartX_t  <= ObjectStartX_t - 3; -- move left
						when move_right =>
							ObjectStartY_t  <= ObjectStartY_t;
							ObjectStartX_t  <= ObjectStartX_t + 3; -- move right
						when action_stop =>
							ObjectStartX_t  <= ObjectStartX_t;
							ObjectStartY_t  <= ObjectStartY_t;
					end case;
				end if;
			end if;
		end process ;
ObjectStartX	<= ObjectStartX_t;		-- copy to outputs 	
ObjectStartY	<= ObjectStartY_t;	


end behav;