library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity rectangle is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end rectangle;

architecture behav of rectangle is 
constant object_X_size : integer := 32;
constant object_Y_size : integer := 32;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"28", x"08", x"08", x"2C", x"2C", x"2C", x"2C", x"2C", x"08", x"28", x"28", x"2C", x"2C", x"08", x"08", x"28", x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"50", x"4C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C"),
(x"28", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"08", x"2C", x"08", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"28", x"28", x"28", x"08", x"2C", x"2C", x"50", x"2C", x"4C", x"50", x"2C", x"28", x"28", x"50", x"2C"),
(x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"08", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C"),
(x"2C", x"2C", x"2C", x"50", x"2C", x"28", x"2C", x"2C", x"50", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"2C", x"08", x"08", x"08", x"08", x"2C", x"2C", x"2C", x"4C"),
(x"2C", x"08", x"2C", x"50", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"50", x"2C", x"2C", x"08", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"08", x"08", x"2C", x"2C", x"2C", x"2C"),
(x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"28", x"28", x"2C", x"2C", x"28", x"2C", x"2C", x"08", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"50", x"2C", x"2C", x"50", x"2C", x"2C", x"08"),
(x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"08", x"08", x"2C", x"50", x"2C", x"4C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"50", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C"),
(x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"2C", x"2C", x"08", x"08", x"2C", x"2C", x"50", x"2C", x"2C", x"2C", x"2C"),
(x"2C", x"2C", x"2C", x"2C", x"50", x"4C", x"50", x"4C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"08", x"08", x"2C", x"2C", x"50", x"2C", x"28", x"2C", x"2C"),
(x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"50", x"4C", x"28", x"2C", x"4C", x"2C", x"50", x"2C", x"2C", x"2C", x"08", x"2C", x"08", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C"),
(x"2C", x"28", x"50", x"2C", x"2C", x"28", x"2C", x"4C", x"2C", x"2C", x"50", x"50", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C", x"4C", x"2C", x"08", x"50", x"2C", x"2C", x"2C"),
(x"2C", x"2C", x"2C", x"2C", x"08", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"2C", x"08", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C"),
(x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C", x"4C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C"),
(x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"28", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"08", x"4C", x"50", x"2C", x"50", x"2C", x"2C", x"2C", x"50", x"2C", x"2C"),
(x"08", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"28", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"30", x"2C", x"50", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C"),
(x"08", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"4C", x"2C", x"2C", x"08", x"2C", x"2C", x"4C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C"),
(x"2C", x"08", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"50", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"08", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"50", x"2C", x"2C", x"08", x"2C", x"50"),
(x"2C", x"08", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"08", x"2C", x"2C", x"4C", x"2C", x"2C", x"2C", x"2C", x"08", x"2C", x"2C", x"2C", x"28", x"2C", x"2C"),
(x"28", x"28", x"2C", x"4C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"08", x"2C", x"2C", x"2C", x"08", x"2C", x"2C", x"2C", x"2C", x"2C", x"50", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28"),
(x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"50", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C", x"50", x"2C", x"2C"),
(x"2C", x"2C", x"2C", x"08", x"2C", x"2C", x"2C", x"2C", x"50", x"4C", x"50", x"4C", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"08", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C"),
(x"2C", x"2C", x"50", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"50", x"2C", x"28", x"50", x"4C", x"2C", x"50", x"2C", x"28", x"2C", x"50", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C"),
(x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"50", x"2C", x"28", x"28", x"2C", x"4C", x"2C", x"2C", x"50", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"08", x"2C", x"2C", x"08", x"2C", x"2C"),
(x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"28", x"2C", x"50", x"28", x"28", x"28", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C"),
(x"08", x"28", x"2C", x"4C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"2C", x"28", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"08", x"08", x"08", x"50", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C"),
(x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"50", x"4C", x"50", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"4C", x"4C", x"4C", x"2C", x"28"),
(x"2C", x"2C", x"2C", x"28", x"28", x"08", x"28", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"50", x"2C", x"28", x"4C", x"2C", x"2C", x"50", x"2C", x"2C", x"08", x"08", x"2C", x"2C", x"2C", x"2C", x"4C", x"50", x"50", x"4C"),
(x"2C", x"2C", x"50", x"2C", x"28", x"08", x"08", x"28", x"50", x"2C", x"2C", x"28", x"2C", x"4C", x"2C", x"2C", x"50", x"50", x"4C", x"50", x"2C", x"2C", x"08", x"08", x"2C", x"50", x"2C", x"50", x"2C", x"2C", x"50", x"50"),
(x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"08", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"2C", x"2C", x"28", x"08", x"28", x"08", x"4C", x"2C", x"28", x"08", x"2C", x"4C", x"4C"),
(x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C", x"4C", x"4C", x"2C", x"28", x"2C", x"08", x"28", x"2C", x"28", x"2C", x"2C", x"2C", x"28", x"28", x"2C", x"2C", x"2C"),
(x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"08", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"4C"),
(x"2C", x"08", x"28", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"28", x"2C", x"2C", x"08", x"2C", x"4C", x"2C", x"2C", x"2C", x"2C", x"4C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C", x"2C")
);

signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';




begin


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
			if(oCoord_Y >= 21 and oCoord_Y < 33) then
				drawing_request	<= '1';
			elsif (oCoord_X >= 0 and oCoord_X < 50 and oCoord_Y >= 33 and oCoord_Y < 69) then
				drawing_request	<= '1';
			elsif(oCoord_X >=110  and oCoord_X < 170 and oCoord_Y >= 33 and oCoord_Y < 69) then
				drawing_request	<= '1';
			elsif(oCoord_X >= 230 and oCoord_X < 290 and oCoord_Y >= 33 and oCoord_Y < 69) then
				drawing_request	<= '1';
			elsif(oCoord_X >= 350 and oCoord_X < 410 and oCoord_Y >= 33 and oCoord_Y < 69) then
				drawing_request	<= '1';
			elsif(oCoord_X >= 470 and oCoord_X < 530 and oCoord_Y >= 33 and oCoord_Y < 69) then
				drawing_request	<= '1';
			elsif(oCoord_X >= 590 and oCoord_X < 640 and oCoord_Y >= 33 and oCoord_Y < 69) then
				drawing_request	<= '1';
			else
				drawing_request	<= '0';
			end if;
	end if;

  end process;

		
end behav;		
		
		
		
		
		
		
		
		
		
		
		
		
		