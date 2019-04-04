library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity display_life is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  					: in std_logic  ;
		RESETn				: in std_logic  ;
		oCoord_X				: in integer    ;
		oCoord_Y				: in integer    ;
		achived_1			: in std_logic  ;
		achived_2			: in std_logic  ;
		achived_3			: in std_logic  ;
		achived_4			: in std_logic  ;
		achived_5			: in std_logic  ;
		drawing_req_1		: in std_logic  ;
		drawing_req_2		: in std_logic  ;
		drawing_req_3		: in std_logic  ;
		drawing_req_4		: in std_logic  ;
		drawing_req_5		: in std_logic  ;
		drawing_request_1	: out std_logic ;
		drawing_request_2	: out std_logic ;
		drawing_request_3	: out std_logic ;
		drawing_request_4	: out std_logic ;
		drawing_request_5	: out std_logic 
	);
end display_life;

architecture behav of display_life is 
begin

process (RESETn, CLK)
   begin
	if RESETn = '0' then
		drawing_request_1 <= '0';
		drawing_request_2 <= '0';
		drawing_request_3 <= '0';
		drawing_request_4 <= '0';
		drawing_request_5 <= '0';
	elsif rising_edge(CLK) then
		drawing_request_1 <= achived_1 and drawing_req_1;
		drawing_request_2 <= achived_2 and drawing_req_2;
		drawing_request_3 <= achived_3 and drawing_req_3;
		drawing_request_4 <= achived_4 and drawing_req_4;
		drawing_request_5 <= achived_5 and drawing_req_5;
	end if;
  end process;	
end behav;		
		