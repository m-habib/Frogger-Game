library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity police_car_small_object is
port 	(
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		ObjectStartX	: in integer;
		ObjectStartY 	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end police_car_small_object;

architecture behav of police_car_small_object is

constant object_X_size : integer := 30;
constant object_Y_size : integer := 15;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"04", x"24", x"24", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"4D", x"25", x"00", x"00", x"00", x"24", x"24", x"24", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"29", x"4D", x"52", x"56", x"77", x"7B", x"7B", x"7B", x"56", x"52", x"52", x"52", x"52", x"52", x"52", x"52", x"76", x"56", x"56", x"56", x"56", x"7B", x"7B", x"7B", x"56", x"52", x"29", x"00", x"00"),
(x"2D", x"7B", x"7F", x"7F", x"9F", x"7F", x"7F", x"7F", x"56", x"4E", x"4D", x"4D", x"4D", x"4D", x"4D", x"4D", x"4D", x"52", x"7B", x"77", x"56", x"77", x"7B", x"7B", x"7B", x"7F", x"7F", x"52", x"48", x"01"),
(x"52", x"7F", x"9F", x"7F", x"7F", x"52", x"52", x"7B", x"52", x"72", x"72", x"72", x"52", x"84", x"A0", x"72", x"56", x"4D", x"6D", x"6D", x"6D", x"52", x"7B", x"77", x"56", x"52", x"57", x"76", x"90", x"24"),
(x"56", x"9F", x"7F", x"52", x"4D", x"6D", x"6D", x"76", x"9F", x"7F", x"7F", x"9F", x"7F", x"A4", x"E0", x"76", x"56", x"6D", x"92", x"92", x"92", x"6D", x"7B", x"7B", x"57", x"57", x"56", x"77", x"4D", x"29"),
(x"76", x"9F", x"7B", x"6D", x"8D", x"92", x"6D", x"76", x"9F", x"9F", x"9F", x"9F", x"7F", x"49", x"45", x"56", x"76", x"6D", x"6D", x"6D", x"92", x"6D", x"56", x"9F", x"9F", x"9B", x"77", x"57", x"52", x"2E"),
(x"76", x"9F", x"72", x"6D", x"6D", x"6D", x"6D", x"76", x"9F", x"9F", x"9F", x"9F", x"7F", x"0F", x"0F", x"57", x"76", x"6D", x"6D", x"6D", x"6D", x"6D", x"52", x"7F", x"9F", x"9F", x"9F", x"7F", x"7B", x"52"),
(x"76", x"9F", x"72", x"6D", x"6D", x"6D", x"6D", x"76", x"9F", x"9F", x"9F", x"9F", x"7F", x"0E", x"0A", x"57", x"76", x"6D", x"6D", x"6D", x"6D", x"6D", x"52", x"7F", x"9F", x"9F", x"9F", x"9F", x"9F", x"76"),
(x"76", x"9F", x"72", x"6D", x"6D", x"6D", x"6D", x"76", x"9F", x"9F", x"9F", x"9F", x"7F", x"0F", x"0F", x"57", x"76", x"6D", x"6D", x"6D", x"6D", x"6D", x"52", x"7F", x"9F", x"9F", x"9F", x"7F", x"7B", x"52"),
(x"76", x"9F", x"7B", x"6D", x"92", x"92", x"6D", x"76", x"9F", x"9F", x"9F", x"9F", x"7F", x"49", x"45", x"56", x"76", x"6D", x"6D", x"6D", x"92", x"6D", x"76", x"9F", x"9F", x"9B", x"7B", x"57", x"52", x"2E"),
(x"56", x"9F", x"7F", x"52", x"6D", x"6D", x"6D", x"76", x"9F", x"9F", x"9F", x"9F", x"7F", x"A4", x"E0", x"72", x"76", x"6D", x"92", x"92", x"92", x"6D", x"77", x"7B", x"57", x"7B", x"7B", x"77", x"52", x"29"),
(x"52", x"7F", x"9F", x"7F", x"7B", x"7B", x"7B", x"7B", x"52", x"52", x"52", x"52", x"52", x"84", x"A0", x"72", x"56", x"4D", x"6D", x"6D", x"6D", x"52", x"7B", x"7B", x"7B", x"77", x"77", x"76", x"90", x"48"),
(x"2D", x"7B", x"7F", x"7F", x"9F", x"9F", x"9F", x"7F", x"52", x"4D", x"4D", x"4D", x"4D", x"4D", x"4D", x"4D", x"4D", x"52", x"7B", x"76", x"76", x"57", x"7B", x"7B", x"7B", x"7F", x"7F", x"52", x"48", x"00"),
(x"00", x"29", x"4D", x"52", x"56", x"77", x"7B", x"7B", x"76", x"56", x"52", x"52", x"52", x"52", x"52", x"52", x"4D", x"56", x"56", x"56", x"56", x"56", x"7B", x"7B", x"7B", x"56", x"52", x"29", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"04", x"24", x"24", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"4D", x"25", x"00", x"00", x"00", x"24", x"24", x"24", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("000111111111111111111111111000"),
("111111111111111111111111111110"),
("111111111111111111111111111110"),
("111111111111111111111111111111"),
("111111111111111111111111111111"),
("111111111111111111111111111111"),
("111111111111111111111111111111"),
("111111111111111111111111111111"),
("111111111111111111111111111111"),
("111111111111111111111111111111"),
("111111111111111111111111111111"),
("111111111111111111111111111111"),
("111111111111111111111111111110"),
("111111111111111111111111111110"),
("000111111111111111111111111000")
);

signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

signal objectEndX : integer;
signal objectEndY : integer;

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


process ( RESETn, CLK)
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;

		elsif rising_edge(CLK) then
			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	--get from colors table 
			drawing_request	<= object(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ; -- get from mask table if inside rectangle  
	end if;
  end process;
end behav;		

--generated with PNGtoVHDL tool by Ben Wellingstein
