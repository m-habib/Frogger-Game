library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity new_croco\croco_2_32X32_object is
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
end new_croco\croco_2_32X32_object;

architecture behav of new_croco\croco_2_32X32_object is

constant object_X_size : integer := 32;
constant object_Y_size : integer := 32;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"00", x"40", x"40", x"40", x"40", x"40", x"00", x"20", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"00", x"20", x"40", x"84", x"A4", x"84", x"60", x"20", x"00", x"20", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"01", x"40", x"40", x"64", x"A4", x"C8", x"C8", x"84", x"40", x"40", x"02", x"20", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"40", x"20", x"44", x"84", x"84", x"60", x"A4", x"E8", x"C8", x"A4", x"64", x"20", x"40", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"20", x"64", x"C8", x"A4", x"60", x"A4", x"E8", x"E8", x"C8", x"64", x"20", x"40", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"84", x"20", x"84", x"C8", x"C8", x"C4", x"C4", x"E8", x"E8", x"C8", x"64", x"20", x"20", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"20", x"40", x"40", x"A4", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"AC", x"64", x"20", x"20", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"00", x"20", x"60", x"A4", x"C8", x"E8", x"E8", x"E8", x"E8", x"C8", x"AC", x"70", x"28", x"04", x"24", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"01", x"40", x"40", x"84", x"C8", x"E8", x"E8", x"CC", x"CC", x"A8", x"88", x"70", x"54", x"0C", x"04", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"20", x"60", x"A4", x"C8", x"E8", x"E8", x"C8", x"AC", x"90", x"4C", x"24", x"2C", x"34", x"0C", x"04", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"04", x"00", x"04", x"08", x"08", x"08", x"24", x"40", x"40", x"60", x"A4", x"E8", x"E8", x"E8", x"C8", x"A8", x"70", x"54", x"2C", x"04", x"08", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"04", x"04", x"08", x"30", x"30", x"30", x"6C", x"88", x"A4", x"C4", x"C8", x"E8", x"E8", x"C8", x"84", x"44", x"2C", x"34", x"0C", x"04", x"04", x"08", x"04", x"00", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"04", x"04", x"0C", x"34", x"38", x"58", x"90", x"C8", x"E8", x"E8", x"E8", x"E8", x"CC", x"AC", x"64", x"20", x"08", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"20", x"04", x"2C", x"34", x"38", x"54", x"90", x"C8", x"E8", x"E8", x"E8", x"C8", x"AC", x"70", x"28", x"04", x"04", x"08", x"04", x"00", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"40", x"40", x"40", x"44", x"4C", x"70", x"74", x"70", x"AC", x"E8", x"E8", x"E8", x"C8", x"A8", x"70", x"54", x"0C", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"44", x"84", x"A4", x"A8", x"A8", x"AC", x"AC", x"CC", x"C8", x"E8", x"E8", x"C8", x"84", x"44", x"4C", x"34", x"0C", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"CC", x"AC", x"AC", x"AC", x"CC", x"E8", x"E8", x"E8", x"C8", x"A4", x"64", x"20", x"08", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"AC", x"90", x"74", x"90", x"AC", x"E8", x"E8", x"E8", x"A4", x"40", x"40", x"01", x"04", x"04", x"04", x"00", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"AC", x"94", x"54", x"74", x"90", x"CC", x"E8", x"C8", x"64", x"20", x"64", x"24", x"04", x"04", x"04", x"00", x"04", x"08", x"04", x"00", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"CC", x"AC", x"74", x"74", x"90", x"C8", x"E8", x"C8", x"84", x"20", x"00", x"04", x"08", x"2C", x"08", x"04", x"08", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"21", x"45", x"AD", x"CC", x"CC", x"AC", x"90", x"AC", x"E8", x"E8", x"E8", x"A4", x"60", x"40", x"44", x"2C", x"54", x"2C", x"24", x"48", x"70", x"28", x"04", x"04", x"08", x"04", x"00", x"04", x"08", x"04", x"00", x"04"),
(x"05", x"29", x"72", x"AD", x"C8", x"C8", x"CC", x"C8", x"E8", x"E8", x"E8", x"C4", x"A4", x"A4", x"88", x"70", x"74", x"70", x"88", x"A8", x"AC", x"64", x"20", x"08", x"2C", x"28", x"04", x"28", x"2C", x"28", x"04", x"00"),
(x"05", x"29", x"72", x"AD", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"AC", x"90", x"AC", x"C8", x"E8", x"C8", x"84", x"44", x"48", x"70", x"48", x"44", x"48", x"70", x"68", x"44", x"40"),
(x"20", x"45", x"AD", x"C8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"CC", x"C8", x"E8", x"E8", x"E8", x"C8", x"A8", x"A8", x"AC", x"A8", x"A8", x"A8", x"AC", x"A8", x"84", x"40"),
(x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"84", x"44"),
(x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"A4", x"60", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"41"),
(x"20", x"64", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"64", x"20", x"04", x"04", x"04", x"20", x"20", x"20", x"20", x"20", x"04", x"04", x"04", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20"),
(x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"64", x"20", x"08", x"2D", x"08", x"04", x"04", x"00", x"04", x"04", x"08", x"2C", x"08", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"E8", x"C8", x"A4", x"40", x"20", x"08", x"2C", x"0C", x"08", x"04", x"00", x"04", x"04", x"08", x"2C", x"0C", x"08", x"04", x"03", x"04", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"C8", x"84", x"40", x"20", x"00", x"04", x"08", x"0C", x"2C", x"08", x"04", x"04", x"00", x"04", x"08", x"0C", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"60", x"84", x"A8", x"AC", x"AC", x"AC", x"68", x"28", x"08", x"08", x"08", x"08", x"0C", x"2C", x"08", x"04", x"04", x"08", x"08", x"08", x"0C", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"02", x"20", x"44", x"68", x"70", x"74", x"74", x"54", x"30", x"30", x"30", x"30", x"30", x"0C", x"08", x"04", x"04", x"08", x"30", x"30", x"10", x"0C", x"08", x"04", x"02", x"04", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("00000000000000000011111110000000"),
("00000000000000000011111110000000"),
("00000000000000000111111111000000"),
("00000000000000001111111111100000"),
("00000000000000001111111111100000"),
("00000000000000001111111111100000"),
("00000000000000111111111111100000"),
("00000000000000111111111111100000"),
("00000000000001111111111111100000"),
("00000000011111111111111111100000"),
("00001111111111111111111111100000"),
("00001111111111111111111111100000"),
("00001111111111111111111000000000"),
("00111111111111111111111000000000"),
("11111111111111111110000000000000"),
("11111111111111111110000000000000"),
("11111111111111111110000000000000"),
("11111111111111011110000000000000"),
("11111111111110011111111000000000"),
("11111111111111111111111000000000"),
("11111111111111111111111111111110"),
("11111111111111111111111111111110"),
("11111111111111111111111111111111"),
("11111111111111111111111111111111"),
("11111111111111111111111111111111"),
("11111111111111111111111111111111"),
("11111111111111111111111111111110"),
("11111111111111100011111000000000"),
("11111111111111111011111100000000"),
("11111111111111111011111110000000"),
("11111111111111111111111110000000"),
("01111111111111111111111100000000")
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
