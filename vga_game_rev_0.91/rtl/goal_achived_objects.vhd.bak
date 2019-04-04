library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity goal_achived_object is
port 	(
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		achived_1			: in std_logic  ;
		achived_2			: in std_logic  ;
		achived_3			: in std_logic  ;
		achived_4			: in std_logic  ;
		achived_5			: in std_logic  ;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end goal_achived_object;

architecture behav of goal_achived_object is

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


signal drawing_Y : std_logic := '0';
signal drawing_X_1 : std_logic := '0';
signal drawing_X_2 : std_logic := '0';
signal drawing_X_3 : std_logic := '0';
signal drawing_X_4 : std_logic := '0';
signal drawing_X_5 : std_logic := '0';
signal drawing_X_6 : std_logic := '0';
--signal drawing_X_10 : std_logic := '0';

signal ObjectStartY : integer := 40;
signal ObjectStartX_1 : integer := 67;
signal ObjectStartX_2 : integer := 161;
signal ObjectStartX_3 : integer := 255;
signal ObjectStartX_4 : integer := 349;
signal ObjectStartX_5 : integer := 443;


signal objectEndX_1 : integer;
signal objectEndX_2 : integer;
signal objectEndX_3 : integer;
signal objectEndX_4 : integer;
signal objectEndX_5 : integer;

begin


-- Calculate object end boundaries
objectEndX_1	<= object_X_size+ObjectStartX_1;
objectEndX_2	<= object_X_size+ObjectStartX_2;
objectEndX_3	<= object_X_size+ObjectStartX_3;
objectEndX_4	<= object_X_size+ObjectStartX_4;
objectEndX_5	<= object_X_size+ObjectStartX_5;
objectEndY	<= object_Y_size+ObjectStartY;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- test if ooCoord is in the rectangle defined by Start and End 
   drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY) else '0';
	drawing_X_1	<= '1' when  (oCoord_X  >= ObjectStartX_1) and  (oCoord_X < objectEndX_1) and achived_1 else '0';
	drawing_X_2	<= '1' when  (oCoord_X  >= ObjectStartX_2) and  (oCoord_X < objectEndX_2) and achived_2 else '0';
	drawing_X_3	<= '1' when  (oCoord_X  >= ObjectStartX_3) and  (oCoord_X < objectEndX_3) and achived_3 else '0';
	drawing_X_4	<= '1' when  (oCoord_X  >= ObjectStartX_4) and  (oCoord_X < objectEndX_4) and achived_4 else '0';
	drawing_X_5	<= '1' when  (oCoord_X  >= ObjectStartX_5) and  (oCoord_X < objectEndX_5) and achived_5 else '0';

-- calculate offset from start corner 
	bCoord_X 	<= (oCoord_X - ObjectStartX_1) when (drawing_X_1 = '1' and  drawing_Y = '1') else
						(oCoord_X - ObjectStartX_2) when (drawing_X_2 = '1' and  drawing_Y = '1') else
						(oCoord_X - ObjectStartX_3) when (drawing_X_3 = '1' and  drawing_Y = '1') else
						(oCoord_X - ObjectStartX_4) when (drawing_X_4 = '1' and  drawing_Y = '1') else
						(oCoord_X - ObjectStartX_5) when (drawing_X_5 = '1' and  drawing_Y = '1') else 0;
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when   (
																	( drawing_X_1 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_2 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_3 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_4 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_5 = '1' and  drawing_Y = '1'  )
																	) else 0 ; 


process ( RESETn, CLK)
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;

		elsif rising_edge(CLK) then
			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	--get from colors table 
			drawing_request	<= drawing_request	<= object(bCoord_Y , bCoord_X) and 
										((drawing_X_1 and drawing_Y) or
										(drawing_X_2 and drawing_Y) or
										(drawing_X_3 and drawing_Y) or
										(drawing_X_4 and drawing_Y) or
										(drawing_X_5 and drawing_Y)) ; -- get from mask table if inside rectangle  
	end if;
  end process;
end behav;		

--generated with PNGtoVHDL tool by Ben Wellingstein
