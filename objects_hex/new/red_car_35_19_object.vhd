library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity red_car_35_19_object is
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
end red_car_35_19_object;

architecture behav of red_car_35_19_object is

constant object_X_size : integer := 35;
constant object_Y_size : integer := 19;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"60", x"40", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"24", x"04", x"40", x"80", x"A0", x"80", x"80", x"80", x"60", x"80", x"80", x"80", x"80", x"A0", x"A0", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"60", x"60", x"60", x"60", x"60", x"8C", x"6C", x"00", x"24", x"00"),
(x"00", x"49", x"80", x"C0", x"C0", x"E0", x"E0", x"E0", x"C0", x"80", x"84", x"84", x"84", x"84", x"85", x"85", x"65", x"A0", x"E0", x"E0", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"B0", x"D4", x"6C", x"00", x"00"),
(x"24", x"6D", x"A0", x"C0", x"C0", x"C0", x"E0", x"E0", x"C0", x"80", x"2E", x"17", x"17", x"13", x"13", x"13", x"2E", x"A0", x"A0", x"84", x"49", x"84", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"A0", x"A4", x"68", x"29", x"92"),
(x"49", x"6D", x"C0", x"E0", x"C0", x"C0", x"C0", x"E0", x"E0", x"C0", x"60", x"64", x"64", x"64", x"64", x"60", x"80", x"A0", x"2E", x"37", x"37", x"32", x"A0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"E0", x"E0", x"E0", x"84", x"4D", x"00"),
(x"4D", x"69", x"C0", x"E0", x"E0", x"C0", x"C0", x"80", x"84", x"64", x"80", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"2E", x"37", x"37", x"37", x"65", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"6D", x"24"),
(x"6D", x"89", x"C0", x"E0", x"E0", x"E0", x"80", x"33", x"37", x"33", x"60", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"2E", x"37", x"37", x"37", x"49", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"6E", x"49"),
(x"6D", x"89", x"C0", x"E0", x"E0", x"E0", x"80", x"37", x"37", x"37", x"60", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"2E", x"37", x"37", x"37", x"2E", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"6E", x"4D"),
(x"6D", x"89", x"C0", x"E0", x"E0", x"E0", x"84", x"37", x"37", x"37", x"64", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"2E", x"37", x"37", x"37", x"2E", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"8D", x"6D"),
(x"6D", x"89", x"C0", x"E0", x"E0", x"E0", x"84", x"37", x"37", x"37", x"64", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"2E", x"37", x"37", x"37", x"32", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"8D", x"6D"),
(x"6D", x"89", x"C0", x"E0", x"E0", x"E0", x"84", x"37", x"37", x"37", x"64", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"2E", x"37", x"37", x"37", x"2E", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"8D", x"6D"),
(x"4D", x"89", x"C0", x"E0", x"E0", x"E0", x"84", x"37", x"37", x"37", x"64", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"2E", x"37", x"37", x"37", x"4E", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"6D", x"4D"),
(x"4D", x"69", x"C0", x"E0", x"E0", x"E0", x"84", x"33", x"37", x"37", x"44", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"2E", x"37", x"37", x"37", x"49", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"6D", x"49"),
(x"49", x"69", x"C0", x"E0", x"E0", x"C0", x"A0", x"A0", x"80", x"84", x"80", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"2E", x"37", x"37", x"37", x"84", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"6D", x"29"),
(x"25", x"69", x"C0", x"E0", x"C0", x"C0", x"C0", x"E0", x"E0", x"E0", x"A0", x"64", x"65", x"65", x"45", x"45", x"64", x"A0", x"49", x"33", x"37", x"49", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"E0", x"E0", x"A0", x"4D", x"00"),
(x"00", x"49", x"A0", x"C0", x"C0", x"C0", x"E0", x"E0", x"E0", x"C0", x"64", x"33", x"33", x"33", x"33", x"37", x"33", x"84", x"C0", x"80", x"84", x"C0", x"E0", x"E0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"A0", x"A8", x"68", x"29", x"FF"),
(x"FF", x"24", x"80", x"C0", x"C0", x"E0", x"E0", x"E0", x"C0", x"C0", x"80", x"84", x"84", x"84", x"84", x"84", x"84", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"AC", x"D8", x"6C", x"00", x"00"),
(x"00", x"00", x"40", x"80", x"80", x"80", x"60", x"60", x"60", x"60", x"60", x"60", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"60", x"60", x"60", x"60", x"68", x"6C", x"00", x"24", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"60", x"60", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("00111111111111111111111111111110000"),
("01111111111111111111111111111111100"),
("11111111111111111111111111111111110"),
("11111111111111111111111111111111110"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111110"),
("01111111111111111111111111111111110"),
("01111111111111111111111111111111100"),
("00111111111111111111111111111110000")
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
