library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity Tlight is
	port (clk, resetN, SwitchN, Turbo : in std_logic ;
			red, yellow, green: out std_logic);
end Tlight;

architecture arc_Tlight of Tlight is
	type count_state is(red_state, yellow_state, green_state, redYellow_state);
	signal state : count_state;
	signal DATA : std_logic_vector(7 downto 0);
	signal LOAD, TC : std_logic;
	signal ticks_counter : integer;	--counter for clock ticks
	signal time_counter : integer;	--counter for colors time
	signal current_state_waiting_time : integer;
	constant red_time : integer := 37;
	constant green_time : integer := 29;
	constant yellow_time : integer := 15;
	constant red_yellow_time : integer := 15;
	constant count_inc : integer := 1;
	constant count_inc_turbo : integer := 10;
	constant sec_1_10 : integer := 5000000; --1/10th sec
	--constant sec_1_100 : integer := 500000; --1/100th sec
	--constant sec_1_10 : integer := 10; --for simulation
	--constant red_time : integer := 1; --for simulation
	--constant green_time : integer := 1; --for simulation
	--constant yellow_time : integer := 1; --for simulation
	--constant red_yellow_time : integer := 1; --for simulation
	--constant count_inc : integer := 1; --for simulation
	--constant count_inc_turbo : integer := 2; --for simulation

	begin
		process(clk, resetN)
		begin
			if resetN = '0' then
				state <= red_state;
				current_state_waiting_time <= red_time;
				ticks_counter <= 1;
				time_counter <= 0;
				red <= '1';
				green <= '0';
				yellow <= '0';
			elsif rising_edge(clk) then
			
				if Turbo = '1' then
					ticks_counter <= ticks_counter + count_inc_turbo + 1;
				else
					ticks_counter <= ticks_counter + count_inc;
				end if;
				
				if ticks_counter >= sec_1_10 then
					time_counter <= time_counter + 1;
					ticks_counter <= 0;
				end if;
				
				if (state = red_state and SwitchN = '1') then
					state <= redYellow_state;
					current_state_waiting_time <= red_yellow_time;
					ticks_counter <= 2;
					time_counter <= 0;
					red <= '1';
					yellow <= '1';
					green <= '0';
				elsif time_counter >= current_state_waiting_time then 
					if state = red_state then
						state <= redYellow_state;
						current_state_waiting_time <= red_yellow_time;
						ticks_counter <= 2;
						time_counter <= 0;
						red <= '1';
						yellow <= '1';
						green <= '0';
					elsif state = yellow_state then
						state <= red_state;
						current_state_waiting_time <= red_time;
						ticks_counter <= 2;
						time_counter <= 0;
						red <= '1';
						yellow <= '0';
						green <= '0';
					elsif state = redYellow_state then
						state <= green_state;
						current_state_waiting_time <= green_time;
						ticks_counter <= 2;
						time_counter <= 0;
						red <= '0';
						yellow <= '0';
						green <= '1';
					elsif state = green_state then
						state <= yellow_state;
						current_state_waiting_time <= yellow_time;
						ticks_counter <= 2;
						time_counter <= 0;
						red <= '0';
						yellow <= '1';
						green <= '0';
					end if;
				end if;
			end if;
		end process;
end arc_Tlight;
				