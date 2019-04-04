library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity frog_30_object is
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
end frog_30_object;

architecture behav of frog_30_object is

constant object_X_size : integer := 28;
constant object_Y_size : integer := 30;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"1C", x"3C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"00", x"00", x"00", x"00", x"18", x"18", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"18", x"1C", x"3C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"00", x"00", x"00", x"1C", x"1C", x"00", x"00", x"00", x"00"),
(x"00", x"14", x"14", x"14", x"00", x"00", x"00", x"00", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"14", x"1C", x"18", x"1C", x"1C", x"6D", x"18", x"18", x"00"),
(x"00", x"1C", x"1C", x"18", x"14", x"14", x"14", x"00", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"14", x"18", x"18", x"18", x"1C", x"1C", x"18", x"18", x"00"),
(x"00", x"18", x"1C", x"18", x"1C", x"1C", x"18", x"04", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"1C", x"1C", x"18", x"1C", x"1C", x"1C", x"18", x"00"),
(x"18", x"18", x"1C", x"18", x"1C", x"18", x"18", x"04", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"18", x"1C", x"18", x"1C", x"1C", x"18", x"18", x"00"),
(x"1C", x"1C", x"18", x"18", x"1C", x"18", x"18", x"04", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"10", x"18", x"1C", x"1C", x"1C", x"1C", x"14", x"18", x"00"),
(x"1C", x"1C", x"1C", x"18", x"1C", x"18", x"18", x"00", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"18", x"1C", x"1C", x"1C", x"1C", x"18", x"00", x"00"),
(x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"00", x"00", x"00"),
(x"1C", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"3C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"18", x"18", x"1C", x"1C", x"1C", x"1C", x"00", x"00", x"00"),
(x"14", x"18", x"18", x"1C", x"1C", x"18", x"18", x"18", x"3C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"1C", x"1C", x"1C", x"1C", x"00", x"00", x"00"),
(x"00", x"61", x"14", x"1C", x"1C", x"18", x"14", x"3C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"00", x"00", x"00"),
(x"00", x"00", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"14", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1F", x"1C", x"00", x"00", x"00", x"00"),
(x"00", x"1C", x"1C", x"34", x"14", x"1C", x"1C", x"1C", x"3C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"3C", x"3C", x"1C", x"3C", x"00", x"00", x"00", x"00"),
(x"00", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"3C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"1C", x"1C", x"18", x"18", x"3C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"00", x"00", x"00", x"00", x"00", x"14", x"14"),
(x"00", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"1C", x"1C"),
(x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"3C", x"1C", x"1C", x"18", x"1C", x"1C"),
(x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"3C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C"),
(x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18"),
(x"1C", x"1C", x"18", x"1C", x"1C", x"1C", x"1C", x"18", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"18"),
(x"14", x"14", x"18", x"18", x"1C", x"1C", x"1C", x"1C", x"18", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"18", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18"),
(x"00", x"00", x"00", x"18", x"18", x"1C", x"18", x"1C", x"18", x"18", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"18", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18"),
(x"00", x"00", x"00", x"E3", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"18", x"1C", x"1C", x"1C", x"5C", x"18", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"18", x"18", x"18", x"18"),
(x"00", x"00", x"00", x"00", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"14", x"3C", x"1C", x"1C", x"18", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"18", x"1C", x"18", x"18", x"18", x"18"),
(x"00", x"00", x"00", x"00", x"00", x"18", x"1C", x"1C", x"1C", x"1C", x"18", x"14", x"00", x"00", x"41", x"18", x"1C", x"1C", x"1C", x"1C", x"18", x"1C", x"18", x"14", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("0000000000011111100000110000"),
("0000000000111111100000110000"),
("0000000001111111111000110000"),
("0000000011111111111111110110"),
("0111000111111111111111111110"),
("0111111011111111111111111110"),
("0011111011111111111011111100"),
("1111111011111111111011111000"),
("1111110001111111111111111000"),
("0111111101111111111111111000"),
("0011111111111111111111111000"),
("0011111111111111111111111000"),
("0001111111111111111111111000"),
("0001111111111111111111110000"),
("0001111111111111111111110000"),
("0000111111111111111100000000"),
("0000011111111111111110000000"),
("0110000111111111111110000000"),
("0111100111111111111110000000"),
("0111111111111111111110000000"),
("0111111111111111111100000000"),
("0011111111111111111111111111"),
("1111111111111111111111111111"),
("1111111111111111111111111111"),
("0011111111111111111111111110"),
("0001111111111111111111111110"),
("0000111111111111111111111111"),
("0000011111100111111111111110"),
("0000001111110001111111100000"),
("0000000111110001111110000000")
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
