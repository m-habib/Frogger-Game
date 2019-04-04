library ieee ;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity BOMB_SM is
	port ( 	clk:	in 	std_logic;
		resetN:		in 	std_logic;
		startN:		in 	std_logic;
		done_trigger_N:  	in	std_logic; --X addeed as "wait" might be a reserved word 
		OneHzPulse:	in	std_logic;  -- a narrow pulse every second 
 		Tc: 		in	std_logic;   --counter terminal count 
		
		CounterEnable:  out	std_logic;  --enable('1')/disable('0')  
		Timer_done:  out	std_logic;  -- is 1 for one cycle when timer is done	
		LampEnable: 	out	std_logic ); -- on('1') off('0')
end BOMB_SM;

architecture arc_BombStateMachine of BOMB_SM is 
  type state_type is (idle, run, lamp_on, lamp_off, arm); --enumerated type for state machine
	signal state : state_type;
	begin
    process (clk, resetN)
	 	variable wait_count : integer;
    begin
        if resetN = '0' then
				state <= idle;
				CounterEnable <= '0';
				Timer_done <= '0';
				LampEnable <= '1';
	     elsif (rising_edge(clk)) then
				--LampEnable <= '0';
				CounterEnable <= '0';
			case state is
                when idle=>
                   if startN = '0' then
                     state <= arm;
                   end if; 
					 when arm =>
						if startN = '1' then
							state <= run;
							CounterEnable <= '1';
						end if;
					
						when run=>
							if done_trigger_N = '0' then
								state <= lamp_on;
								CounterEnable <= '0';
								LampEnable <= '1';
							elsif TC = '1' then
								state <= lamp_on;
								CounterEnable <= '0';
								LampEnable <= '1';
								Timer_done <= '1';
							elsif TC = '0' then
								CounterEnable <= '1';
								LampEnable <= '1';
                    end if;
						  
----                when run=>
----							if WaitN = '0' then
----								wait_count := 0;
----								state <= pause;
----								CounterEnable <= '0';
----								LampEnable <= '1';
----							elsif TC = '1' then
----								state <= lamp_on;
----								CounterEnable <= '0';
----								LampEnable <= '1';
----							elsif TC = '0' then
----								CounterEnable <= '1';
----								LampEnable <= '1';
----                    end if;				
                when lamp_on => 
							if OneHzPulse = '1' then
								state <= lamp_off;
								CounterEnable <= '0';
								LampEnable <= '0';
								Timer_done <= '0';
                    end if;
                when lamp_off => 
                    if OneHzPulse = '0' then
								state <= lamp_on;
								CounterEnable <= '0';
								LampEnable <= '1';
							end if;
            end case;          
        end if;
    end process;
end arc_BombStateMachine ; 

