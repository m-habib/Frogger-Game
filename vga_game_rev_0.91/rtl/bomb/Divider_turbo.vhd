library ieee;
use ieee.std_logic_1164.all;

entity Divider_turbo is 
port(
		CLK,RESETN, TURBO: in std_logic;
		one_sec_flag, duty50: out std_logic
		);
end Divider_turbo;
architecture behavior of Divider_turbo is
begin
process(CLK,RESETN, TURBO)
    variable one_sec: integer ;
	 variable duty50_variable : std_logic;
	 constant sec: integer := 50000000 ; -- for Real operation 
    --constant sec: integer := 10 ; -- for simulation 
begin
    if RESETN = '0' then
        one_sec := 0 ;
        one_sec_flag <= '0' ;
		  duty50_variable := '0' ;
		  duty50 <= '0';
    elsif rising_edge(CLK) and TURBO = '0' then
        one_sec := one_sec + 1 ;
        if (one_sec >= sec) then
            one_sec_flag <= '1' ;
            one_sec := 0;
				duty50_variable := not(duty50_variable);
				duty50 <= duty50_variable;
        else
            one_sec_flag <= '0';
        end if;
		  
    elsif rising_edge(CLK) and TURBO = '1' then
        one_sec := one_sec + 1 ;
        if (one_sec >= sec/10) then
            one_sec_flag <= '1' ;
            one_sec := 0;
				duty50_variable := not(duty50_variable);
				duty50 <= duty50_variable;
        else
            one_sec_flag <= '0';
        end if;
		  
    end if;
end process;
end architecture;
