library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity frogWin_26X26_object is
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
end frogWin_26X26_object;

architecture behav of frogWin_26X26_object is

constant object_X_size : integer := 26;
constant object_Y_size : integer := 26;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"62", x"62", x"62", x"62", x"62", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"62", x"62", x"62", x"62", x"62", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C4", x"C4", x"E0", x"E4", x"66", x"89", x"89", x"E4", x"E0", x"E4", x"E4", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C4", x"C4", x"E0", x"E0", x"DD", x"F8", x"F8", x"E0", x"E0", x"E0", x"E0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C4", x"C0", x"E4", x"E8", x"D8", x"F8", x"F8", x"E4", x"E8", x"E4", x"E4", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"F8", x"F8", x"F8", x"F4", x"F8", x"F8", x"F8", x"F8", x"B0", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"24", x"FF", x"B6", x"DB", x"F9", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B6", x"B6", x"92", x"B6", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"DB", x"DB", x"FF", x"FF", x"FF", x"F9", x"F8", x"F8", x"F8", x"F8", x"FA", x"FF", x"FF", x"FF", x"B6", x"DB", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"49", x"FF", x"FF", x"DB", x"6D", x"B6", x"FF", x"F8", x"D8", x"F8", x"F9", x"FF", x"DB", x"92", x"DB", x"FF", x"FF", x"24", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"49", x"FF", x"FF", x"FF", x"92", x"BA", x"DE", x"B9", x"98", x"98", x"B9", x"FF", x"BA", x"6D", x"DB", x"FF", x"FF", x"24", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"B6", x"B6", x"54", x"DB", x"FF", x"DE", x"BD", x"98", x"98", x"98", x"98", x"98", x"B9", x"BE", x"DF", x"FF", x"DB", x"00", x"99", x"95", x"95", x"00", x"00"),
(x"00", x"00", x"99", x"99", x"99", x"98", x"98", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"B9", x"B9", x"99", x"98", x"98", x"99", x"99", x"99", x"BA"),
(x"00", x"99", x"9C", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"99"),
(x"00", x"98", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"99"),
(x"00", x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"FC", x"99"),
(x"99", x"99", x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"99", x"98", x"99", x"99"),
(x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99"),
(x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99"),
(x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98"),
(x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99"),
(x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"95"),
(x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"99", x"E3", x"99"),
(x"95", x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"99"),
(x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99"),
(x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"99", x"99", x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98"),
(x"99", x"99", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"95", x"99", x"98", x"99", x"98", x"99", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98", x"98")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("00000000000111000000000000"),
("00000000000111000000000000"),
("00000000111111111000000000"),
("00000000111111111000000000"),
("00000000111111111000000000"),
("00000000011111111000000000"),
("00000001111111111110000000"),
("00000011111111111111000000"),
("00000011111111111111000000"),
("00000011111111111111000000"),
("00000111111111111111011000"),
("00011111111111111111111100"),
("00011111111111111111111110"),
("00111111111111111111111110"),
("00111111111111111111111100"),
("01111111111111111111111111"),
("11111111111111111111111111"),
("11111111111111111111111111"),
("11111111111111111111111111"),
("11111111111111111111111111"),
("11111111111111111111111111"),
("11111111111111111111111100"),
("11111111111111111111111111"),
("11111111111111111111111111"),
("11111111111111111111111111"),
("11111111111100111111111111")
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
