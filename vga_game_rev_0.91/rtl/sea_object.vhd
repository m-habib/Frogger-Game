library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sea_object is
port 	(
	   CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end sea_object;

architecture behav of sea_object is

constant object_X_size : integer := 32;
constant object_Y_size : integer := 32;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"37", x"37", x"37", x"37", x"37", x"3B", x"7F", x"37", x"37", x"37", x"37", x"3B", x"5B", x"5B", x"5B", x"37", x"37", x"37", x"37", x"37", x"5B", x"37", x"17", x"37", x"3B", x"37", x"37", x"17", x"17", x"7B", x"5B", x"37"),
(x"3B", x"37", x"37", x"37", x"3B", x"5B", x"5B", x"5B", x"5B", x"37", x"37", x"37", x"3B", x"37", x"3B", x"3B", x"37", x"3B", x"37", x"37", x"37", x"37", x"17", x"17", x"37", x"37", x"37", x"37", x"5B", x"5B", x"17", x"37"),
(x"3B", x"5B", x"37", x"37", x"37", x"37", x"5B", x"5B", x"37", x"17", x"37", x"5B", x"37", x"3B", x"37", x"37", x"37", x"3B", x"3B", x"37", x"37", x"5B", x"37", x"37", x"37", x"7B", x"5B", x"3B", x"3B", x"3B", x"37", x"37"),
(x"37", x"3B", x"3B", x"37", x"37", x"5B", x"7B", x"3B", x"37", x"37", x"37", x"37", x"37", x"5B", x"5B", x"3B", x"3B", x"3B", x"3B", x"3B", x"37", x"7B", x"5B", x"37", x"5B", x"7B", x"37", x"17", x"37", x"5B", x"5B", x"3B"),
(x"37", x"3B", x"5B", x"37", x"37", x"3B", x"37", x"37", x"37", x"37", x"37", x"17", x"17", x"5B", x"9F", x"9F", x"5B", x"37", x"3B", x"5B", x"5B", x"9F", x"5B", x"3B", x"3B", x"5B", x"5B", x"5B", x"5B", x"5B", x"37", x"37"),
(x"37", x"37", x"5B", x"5B", x"37", x"5B", x"5B", x"37", x"37", x"37", x"37", x"3B", x"5B", x"5B", x"7F", x"7B", x"5B", x"5B", x"5B", x"5B", x"7F", x"7B", x"5B", x"3B", x"7F", x"5B", x"3B", x"7B", x"5B", x"37", x"37", x"37"),
(x"3B", x"37", x"37", x"3B", x"5B", x"7B", x"37", x"37", x"37", x"37", x"37", x"3B", x"5B", x"3B", x"37", x"37", x"5B", x"5B", x"5B", x"7F", x"5B", x"37", x"37", x"5B", x"5B", x"37", x"37", x"37", x"3B", x"37", x"37", x"37"),
(x"3B", x"37", x"37", x"37", x"7B", x"9F", x"3B", x"37", x"37", x"37", x"37", x"37", x"5B", x"3B", x"37", x"37", x"3B", x"5B", x"7F", x"3B", x"37", x"37", x"5B", x"5B", x"37", x"37", x"37", x"37", x"37", x"3B", x"37", x"37"),
(x"3B", x"37", x"37", x"5B", x"5B", x"5B", x"5B", x"3B", x"3B", x"3B", x"5B", x"5B", x"5B", x"37", x"37", x"5B", x"3B", x"7F", x"7B", x"17", x"37", x"37", x"5B", x"3B", x"37", x"37", x"37", x"37", x"3B", x"5B", x"7F", x"3B"),
(x"37", x"37", x"37", x"37", x"3B", x"37", x"17", x"37", x"37", x"3B", x"3B", x"7B", x"7B", x"37", x"37", x"37", x"37", x"3B", x"5B", x"3B", x"37", x"37", x"5B", x"5B", x"37", x"3B", x"5B", x"5B", x"37", x"5B", x"7B", x"3B"),
(x"3B", x"37", x"37", x"3B", x"5B", x"3B", x"37", x"37", x"37", x"3B", x"5B", x"9F", x"5B", x"37", x"3B", x"37", x"37", x"37", x"3B", x"3B", x"5B", x"3B", x"5B", x"3B", x"37", x"3B", x"3B", x"37", x"3B", x"5B", x"37", x"37"),
(x"37", x"37", x"37", x"3B", x"3B", x"37", x"37", x"5B", x"5B", x"5B", x"5B", x"5B", x"37", x"37", x"37", x"3B", x"37", x"5B", x"37", x"3B", x"37", x"37", x"5B", x"3B", x"37", x"37", x"37", x"37", x"5B", x"3B", x"37", x"37"),
(x"37", x"37", x"5B", x"3B", x"37", x"3B", x"3B", x"5B", x"5B", x"17", x"37", x"5B", x"5B", x"37", x"37", x"3B", x"37", x"3B", x"3B", x"3B", x"3B", x"37", x"37", x"3B", x"7B", x"37", x"37", x"37", x"3B", x"5F", x"3B", x"37"),
(x"37", x"37", x"3B", x"37", x"3B", x"5B", x"37", x"3B", x"7F", x"5B", x"37", x"37", x"5B", x"5B", x"37", x"37", x"37", x"37", x"37", x"5B", x"3B", x"3B", x"5B", x"7B", x"BF", x"5B", x"3B", x"37", x"5B", x"5B", x"37", x"37"),
(x"5B", x"5B", x"3B", x"3B", x"5B", x"37", x"37", x"37", x"5B", x"5B", x"37", x"37", x"3B", x"5B", x"3B", x"37", x"37", x"37", x"3B", x"3B", x"37", x"17", x"37", x"7B", x"5B", x"37", x"3B", x"3B", x"5B", x"5B", x"3B", x"37"),
(x"3B", x"3B", x"3B", x"7F", x"5B", x"37", x"37", x"37", x"3B", x"5B", x"37", x"37", x"3B", x"5B", x"37", x"37", x"3B", x"5B", x"3B", x"3B", x"37", x"37", x"37", x"5B", x"3B", x"3B", x"3B", x"3B", x"3B", x"3B", x"5B", x"3B"),
(x"37", x"3B", x"9F", x"7F", x"37", x"37", x"37", x"37", x"37", x"5B", x"5B", x"3B", x"3B", x"5B", x"5B", x"37", x"5B", x"3B", x"3B", x"5B", x"5B", x"37", x"37", x"37", x"37", x"3B", x"5B", x"37", x"37", x"37", x"5B", x"5B"),
(x"37", x"7F", x"5B", x"37", x"37", x"37", x"37", x"37", x"37", x"5B", x"5B", x"3B", x"3B", x"37", x"5B", x"5B", x"3B", x"5B", x"3B", x"3B", x"5B", x"37", x"17", x"37", x"37", x"37", x"37", x"37", x"37", x"37", x"5B", x"5F"),
(x"37", x"7B", x"5B", x"37", x"37", x"3B", x"5B", x"3B", x"3B", x"3B", x"3B", x"3B", x"3B", x"37", x"5B", x"7B", x"5B", x"37", x"37", x"37", x"5B", x"5B", x"5B", x"37", x"37", x"37", x"37", x"3B", x"37", x"37", x"3B", x"37"),
(x"3B", x"3B", x"37", x"37", x"5B", x"5B", x"5F", x"37", x"37", x"37", x"37", x"5B", x"3B", x"3B", x"7B", x"5B", x"3B", x"3B", x"37", x"3B", x"37", x"3B", x"7F", x"5B", x"37", x"37", x"37", x"5B", x"3B", x"37", x"37", x"37"),
(x"7F", x"5B", x"37", x"37", x"37", x"3B", x"5B", x"3B", x"37", x"37", x"37", x"5B", x"7F", x"7B", x"3B", x"37", x"37", x"37", x"3B", x"5B", x"3B", x"5B", x"5B", x"7B", x"5B", x"37", x"5B", x"7F", x"3B", x"3B", x"3B", x"5B"),
(x"5B", x"3B", x"37", x"37", x"17", x"37", x"37", x"37", x"37", x"37", x"5B", x"5B", x"7F", x"5B", x"3B", x"37", x"37", x"37", x"37", x"37", x"37", x"37", x"37", x"7B", x"9F", x"3B", x"5B", x"3B", x"3B", x"37", x"37", x"37"),
(x"37", x"37", x"37", x"37", x"37", x"37", x"37", x"37", x"17", x"5B", x"5B", x"37", x"37", x"37", x"3B", x"3B", x"3B", x"37", x"17", x"17", x"17", x"17", x"37", x"7F", x"5B", x"37", x"37", x"3B", x"3B", x"3B", x"37", x"3B"),
(x"37", x"37", x"37", x"37", x"3B", x"7B", x"7F", x"3B", x"37", x"5B", x"3B", x"37", x"37", x"37", x"5B", x"7B", x"3B", x"37", x"37", x"37", x"37", x"37", x"3B", x"3B", x"37", x"37", x"37", x"37", x"3B", x"5B", x"5B", x"3B"),
(x"37", x"17", x"37", x"37", x"17", x"5B", x"9F", x"7F", x"5B", x"37", x"3B", x"3B", x"3B", x"7B", x"7B", x"3B", x"37", x"37", x"37", x"37", x"5B", x"5B", x"3B", x"37", x"3B", x"37", x"37", x"37", x"37", x"17", x"5B", x"7F"),
(x"5B", x"37", x"17", x"17", x"17", x"37", x"3B", x"5B", x"5B", x"3B", x"5B", x"5B", x"5B", x"7F", x"5B", x"37", x"37", x"37", x"37", x"37", x"5B", x"5B", x"5B", x"7B", x"7B", x"7B", x"3B", x"37", x"37", x"37", x"7B", x"7B"),
(x"5B", x"5B", x"3B", x"37", x"37", x"3B", x"5B", x"3B", x"3B", x"5B", x"7F", x"3B", x"5B", x"37", x"5B", x"5B", x"3B", x"3B", x"3B", x"5B", x"7B", x"5B", x"7F", x"7F", x"5F", x"3B", x"3B", x"5B", x"5B", x"5B", x"7F", x"5B"),
(x"5B", x"5B", x"3B", x"37", x"37", x"37", x"3B", x"5B", x"37", x"3B", x"5B", x"5B", x"5B", x"5B", x"7B", x"7B", x"5B", x"5B", x"5B", x"5B", x"5B", x"5B", x"3B", x"3B", x"5B", x"37", x"37", x"37", x"5B", x"5B", x"5F", x"3B"),
(x"5B", x"5B", x"5B", x"37", x"37", x"37", x"17", x"3B", x"7F", x"3B", x"37", x"37", x"3B", x"5B", x"5B", x"7F", x"5B", x"37", x"37", x"37", x"37", x"37", x"3B", x"5B", x"3B", x"37", x"37", x"17", x"17", x"37", x"5B", x"5B"),
(x"5B", x"37", x"37", x"37", x"37", x"37", x"37", x"37", x"7B", x"37", x"17", x"37", x"3B", x"3B", x"37", x"5B", x"7B", x"37", x"37", x"37", x"5B", x"3B", x"5B", x"7F", x"3B", x"3B", x"37", x"17", x"37", x"17", x"17", x"7B"),
(x"3B", x"37", x"37", x"37", x"37", x"37", x"3B", x"37", x"37", x"5B", x"3B", x"37", x"3B", x"37", x"3B", x"3B", x"9F", x"3B", x"3B", x"3B", x"3B", x"3B", x"37", x"3B", x"37", x"37", x"3B", x"37", x"37", x"37", x"5B", x"7B"),
(x"5F", x"3B", x"37", x"37", x"3B", x"3B", x"5B", x"37", x"37", x"5B", x"7F", x"3B", x"37", x"3B", x"3B", x"5B", x"5B", x"37", x"37", x"37", x"3B", x"3B", x"37", x"3B", x"3B", x"37", x"37", x"37", x"3B", x"5B", x"5B", x"37")
);


signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';


begin

-- Calculate object end boundaries

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- test if ooCoord is in the rectangle defined by Start and End 
    drawing_Y	<= '1' when  (oCoord_Y  <= 227 ) else '0';

-- calculate offset from start corner 
	bCoord_X 	<= (oCoord_X mod 32) when drawing_Y = '1' else 0 ; 
	bCoord_Y 	<= (oCoord_Y mod 32) when drawing_Y = '1' else 0 ; 


process ( RESETn, CLK)
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;

		elsif rising_edge(CLK) then
			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	--get from colors table 
			drawing_request	<=   drawing_Y ; -- get from mask table if inside rectangle  
	end if;
  end process;
end behav;		