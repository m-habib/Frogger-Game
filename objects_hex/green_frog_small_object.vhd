library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity green_frog_small_object is
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
end green_frog_small_object;

architecture behav of green_frog_small_object is

constant object_X_size : integer := 22;
constant object_Y_size : integer := 18;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"FF", x"5D", x"5D", x"3C", x"3C", x"1C", x"3C", x"0C", x"0C", x"0C", x"0C", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"08", x"10", x"0C", x"38", x"38", x"18", x"18", x"08", x"24", x"0C", x"0C", x"0C", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"0C", x"0C", x"0C", x"0C", x"08", x"0C", x"14", x"34", x"38", x"10", x"0C", x"0C", x"0C", x"0C", x"0C", x"0C", x"49", x"00", x"00"),
(x"00", x"00", x"0C", x"0C", x"0C", x"0C", x"0C", x"0C", x"0C", x"34", x"3C", x"38", x"14", x"0C", x"0C", x"0C", x"0C", x"0C", x"0C", x"49", x"00", x"00"),
(x"00", x"00", x"0C", x"0C", x"0C", x"0C", x"0C", x"08", x"14", x"38", x"38", x"14", x"34", x"10", x"10", x"14", x"18", x"18", x"04", x"00", x"00", x"00"),
(x"00", x"00", x"0C", x"0C", x"0C", x"0C", x"0C", x"0C", x"10", x"10", x"10", x"10", x"10", x"10", x"10", x"18", x"18", x"18", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"08", x"10", x"10", x"10", x"34", x"34", x"10", x"10", x"10", x"10", x"34", x"3C", x"3C", x"3C", x"1C", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"1C", x"1C", x"38", x"3C", x"3C", x"38", x"38", x"34", x"14", x"18", x"1C", x"3C", x"1C", x"1C", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"1C", x"1C", x"3C", x"3C", x"3C", x"38", x"3C", x"10", x"38", x"1C", x"1C", x"1C", x"1C", x"1C", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"10", x"10", x"10", x"1C", x"3C", x"58", x"34", x"38", x"34", x"38", x"3C", x"1C", x"1C", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"0C", x"0C", x"10", x"38", x"34", x"34", x"10", x"10", x"10", x"10", x"10", x"14", x"14", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"2C", x"0C", x"08", x"34", x"34", x"34", x"34", x"34", x"10", x"10", x"10", x"0C", x"34", x"5D", x"34", x"10", x"0C", x"0C", x"00", x"00"),
(x"00", x"00", x"2C", x"10", x"0C", x"10", x"18", x"14", x"34", x"3C", x"34", x"14", x"18", x"10", x"38", x"3C", x"38", x"0C", x"0C", x"0C", x"00", x"00"),
(x"00", x"00", x"0C", x"0C", x"0C", x"10", x"10", x"0C", x"0C", x"34", x"38", x"14", x"18", x"0C", x"14", x"38", x"14", x"0C", x"10", x"08", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"0C", x"18", x"0C", x"0C", x"0C", x"10", x"3C", x"18", x"0C", x"10", x"18", x"14", x"10", x"0C", x"0C", x"2C", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"0C", x"0C", x"0C", x"0C", x"0C", x"0C", x"0C", x"0C", x"14", x"14", x"0C", x"00", x"0C", x"04", x"2C", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"10", x"10", x"0C", x"0C", x"0C", x"0C", x"0C", x"10", x"0C", x"10", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("0000000000000000000000"),
("0000000001111001100000"),
("0000000011111101100000"),
("0000111111111111110000"),
("0000111111111111110000"),
("0001111111111111100000"),
("0001111111111111100000"),
("0000011111111111100000"),
("0000011111111111100000"),
("0000011111111111100000"),
("0000111111111110000000"),
("0000111111111110000000"),
("0000111111111111111000"),
("0000111111111111111000"),
("0000111111111111110000"),
("0000001111111111110000"),
("0000001111011111010000"),
("0000000111011110000000")
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
