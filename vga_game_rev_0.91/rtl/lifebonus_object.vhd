library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity lifebonus_object is
port 	(
	   CLK  					: in std_logic;
		RESETn				: in std_logic;
		oCoord_X				: in integer;
		oCoord_Y				: in integer;
		restart_game_N 	: in std_logic;
		master				: in std_logic;
		lifebonus_won_N	: in std_logic;
		drawing_request	: out std_logic;
		mVGA_RGB 			: out std_logic_vector(7 downto 0)
	);
end lifebonus_object;

architecture behav of lifebonus_object is 

constant object_X_size : integer := 24;
constant object_Y_size : integer := 24;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000"),
("111111111111111111111111"),
("111111111111111111111111"),
("111111111111111111111111"),
("111111111111111111111111"),
("111111111111111111111111"),
("111111111111111111111111"),
("111111111111111111111111"),
("111111111111111111111111"),
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000"),
("000000001111111100000000")
);


signal game_over_tmp : std_logic;
signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

signal objectEndX : integer;
signal objectEndY : integer;

signal ObjectStartX : integer := 100;
signal ObjectStartY : integer := 417;

signal counter : integer;

begin

-- Calculate object end boundaries
objectEndX	<= object_X_size+ObjectStartX;
objectEndY	<= object_Y_size+ObjectStartY;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- test if ooCoord is in the rectangle defined by Start and End 
	drawing_X	<= '1' when  (oCoord_X  >= ObjectStartX) and  (oCoord_X < objectEndX) else '0';
   drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY) else '0';

-- calculate offset from start corner 
	bCoord_X 	<= (oCoord_X - ObjectStartX) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 

process (RESETn, CLK, restart_game_N)
begin
	if RESETn = '0' or restart_game_N = '0' then
	   mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		counter <= 0;
		ObjectStartX <= 100;
		ObjectStartY <= 417;
	elsif rising_edge(CLK) then	
		if master = '0' then
			drawing_request	<=  '0' ;
		else
			counter <= counter + 1;
			if counter < 500000000 then 
				ObjectStartX <= 100;
				ObjectStartY <= 417;
				if lifebonus_won_N = '0' then 
					counter <= 500000000;
					drawing_request <= '0';
				elsif object(bCoord_Y , bCoord_X) = '1' and drawing_X = '1' and drawing_Y = '1' then
					mVGA_RGB	<=  "11100000";
					drawing_request <= '1';
				elsif drawing_X = '1' and drawing_Y = '1' then
					mVGA_RGB	<=  "11111111";
					drawing_request <= '1';
				else
					drawing_request <= '0';
				end if;
			elsif counter < 800000000 then
				drawing_request <= '0';
				ObjectStartY <= 265;
				ObjectStartX <= 460;
			elsif counter < 1200000000 then 
				if lifebonus_won_N = '0' then 
					counter <= 1200000000;
					drawing_request <= '0';
				elsif object(bCoord_Y , bCoord_X) = '1' and drawing_X = '1' and drawing_Y = '1' then
					mVGA_RGB	<=  "11100000";
					drawing_request <= '1';
				elsif drawing_X = '1' and drawing_Y = '1' then
					mVGA_RGB	<=  "11111111";
					drawing_request <= '1';
				else
					drawing_request <= '0';
				end if;
			else 
				counter <= 1300000000;
				drawing_request <= '0';
			end if;
		end if;
	end if;
end process;
end behav;		
		