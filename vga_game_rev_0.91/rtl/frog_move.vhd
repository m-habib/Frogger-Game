library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 
-- Dudy Nov 13 2017


entity frog_move is
port 	(
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		timer_done		: in std_logic;
		KBD_in 			: in std_logic_vector(7 downto 0);
		make 				: in std_logic;
		break 			: in std_logic;
		speed_on_plank : in integer;
		restart_game	: in std_logic;
		collision_N		: in std_logic;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer ;
		lane_passed		: out std_logic;
		direction		: out  std_logic_vector(1 downto 0); 	-- 0 = up, 1 = down, 2 = left, 3 = right	
		out_of_border_N	: inout std_logic;
		jump 				: out std_logic
	);
end frog_move;

architecture behav of frog_move is 

constant StartX : integer := 320;   -- starting point
constant StartY : integer := 451;   
constant mid_pass_start : integer := 227;   


type action_type is (move_up, move_down, move_left, move_right, action_stop); --enumerated type for action
signal action : action_type;
signal ObjectStartX_t : integer range 0 to 640;  --vga screen size 
signal ObjectStartY_t : integer range 0 to 480;
signal wait_flag : std_logic;
begin
		process ( RESETn,CLK)
		begin
			if RESETn = '0' or collision_N = '0' or restart_game = '0' then
				ObjectStartX_t	<= StartX;
				ObjectStartY_t	<= StartY ;
				action <= action_stop;
				lane_passed <= '0';
				direction <= "00";
				out_of_border_N <= '1';
				jump <= '0';
			elsif rising_edge(CLK) then
				if out_of_border_N = '0' then
					out_of_border_N <= '1';
				else
					if (KBD_in = "01110101" and make = '1') then --75 = up
						action <= move_up;
						lane_passed <= '1';
						direction <= "00";
						jump <= '1';
					elsif (KBD_in = "01110010" and make = '1') then --72 = down
						action <= move_down;
						direction <= "01";
						jump <= '1';
					elsif (KBD_in = "01101011" and make = '1') then --6B = left
						action <= move_left;
						direction <= "10";
						jump <= '1';
					elsif (KBD_in = "01110100" and make = '1') then --74 = right
						action <= move_right;
						direction <= "11";
						jump <= '1';		
					elsif (KBD_in = "01110101" and break = '1') then 
						action <= action_stop;
						lane_passed <= '0';
						jump <= '0';
					elsif (KBD_in = "01110010" and break = '1') then 
						action <= action_stop;
						jump <= '0';
					elsif (KBD_in = "01101011" and break = '1') then 
						action <= action_stop;
						jump <= '0';
					elsif (KBD_in = "01110100" and break = '1') then 
						action <= action_stop;
						jump <= '0';
					else 
						lane_passed <= '0';
					end if;

					if timer_done = '1' then
						case action is
							when move_up =>
								ObjectStartX_t  <= ObjectStartX_t;
								ObjectStartY_t  <= ObjectStartY_t - 37; -- move up
							when move_down =>
								ObjectStartX_t  <= ObjectStartX_t;
								ObjectStartY_t  <= ObjectStartY_t + 37; -- move down
							when move_left =>
								ObjectStartY_t  <= ObjectStartY_t;
								ObjectStartX_t  <= ObjectStartX_t - 37; -- move left
							when move_right =>
								ObjectStartY_t  <= ObjectStartY_t;
								ObjectStartX_t  <= ObjectStartX_t + 37; -- move right
							when action_stop =>
								ObjectStartX_t  <= ObjectStartX_t + speed_on_plank;
								ObjectStartY_t  <= ObjectStartY_t;
						end case;
						action <= action_stop;
						if (ObjectStartY_t < 0  or ObjectStartY_t + 26 >= 480 or ObjectStartX_t + 26 >= 650 or ObjectStartX_t < -15) then
							out_of_border_N <= '0';
							ObjectStartX_t	<= StartX;
							ObjectStartY_t	<= StartY ;
							action <= action_stop;
							lane_passed <= '0';
						end if;
					end if;
				end if;
			end if;
		end process ;
ObjectStartX	<= ObjectStartX_t;		-- copy to outputs 	
ObjectStartY	<= ObjectStartY_t;	


end behav;