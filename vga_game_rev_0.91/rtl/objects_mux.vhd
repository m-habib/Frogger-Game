library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun Apr 2017
-- Dudy Nov 13 2017

entity objects_mux is
port 	(
		CLK	: in std_logic; --						//	27 MHz
		f_drawing_request : in std_logic;					--frog
		f_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- f  input signal 
		
		b_drawing_request : in std_logic;	-- background
		b_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- b input signal 

		r_drawing_request : in std_logic;	-- rectangle 
		r_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- r input signal 
		
		yc_drawing_request : in std_logic;	-- yellow car 
		yc_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- yc input signal 
		
		pc_drawing_request : in std_logic;	-- police car 
		pc_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- pc input signal
		
		croco_drawing_request : in std_logic;	-- crocodile object
		croco_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- croco input signal 
		
		ga1_drawing_request : in std_logic;	-- goal achived object
		ga1_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- g input signal 
		
		sea_drawing_request : in std_logic;	-- goal object
		sea_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- g input signal 
		
		ga2_drawing_request : in std_logic;	-- goal achived object
		ga2_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- g input signal 
		
		g3_drawing_request : in std_logic;	-- goal object
		g3_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- g input signal 
		
		ga3_drawing_request : in std_logic;	-- goal achived object
		ga3_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- g input signal 
		
		g4_drawing_request : in std_logic;	-- goal object
		g4_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- g input signal 
		
		ga4_drawing_request : in std_logic;	-- goal achived object
		ga4_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- g input signal 
		
		g5_drawing_request : in std_logic;	-- goal object
		g5_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- g input signal 
		
		ga5_drawing_request : in std_logic;	-- goal achived object
		ga5_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- g input signal 
		
		p_drawing_request : in std_logic;	-- plank
		p_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- p input signal 
		
		gameover_drawing_request : in std_logic;	-- game over object
		gameover_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- gameover input signal 
		
		p2_drawing_request : in std_logic;	-- plank_2 and bottom pass
		p2_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- p2 input signal 

		border_drawing_request : in std_logic;	-- border
		border_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- border input signal 
		
		s1_drawing_request : in std_logic;	-- ship1
		s1_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- ship1 input signal 
		
		s2_drawing_request : in std_logic;	-- ship 2
		s2_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- ship2 input signal 
		
		c3_drawing_request : in std_logic;	-- car 3
		c3_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- car 3 input signal 
		
		c4_drawing_request : in std_logic;	-- car 4 
		c4_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  --  car 4 input signal 		
		
		c5_drawing_request : in std_logic;	-- car 5 
		c5_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  --  car 5 input signal 
				
		ti_drawing_request : in std_logic;	-- timebar 
		ti_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  --  timebar input signal 

		life_drawing_request : in std_logic;	-- lifebar 
		life_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  --  lifebar input signal 

		lifeBonus_drawing_req : in std_logic;	-- lifebonus 
		lifeBonus_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  --  lifebonus input signal 

		
		m_mVGA_R 	: out std_logic_vector(7 downto 0); --	,  
		m_mVGA_G 	: out std_logic_vector(7 downto 0); --	, 
		m_mVGA_B 	: out std_logic_vector(7 downto 0); --	, 
		RESETn : in std_logic
	);
end objects_mux;

architecture behav of objects_mux is 
signal m_mVGA_t 	: std_logic_vector(7 downto 0); --	,  

begin

-- priority encoder process

process ( RESETn, CLK)
begin 
	if RESETn = '0' then
			m_mVGA_t	<=  (others => '0') ; 	

	elsif rising_edge(CLK) then
		if (gameover_drawing_request = '1' ) then  
			m_mVGA_t <= gameover_mVGA_RGB;  
		elsif (f_drawing_request = '1' ) then  
			m_mVGA_t <= f_mVGA_RGB;
 		elsif (border_drawing_request = '1' ) then  
			m_mVGA_t <= border_mVGA_RGB; 
		elsif (p_drawing_request = '1' ) then  
			m_mVGA_t <= p_mVGA_RGB;  
		elsif (p2_drawing_request = '1' ) then  
			m_mVGA_t <= p2_mVGA_RGB;    
		elsif (life_drawing_request = '1' ) then  
			m_mVGA_t <= life_mVGA_RGB;  	
		elsif (ti_drawing_request = '1' ) then  
			m_mVGA_t <= ti_mVGA_RGB;  	
		elsif (lifeBonus_drawing_req = '1' ) then  
			m_mVGA_t <= lifeBonus_mVGA_RGB;  	
	
	
		elsif (s1_drawing_request = '1' ) then  
			m_mVGA_t <= s1_mVGA_RGB;    
		elsif (s2_drawing_request = '1' ) then  
			m_mVGA_t <= s2_mVGA_RGB;    
		elsif (c3_drawing_request = '1' ) then  
			m_mVGA_t <= c3_mVGA_RGB;    
		elsif (c4_drawing_request = '1' ) then  
			m_mVGA_t <= c4_mVGA_RGB;    
		elsif (c5_drawing_request = '1' ) then  
			m_mVGA_t <= c5_mVGA_RGB;  
			
			
			
		elsif (r_drawing_request = '1') then
			m_mVGA_t <= r_mVGA_RGB ; 
		elsif (yc_drawing_request = '1') then
			m_mVGA_t <= yc_mVGA_RGB ; 
		elsif (pc_drawing_request = '1') then
			m_mVGA_t <= pc_mVGA_RGB ;
			
			
			
			
			
			
		elsif (ga1_drawing_request = '1') then
			m_mVGA_t <= ga1_mVGA_RGB ; 
		elsif (ga2_drawing_request = '1') then
			m_mVGA_t <= ga2_mVGA_RGB ; 
		elsif (ga3_drawing_request = '1') then
			m_mVGA_t <= ga3_mVGA_RGB ; 
		elsif (g3_drawing_request = '1') then
			m_mVGA_t <= g3_mVGA_RGB ;
		elsif (ga4_drawing_request = '1') then
			m_mVGA_t <= ga4_mVGA_RGB ; 
		elsif (g4_drawing_request = '1') then
			m_mVGA_t <= g4_mVGA_RGB ;
		elsif (ga5_drawing_request = '1') then
			m_mVGA_t <= ga5_mVGA_RGB ; 
		elsif (g5_drawing_request = '1') then
			m_mVGA_t <= g5_mVGA_RGB ;		
		elsif (croco_drawing_request = '1') then
			m_mVGA_t <= croco_mVGA_RGB ;
			
			
			
		elsif (sea_drawing_request = '1') then
			m_mVGA_t <= sea_mVGA_RGB ;
		else
			m_mVGA_t <= b_mVGA_RGB ;
		end if; 
	end if ; 

end process ;

m_mVGA_R	<= m_mVGA_t(7 downto 5)& "00000"; -- expand to 10 bits 
m_mVGA_G	<= m_mVGA_t(4 downto 2)& "00000";
m_mVGA_B	<= m_mVGA_t(1 downto 0)& "000000";


end behav;