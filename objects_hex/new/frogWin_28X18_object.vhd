library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity frogWin_28X18_object is
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
end frogWin_28X18_object;

architecture behav of frogWin_28X18_object is

constant object_X_size : integer := 18;
constant object_Y_size : integer := 28;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"66", x"66", x"62", x"62", x"62", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"62", x"62", x"62", x"62", x"62", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"AD", x"E0", x"C4", x"A5", x"66", x"66", x"E4", x"E4", x"E4", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"C4", x"C4", x"E0", x"E0", x"F8", x"F0", x"E0", x"E0", x"E0", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"C4", x"C5", x"E0", x"E4", x"F8", x"F4", x"E0", x"E0", x"E0", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"92", x"F4", x"F4", x"F4", x"F8", x"F8", x"F4", x"F4", x"D4", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"FC", x"F8", x"F8", x"F8", x"F8", x"F8", x"F4", x"F4", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"DB", x"B6", x"FF", x"FA", x"F8", x"F8", x"F8", x"F8", x"DB", x"DB", x"92", x"B6", x"00", x"00", x"00"),
(x"00", x"00", x"B6", x"FF", x"FF", x"DB", x"DB", x"F9", x"F8", x"F8", x"FE", x"FF", x"DB", x"FF", x"FF", x"6D", x"00", x"00"),
(x"00", x"00", x"49", x"FF", x"FF", x"92", x"92", x"FE", x"D8", x"D8", x"FF", x"B6", x"92", x"FF", x"FF", x"24", x"00", x"00"),
(x"00", x"00", x"6D", x"FF", x"FF", x"DB", x"BA", x"BD", x"98", x"98", x"DE", x"B6", x"B6", x"FF", x"FF", x"49", x"00", x"00"),
(x"00", x"B6", x"98", x"78", x"DA", x"DE", x"BD", x"98", x"98", x"98", x"98", x"BD", x"FF", x"DB", x"98", x"99", x"99", x"B2"),
(x"00", x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"99", x"98", x"98", x"99", x"99"),
(x"99", x"BC", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98"),
(x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"BC"),
(x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"98"),
(x"B9", x"9C", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"99", x"99"),
(x"99", x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99"),
(x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98"),
(x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98"),
(x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98"),
(x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99"),
(x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"99"),
(x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"99"),
(x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99"),
(x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98"),
(x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98"),
(x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"98", x"99", x"98", x"98", x"98", x"98", x"98", x"98")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("000000011100000000"),
("000000011100000000"),
("000000111111000000"),
("000001111111000000"),
("000001111111000000"),
("000000111111000000"),
("000000111111000000"),
("000011111111110000"),
("000011111111110000"),
("000011111111110000"),
("000011111111110000"),
("000111111111111100"),
("001111111111111110"),
("001111111111111110"),
("011111111111111110"),
("011111111111111110"),
("001111111111111111"),
("111111111111111111"),
("111111111111111111"),
("111111111111111111"),
("111111111111111111"),
("111111111111111111"),
("111111111111111111"),
("111111111111111110"),
("111111111111111111"),
("111111111111111111"),
("111111111111111111"),
("111111110111111111")
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
