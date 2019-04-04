library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity frog_object is
port 	(
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		ObjectStartX	: in integer;
		ObjectStartY 	: in integer;
		direction			: in std_logic_vector(1 downto 0);
		hit_N 					: in std_logic;
		drawing_request	: out std_logic ;
		crocodile_hit_N	: in std_logic;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end frog_object;

architecture behav of frog_object is

constant object_X_size : integer := 26;
constant object_Y_size : integer := 26;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"04", x"04", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"38", x"00", x"08", x"08", x"08", x"04", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"08", x"0C", x"30", x"30", x"08", x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"00", x"0C", x"30", x"30", x"30", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"04", x"10", x"30", x"30", x"30", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"08", x"30", x"30", x"30", x"0C", x"04", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"04", x"30", x"34", x"38", x"30", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"34", x"38", x"34", x"08", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"08", x"34", x"38", x"08", x"00", x"00", x"00", x"00", x"04", x"04", x"00", x"00", x"00", x"00", x"0C", x"38", x"0C", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"08", x"34", x"04", x"00", x"00", x"08", x"30", x"34", x"34", x"0C", x"00", x"00", x"00", x"08", x"30", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"04", x"30", x"04", x"00", x"08", x"34", x"38", x"38", x"38", x"38", x"0C", x"00", x"00", x"0C", x"0C", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"BE", x"00", x"2C", x"04", x"04", x"30", x"34", x"38", x"38", x"38", x"38", x"34", x"08", x"00", x"0C", x"08", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"0C", x"08", x"0C", x"38", x"34", x"38", x"38", x"38", x"38", x"34", x"30", x"04", x"0C", x"04", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"08", x"0C", x"34", x"34", x"2C", x"0C", x"38", x"34", x"08", x"4D", x"34", x"30", x"0C", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"34", x"34", x"96", x"6D", x"24", x"34", x"51", x"24", x"B2", x"71", x"38", x"0C", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"0C", x"34", x"BA", x"B6", x"92", x"51", x"75", x"92", x"DB", x"96", x"34", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"0C", x"34", x"B6", x"FF", x"DB", x"51", x"75", x"FF", x"FF", x"75", x"34", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"0C", x"38", x"51", x"B6", x"71", x"34", x"34", x"96", x"96", x"34", x"38", x"08", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"0C", x"34", x"30", x"0C", x"04", x"0C", x"38", x"34", x"30", x"34", x"38", x"38", x"30", x"30", x"38", x"38", x"08", x"04", x"0C", x"30", x"10", x"08", x"00", x"00"),
(x"00", x"04", x"18", x"38", x"38", x"38", x"34", x"30", x"38", x"38", x"34", x"34", x"38", x"38", x"34", x"34", x"38", x"38", x"30", x"34", x"38", x"38", x"38", x"10", x"00", x"00"),
(x"00", x"04", x"14", x"38", x"38", x"38", x"38", x"30", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"34", x"34", x"38", x"38", x"38", x"18", x"10", x"00", x"00"),
(x"04", x"08", x"14", x"38", x"34", x"38", x"38", x"30", x"34", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"34", x"34", x"38", x"38", x"38", x"18", x"0C", x"0C", x"00"),
(x"04", x"30", x"30", x"38", x"30", x"34", x"38", x"18", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"34", x"34", x"34", x"30", x"30", x"00"),
(x"00", x"0C", x"30", x"34", x"34", x"0C", x"10", x"14", x"14", x"18", x"38", x"38", x"38", x"38", x"38", x"38", x"14", x"14", x"14", x"30", x"0C", x"38", x"34", x"34", x"08", x"00"),
(x"00", x"04", x"30", x"34", x"38", x"0C", x"04", x"00", x"04", x"08", x"10", x"38", x"38", x"38", x"38", x"14", x"08", x"00", x"00", x"04", x"30", x"38", x"30", x"0C", x"00", x"00"),
(x"00", x"00", x"04", x"0C", x"34", x"0C", x"00", x"00", x"00", x"00", x"00", x"08", x"0C", x"0C", x"08", x"04", x"00", x"00", x"00", x"00", x"30", x"34", x"08", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"30", x"08", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"30", x"08", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"00", x"04", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("00001111110000001111110000"),
("00111111110000001111111100"),
("00111111110000001111111100"),
("00111111110000001111111100"),
("00111111111111101111111100"),
("00011111111111111111111000"),
("00011111111111111111110000"),
("00001111111111111111100000"),
("00000111111111111111100000"),
("00000111111111111111100000"),
("00000111111111111111100000"),
("00000111111111111111000000"),
("00100111111111111111101110"),
("01111111111111111111111110"),
("01111111111111111111111110"),
("11111111111111111111111110"),
("11111111111111111111111111"),
("11111111111111111111111111"),
("11111111111111111111111111"),
("11111111111111111111111111"),
("11111111111111111111111111"),
("11111111111111111111111111"),
("01111111111111111111111110"),
("01111110011111111011111100"),
("00111110000111100001111000"),
("00011110000000000001110000")
);

signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

signal objectEndX : integer;
signal objectEndY : integer;
signal croco_counter : integer;
begin

-- Calculate object end boundaries
objectEndX	<= object_X_size+ObjectStartX;
objectEndY	<= object_Y_size+ObjectStartY;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- test if ooCoord is in the rectangle defined by Start and End 


-- calculate offset from start corner 
--	bCoord_X 	<= (oCoord_X - ObjectStartX) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
--	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 


process ( RESETn, CLK)
   begin
	if RESETn = '0' then
	   mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		croco_counter <= 0;
	elsif rising_edge(CLK) then
		if direction = "00" then
			bCoord_X <= (oCoord_X - ObjectStartX);
			bCoord_Y <= (oCoord_Y - ObjectStartY);
		elsif direction = "01" then
			bCoord_Y <= (objectEndY  - oCoord_Y - 1);
			bCoord_X <= (oCoord_X - ObjectStartX);
		elsif direction = "10" then
			bCoord_Y <= (oCoord_X - ObjectStartX);
			bCoord_X <= (oCoord_Y - ObjectStartY);
		elsif direction = "11" then --direction = 11
			bCoord_X <= (oCoord_Y - ObjectStartY);
			bCoord_Y <= (object_Y_size - (oCoord_X - ObjectStartX) - 1);
		else 
			bCoord_Y <= 0;
			bCoord_X <= 0;
		end if;
		if(oCoord_X  >= ObjectStartX) and  (oCoord_X < objectEndX) then
			drawing_X	<= '1'; 
		else 
			drawing_X	<= '0';
		end if;
		if (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY) then
			drawing_Y	<= '1';
		else 
			drawing_Y	<= '0';
		end if;
		drawing_request	<= object(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ; -- get from mask table if inside rectangle  
		if(crocodile_hit_N = '0') then
			croco_counter <= 1;
		end if;
		if ObjectStartY < 69 then
			if object_colors(bCoord_Y , bCoord_X) = "00000000" then
				mVGA_RGB <= "01001010";
			else
				mVGA_RGB <= "11111111";
			end if;
		elsif(hit_N = '0') then
			if object_colors(bCoord_Y , bCoord_X) = "00000000" then
				mVGA_RGB <= "01001010";
			else
				mVGA_RGB <= "11100000";
			end if;
		else
			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	--get from colors table 
			if object_colors(bCoord_Y , bCoord_X) = "00000000" then
				mVGA_RGB <= "01001010";
			end if;
		end if;
		if croco_counter > 0 and croco_counter < 25000000 then
			croco_counter <= croco_counter + 1;
			if object_colors(bCoord_Y , bCoord_X) = "00000000" then
				mVGA_RGB <= "01001010";
			else
				mVGA_RGB <= "11100000";
			end if;
		end if;
	end if;
  end process;
end behav;	