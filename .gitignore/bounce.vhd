library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  btn: in STD_LOGIC_VECTOR (4 downto 0);
           Hsync : out  STD_LOGIC;
           Vsync : out  STD_LOGIC;
           vgaRed : out  STD_LOGIC_VECTOR (2 downto 0);
           vgaGreen : out  STD_LOGIC_VECTOR (2 downto 0);
           vgaBlue : out  STD_LOGIC_VECTOR (2 downto 1));
end vga;

architecture Behavioral of vga is TYPE State IS (A, B, C) ;

signal clock_50 : std_logic;
signal clock_25 : std_logic;
--TYPE State_type IS (A, B, C);  -- Define the states
SIGNAL NEXT_STATE,Current_ST : State;
signal mystate:STD_LOGIC_VECTOR (2 downto 0);


begin



                     clockA: process (clk) is
    begin
                        if clk'event and clk='1' then
                                clock_50 <=  NOT clock_50  ;
                        end if;

                        end process clockA;



                   clockB: process (clock_50) is
    begin
                        if clock_50'event and clock_50='1' then
                                clock_25 <= NOT clock_25;
                        end if;

                        end process clockB;


counter: process (clock_25) is
VARIABLE  clock_count_hor : integer range 1 to 800;
VARIABLE clock_count_ver : integer range 1 to 521;
    begin
            if rising_edge(clock_25) then 
				if (clock_count_hor < 800) then
                        clock_count_hor := clock_count_hor + 1;
								else
                        clock_count_hor := 1;
                   if (clock_count_ver < 521) then
                            clock_count_ver := clock_count_ver + 1;
                        else
                            clock_count_ver := 1;
                    end if;
            end if;

                                if ( (clock_count_hor < 96)  ) then
                                        Hsync <= '0';
                                else
                                Hsync <= '1';
                         end if;

                         if (  (clock_count_ver < 2)) then
                                        Vsync <= '0';
                                elsE
                                        Vsync <= '1';
                         end if;




                          if ( (clock_count_hor>= 166 and clock_count_hor< 350) and
												(clock_count_ver >=390)and (clock_count_ver <400) ) then
												If (btn(2)='1') then
                                        vgaRed <= "000";
                                        vgaGreen <= "111";
                                        vgaBlue <= "00";
                                else
                                        vgaRed <= "000";
                                        vgaGreen <= "000";
                                        vgaBlue <= "00";
												end if;	 
                        
								  elsif ( (clock_count_hor>= 360 and clock_count_hor< 570) and 
											(clock_count_ver >=390)and (clock_count_ver <400) ) then
								  
													If (btn(0)='1') then
                                        vgaRed <= "000";
                                        vgaGreen <= "000";
                                        vgaBlue <= "11";
                                else
                                        vgaRed <= "000";
                                        vgaGreen <= "000";
                                        vgaBlue <= "00";
													 end if;
                         
								  elsif ( (clock_count_hor>= 580 and clock_count_hor< 750) and
										(clock_count_ver >=390)and (clock_count_ver <400) ) then
												
												If (btn(4)='1') then
													  vgaRed <= "111";
                                        vgaGreen <= "000";
                                        vgaBlue <= "00";
                                else
                                        vgaRed <= "000";
                                        vgaGreen <= "000";
                                        vgaBlue <= "00";
                         end if;
								 
								 else
								 vgaRed <= "000";
                                        vgaGreen <= "000";
                                        vgaBlue <= "00";
								 
								 end if;
      end if;
	
    end process counter;
fsm: process (reset,clk,Current_ST,btn)is 
		BEGIN
		--If (reset='1') then
					--	mystate<="000";
				
	--	ELSe rising_edge(clk)  then
							
CASE Current_ST is 
When A=>
			mystate<="000";
				If btn(2)='1' then
					NEXT_STATE<=B;
				else 
					NEXT_STATE<=A;
				end if;
When B=>
			
			If btn(4)='1' then
					mystate<="001";
					NEXT_STATE<=C;
			else 
					NEXT_STATE<=B;
			end if;
When C=>
			
			If btn(0)='1' then
					mystate<="011";
					NEXT_STATE<=A;
			else 
					NEXT_STATE<=C;
			end if;
end CASE;
--end if;
END PROCESS fsm;

end Behavioral;

