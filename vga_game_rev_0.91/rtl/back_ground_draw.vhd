library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun July 24 2017 
-- Dudy Nov 13 2017


entity back_ground_draw is
port 	(
	   CLK      : in std_logic;
		RESETn	: in std_logic;
		oCoord_X : in integer;
		oCoord_Y : in integer;
		mVGA_RGB	: out std_logic_vector(7 downto 0); --	,//	VGA composite RGB
		sea_lastY : out integer
	);
end back_ground_draw;

architecture behav of back_ground_draw is 

-- Constants for frame drawing
constant	x_frame	: integer :=	639;
constant	y_frame	: integer :=	479;
constant	sea_end_const	: integer :=	227;


signal mVGA_R	: std_logic_vector(2 downto 0); --	,	 			//	VGA Red[2:0]
signal mVGA_G	: std_logic_vector(2 downto 0); --	,	 			//	VGA Green[2:0]
signal mVGA_B	: std_logic_vector(1 downto 0); --	,  			//	VGA Blue[1:0]
	
begin

mVGA_RGB <=  mVGA_R & mVGA_G &  mVGA_B ;
sea_lastY <= sea_end_const;
-- defining three rectangles 

process (oCoord_X,oCoord_y )
begin 
	if (oCoord_Y >= 0 and oCoord_Y <= 20) then
		mVGA_R <= "000" ;	
		mVGA_G <= "000" ;	
		mVGA_B <= "00" ;
	elsif (oCoord_Y > 257 and oCoord_Y <= 449) then
		if (oCoord_Y > 288 and oCoord_Y <= 293) then
			mVGA_R <= "110" ;	
			mVGA_G <= "101" ;	
			mVGA_B <= "00" ;
		elsif (oCoord_Y > 364 and oCoord_Y <= 369) then
			mVGA_R <= "111" ;	
			mVGA_G <= "111" ;	
			mVGA_B <= "11" ;
		elsif (oCoord_Y > 332 and oCoord_Y <= 337) or (oCoord_Y > 404 and oCoord_Y <= 409) then
			if ((oCoord_X >= 0 and oCoord_X < 50) or (oCoord_X >= 100 and oCoord_X < 150) or (oCoord_X >= 200 and oCoord_X < 250) or (oCoord_X >= 300 and oCoord_X < 350) or (oCoord_X >= 400 and oCoord_X < 450) or (oCoord_X >= 500 and oCoord_X < 550) or (oCoord_X >= 600 and oCoord_X < 640)) then
				mVGA_R <= "111" ;	
				mVGA_G <= "111" ;	
				mVGA_B <= "11" ;
			else
				mVGA_R <= "010" ;	
				mVGA_G <= "010" ;	
				mVGA_B <= "01" ;
			end if;
		else
			mVGA_R <= "010" ;	
			mVGA_G <= "010" ;	
			mVGA_B <= "01" ;
		end if;
	elsif (oCoord_Y > sea_end_const and oCoord_Y <= 257) then --middle pass
		mVGA_R <= "111" ;	
		mVGA_G <= "110" ;	
		mVGA_B <= "01" ;
	elsif (oCoord_Y > 449 and oCoord_Y <= 456) then
		if((oCoord_X >= 0 and oCoord_X < 64) or (oCoord_X >= 128 and oCoord_X < 192) or (oCoord_X >= 256 and oCoord_X < 320) or (oCoord_X >= 384 and oCoord_X < 448) or (oCoord_X >= 512 and oCoord_X < 576)) then	--bottom pass white
			mVGA_R <= "111" ;	
			mVGA_G <= "111" ;	
			mVGA_B <= "11" ;
		else                       --bottom pass red
			mVGA_R <= "111" ;	
			mVGA_G <= "000" ;	
			mVGA_B <= "00" ;
		end if;
	elsif (oCoord_Y > 456 and oCoord_Y <= y_frame) then	--bottom pass gray
		mVGA_R <= "100" ;	
		mVGA_G <= "100" ;	
		mVGA_B <= "10" ;
	else
		mVGA_R <= "001" ;	
		mVGA_G <= "110" ;	
		mVGA_B <= "11" ;
	end if;
end process ; 
end behav;		