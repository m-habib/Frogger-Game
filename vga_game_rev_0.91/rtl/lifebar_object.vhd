library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity lifebar_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  					: in std_logic;
		RESETn				: in std_logic;
		restartN				: in std_logic;
		oCoord_X				: in integer;
		oCoord_Y				: in integer;
		life					: in std_logic_vector(3 downto 0);
		drawing_request	: out std_logic ;
		mVGA_RGB 			: out std_logic_vector(7 downto 0) 
	);
end lifebar_object;

architecture behav of lifebar_object is 
constant size : integer := 8;
constant dist : integer := 4;
constant startX : integer := 530;
constant startY : integer := 7;
signal timebar_width : integer;
begin
process ( RESETn, CLK, restartN)
variable life_int : integer;
   begin
	if restartN = '0' or RESETn = '0' then
		drawing_request <= '0';
	elsif rising_edge(CLK) then
		
		case life is
			when "0000" => life_int := 0; --0
			when "0001" => life_int := 1; --1
			when "0010" => life_int := 2; --2
			when "0011" => life_int := 3; --3
			when "0100" => life_int := 4; --4
			when "0101" => life_int := 5; --5
			when "0110" => life_int := 6; --6
			when "0111" => life_int := 7; --7
			when "1000" => life_int := 8; --8
			when "1001" => life_int := 9; --9
			when others => life_int := 0;
		end case;
		drawing_request <= '0';
		mVGA_RGB <= "00011101";
		if	oCoord_Y >= startY and oCoord_Y < startY + size then 
			if life_int > 0 and oCoord_X >= (startX + ((size + dist) * 0)) and
					oCoord_X < (startX + ((size + dist) * 0) + size) then
						drawing_request <= '1';
			end if;


			if life_int > 1 and oCoord_X >= (startX + ((size + dist) * 1)) and
					oCoord_X < (startX + ((size + dist) * 1) + size) then
						drawing_request <= '1';
			end if;
			
			if life_int > 2 and oCoord_X >= (startX + ((size + dist) * 2)) and
					oCoord_X < (startX + ((size + dist) * 2) + size) then
						drawing_request <= '1';
			end if;
			
			if life_int > 3 and oCoord_X >= (startX + ((size + dist) * 3)) and
					oCoord_X < (startX + ((size + dist) * 3) + size) then
						drawing_request <= '1';
			end if;


			if life_int > 4 and  oCoord_X >= (startX + ((size + dist) * 4)) and
					oCoord_X < (startX + ((size + dist) * 4) + size) then
						drawing_request <= '1';
			end if;

			
			if life_int > 5 and oCoord_X >= (startX + ((size + dist) * 5)) and
					oCoord_X < (startX + ((size + dist) * 5) + size) then
						drawing_request <= '1';
			end if;
			
					
			if life_int > 6 and  oCoord_X >= (startX + ((size + dist) * 6)) and
					oCoord_X < (startX + ((size + dist) * 6) + size) then
						drawing_request <= '1';
			end if;

			if life_int > 7 and  oCoord_X >= (startX + ((size + dist) * 7)) and
					oCoord_X < (startX + ((size + dist) * 7) + size) then
						drawing_request <= '1';
			end if;
		end if;
	end if;
  end process;
end behav;		
		