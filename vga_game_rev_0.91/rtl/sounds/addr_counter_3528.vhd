LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY addr_counter_3528 IS
GENERIC ( COUNT_SIZE		: INTEGER := 12);
PORT (
			CLK_IN			:	IN	STD_LOGIC;	
			resetN			:	IN	STD_LOGIC;
			en					: 	in  std_logic ;
			en1				: 	in  std_logic ;
			addr				: 	out std_logic_vector(COUNT_SIZE - 1 downto 0)
		);

END addr_counter_3528;


	
architecture addr_counter_arch of 		addr_counter_3528 is
constant count_limit : std_logic_vector(COUNT_SIZE - 1 downto 0) :=("110111001000"); -- max value 
constant count_limit_min : std_logic_vector(COUNT_SIZE - 1 downto 0) := ( others => '0'); -- min value
begin
process (CLK_IN, resetN)
variable count : std_logic_vector(COUNT_SIZE-1 downto 0);
begin


if resetN='0' then
   count:= count_limit_min;

   elsif rising_edge (CLK_IN) then
    if en='1' then
     if en1='1' then
      if count= count_limit then
        count:= count_limit_min;
        addr<= count;
        else
		  count:= count+1;
      end if;
     end if;
    end if;
  end if;
  addr<= count;
  end process;
end addr_counter_arch ;