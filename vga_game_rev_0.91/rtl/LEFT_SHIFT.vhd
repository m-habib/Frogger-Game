library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
use ieee.std_logic_arith.all ;

entity LEFT_SHIFT is
port ( resetN : in std_logic ;
       clk : in std_logic ;
       din : in std_logic_vector (7 downto 0);
		 key_code : in std_logic_vector (7 downto 0);
       make : in std_logic ;
       break : in std_logic ;
       dout : out std_logic );
end LEFT_SHIFT;

architecture behavior of LEFT_SHIFT is
    signal pressed: std_logic;
    signal out_led: std_logic;
	    type state is (idle ,
led_on,
led_off);
	 signal next_state : state;
begin 
    dout <= out_led;
    process ( resetN , clk)
        begin
            if resetN = '0' then
				next_state <= idle;
				out_led <='0';
				pressed<='0';
				
				
				elsif (rising_edge(clk)) then
				case next_state is
				
				when idle=>
				if (din=key_code) and (make='1') and (pressed='0') then
				next_state <= led_on;
				elsif  (din=key_code) and (break='1') then
				next_state <= led_off;
				end if;
				
				when led_on=>
				pressed<='1';
				out_led<= not(out_led);
				next_state <= idle;
				
				
				when led_off=>
				pressed<='0';
				--out_led<= not(out_led);
				next_state <= idle;
				
				
				end case;
				
				

end if;
end process;
end architecture;