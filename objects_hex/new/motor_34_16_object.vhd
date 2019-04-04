library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity motor_34_16_object is
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
end motor_34_16_object;

architecture behav of motor_34_16_object is

constant object_X_size : integer := 34;
constant object_Y_size : integer := 16;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"8D", x"88", x"68", x"20", x"40", x"40", x"60", x"40", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"AD", x"D1", x"AD", x"40", x"80", x"60", x"40", x"40", x"60", x"40", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"B2", x"B2", x"B2", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"8D", x"D1", x"AD", x"40", x"E0", x"C4", x"80", x"60", x"40", x"40", x"60", x"40", x"00", x"00", x"00", x"00", x"00", x"49", x"00", x"00", x"B2", x"49", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"88", x"24", x"00", x"80", x"E4", x"E4", x"C0", x"80", x"60", x"40", x"00", x"4D", x"00", x"00", x"00", x"00", x"49", x"92", x"91", x"92", x"6D", x"6D"),
(x"00", x"00", x"00", x"01", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"01", x"01", x"00", x"24", x"00", x"20", x"60", x"E4", x"E4", x"C0", x"80", x"40", x"00", x"24", x"24", x"24", x"24", x"49", x"91", x"91", x"8D", x"92", x"6D"),
(x"24", x"00", x"00", x"00", x"00", x"25", x"25", x"04", x"00", x"00", x"00", x"06", x"05", x"6D", x"24", x"24", x"49", x"24", x"60", x"E4", x"E4", x"C0", x"40", x"00", x"00", x"00", x"00", x"00", x"25", x"4D", x"92", x"92", x"91", x"8D"),
(x"00", x"00", x"00", x"01", x"06", x"0A", x"0A", x"05", x"6C", x"00", x"00", x"01", x"6D", x"48", x"24", x"6D", x"6D", x"49", x"24", x"80", x"E4", x"E4", x"80", x"44", x"00", x"01", x"00", x"05", x"05", x"05", x"24", x"6D", x"91", x"91"),
(x"00", x"24", x"49", x"05", x"0A", x"0F", x"0F", x"0A", x"B0", x"00", x"00", x"00", x"8D", x"24", x"49", x"6D", x"92", x"6D", x"24", x"60", x"E4", x"E4", x"80", x"49", x"24", x"05", x"01", x"64", x"84", x"05", x"24", x"49", x"91", x"92"),
(x"00", x"24", x"49", x"05", x"0A", x"0F", x"0F", x"0A", x"B0", x"00", x"00", x"00", x"8D", x"24", x"49", x"6D", x"92", x"6D", x"24", x"60", x"E4", x"E4", x"80", x"49", x"24", x"05", x"01", x"64", x"84", x"05", x"24", x"49", x"91", x"92"),
(x"00", x"00", x"00", x"01", x"06", x"0A", x"0A", x"05", x"6C", x"00", x"00", x"01", x"6D", x"48", x"24", x"6D", x"6D", x"49", x"24", x"80", x"E4", x"C0", x"80", x"44", x"00", x"01", x"00", x"05", x"05", x"05", x"24", x"6D", x"91", x"92"),
(x"24", x"00", x"00", x"00", x"00", x"25", x"25", x"04", x"00", x"00", x"00", x"06", x"05", x"6D", x"24", x"24", x"49", x"24", x"60", x"E4", x"E4", x"A0", x"40", x"00", x"00", x"00", x"00", x"00", x"25", x"6D", x"91", x"91", x"8D", x"B2"),
(x"00", x"00", x"00", x"01", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"01", x"01", x"00", x"24", x"00", x"20", x"60", x"E4", x"E4", x"A0", x"60", x"40", x"00", x"00", x"24", x"24", x"24", x"49", x"91", x"92", x"92", x"91", x"6D"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"88", x"24", x"00", x"80", x"C0", x"E0", x"C0", x"80", x"60", x"40", x"20", x"00", x"00", x"00", x"00", x"00", x"49", x"92", x"92", x"B2", x"B2", x"6D"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"8D", x"D1", x"AD", x"40", x"C0", x"C0", x"80", x"60", x"60", x"40", x"60", x"40", x"00", x"00", x"00", x"00", x"00", x"49", x"DA", x"B6", x"B6", x"92", x"6D"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"AD", x"D1", x"AD", x"40", x"80", x"60", x"40", x"40", x"60", x"40", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"B2", x"B2", x"B2", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"8D", x"88", x"68", x"20", x"40", x"40", x"60", x"40", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("0000000000011111100000000000000000"),
("0000000001111111111000000000000000"),
("0000000001111111111110000000000100"),
("0000000001111111111111001111111110"),
("0000111111111111111111111111111111"),
("0111111111111111111111111111111111"),
("1111111111111111111111111111111111"),
("1111111111111111111111111111111111"),
("1111111111111111111111111111111111"),
("1111111111111111111111111111111111"),
("0111111111111111111111111111111111"),
("0000111111111111111111111111111111"),
("0000000001111111111111001111111111"),
("0000000001111111111110000000011000"),
("0000000001111111111000000000000000"),
("0000000000011111100000000000000000")
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
