library ieee ;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity FROGGER_SM is
	port ( 	clk:	in 	std_logic;
		resetN:		in 	std_logic;
		startN:		in 	std_logic;
end FROGGER_SM;

architecture behav of FROGGER_SM is 
	type state_type is (idle, run, pause, lamp_on, lamp_off, arm); --enumerated type for state machine
	type state_type is (idle, move_up, move_doun, move_left, move_right, carHit, drawning, on_plank); --enumerated type for state machine
	signal state : state_type;
	begin
   process (clk, resetN)
	variable wait_count : integer;
	begin
		if resetN = '0' then
			state <= idle;
		elsif (rising_edge(clk)) then
			case state is				

			end case;          
		end if;
	end process;
end behav ; 

