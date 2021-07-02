library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity watch2 is 
port(
 	Start, CLK : in STD_LOGIC;--CLK is the clock signal on which it operates
	Reset : in STD_LOGIC;--Reset is used to reset the clock
 	OUTPUTsec : inout STD_LOGIC_VECTOR (5 downto 0);--This will return the Seconds
 	OUTPUTmin : inout STD_LOGIC_VECTOR (5 downto 0);-- This will return the Minutes
 	OUTPUThour : inout STD_LOGIC_VECTOR (5 downto 0);--This will return the Hours
 	secondBCD : inout STD_LOGIC_VECTOR (7 downto 0);--This will show the output in BCD form
 	minuteBCD : inout STD_LOGIC_VECTOR (7 downto 0);--This will show the Minutes in BCD form
 	hourBCD : inout STD_LOGIC_VECTOR (7 downto 0);--This will show the BCD in BCD form
 	secO : out STD_LOGIC_VECTOR (6 downto 0);--This used to show the 0TH seccond in seven segment display
 	secT : out STD_LOGIC_VECTOR (6 downto 0);--This used to show the 10TH seccond in seven segment display
 	minO : out STD_LOGIC_VECTOR (6 downto 0);--This used to show the 0TH minute in seven segment display
 	minT : out STD_LOGIC_VECTOR (6 downto 0);--This used to show the 10TH minute in seven segment display
 	hourO  : out STD_LOGIC_VECTOR (6 downto 0);--This used to show the 0TH Hour in seven segment display
 	hourT : out STD_LOGIC_VECTOR (6 downto 0));--This used to show the 10TH Hour in seven segment display
end watch2;
architecture Behavioral of watch2 is
signal sec,min,hour: std_logic_vector(5 downto 0):="000000";
begin
process(Start, Reset,CLK)--This part is Acting as Clock incrementer
begin
if (Reset = '1' and (Start='1' or Start='0') ) then 
	sec <= (others=> '0');
	min <= (others=> '0');
	hour <= (others=> '0');
ELSif (Start = '1' and rising_edge(CLK)) then--pause 1 show that clock is not paused and clock will work on the rising edge of clock
	if sec="111011" then--IF second = 59
 		sec<="000000";--Reset to 00
		min<=min+1;
		if min="111011" then--IF minute = 59
 		   min<="000000";--Reset to 00
		   hour<=hour+1;
			if hour="010111" then--IF hour = 23
			   hour<="000000";--Reset to 00
 			else
			hour <= hour+1; 
			end if;
		 else 
		 min<=min+1;
		end if;
	else 
	sec <=sec+1;
 	end if; 
end if;
end process;
OUTPUTsec <= sec;
OUTPUTmin <= min;
OUTPUThour <= hour;
BCD1: process(sec)--This is used to convert Second into BCD second (binary Coded Decimal)
	variable z: STD_LOGIC_VECTOR(12 downto 0);
	begin
	for i in 0 to 12 loop
		z(i):='0';
	end loop;
	z(8 downto 3):= sec;--First left Shift 3 times 
	for i in 0 to 2 loop
		if z(9 downto 6)>4 then-- if greater than 4 then add
  			z(9 downto 6) := z(9 downto 6)+3;		
		end if ;
		z(12 downto 1):=z(11 downto 0);--Shift by one place
	end loop;
	secondBCD(6 downto 0)<=z(12 downto 6);
	secondBCD(7)<='0';--it will always be zero for all the no. in the range of 0-59
end process;

BCD2: process(min)--This is used to convert minute into BCD minute (binary Coded Decimal)
	variable z: STD_LOGIC_VECTOR(12 downto 0);	
	begin
	for i in 0 to 12 loop
		z(i):='0';
	end loop;
	z(8 downto 3):= min;
	for i in 0 to 2 loop
		if z(9 downto 6)>4 then
  			 z(9 downto 6) := z(9 downto 6)+3;
		end if ;
		z(12 downto 1):=z(11 downto 0);
	end loop;
	minuteBCD(6 downto 0)<=z(12 downto 6);
	minuteBCD(7)<='0';
end process;
BCD3: process(hour)--This is used to convert hour into BCD hour (binary Coded Decimal)
	variable z: STD_LOGIC_VECTOR(12 downto 0);
	begin
	for i in 0 to 12 loop
		z(i):='0';
	end loop;
	z(8 downto 3):= hour;
	for i in 0 to 2 loop
		if z(9 downto 6)>4 then
  	 		z(9 downto 6) := z(9 downto 6)+3;
		end if ;	
		z(12 downto 1):=z(11 downto 0);	
	end loop;
	hourBCD(6 downto 0)<=z(12 downto 6);
	hourBCD(7)<='0';
end process;
process (secondBCD(3 downto 0))-- for binary second to 0th second 7-segment display  
begin
	case secondBCD(3 downto 0) is
		when "0000" => secO <= "1111110";
		when "0001" => secO <= "0110000";
		when "0010" => secO <= "1101101";
		when "0011" => secO <= "1111001";
		when "0100" => secO <= "0110011";
		when "0101" => secO <= "1011011";
		when "0110" => secO <= "1011111";
		when "0111" => secO <= "1110000";
		when "1000" => secO <= "1111111";
		when "1001" => secO <= "1110011";
		when others => secO <= "1001111";--The shows ERROR
		end case;
	end process;
process (secondBCD(7 downto 4))-- for binary second to 10th second 7-segment display
begin
	case secondBCD(7 downto 4) is
		when "0000" => secT <= "1111110";
		when "0001" => secT <= "0110000";
		when "0010" => secT <= "1101101";
		when "0011" => secT <= "1111001";
		when "0100" => secT <= "0110011";
		when "0101" => secT <= "1011011";
		when "0110" => secT <= "1011111";
		when "0111" => secT <= "1110000";
		when "1000" => secT <= "1111111";
		when "1001" => secT <= "1110011";
		when others => secT <= "1001111";--The shows ERROR
	end case;
end process;
process (minuteBCD(3 downto 0))--for binary minute to 0th minute 7-segment display
begin
	case minuteBCD(3 downto 0) is
		when "0000" => minO <= "1111110";
		when "0001" => minO <= "0110000";
		when "0010" => minO <= "1101101";
		when "0011" => minO <= "1111001";
		when "0100" => minO <= "0110011";
		when "0101" => minO <= "1011011";
		when "0110" => minO <= "1011111";
		when "0111" => minO <= "1110000";
		when "1000" => minO <= "1111111";
		when "1001" => minO <= "1110011";
		when others => minO <= "1001111";--The shows ERROR
	end case;
end process;
process (minuteBCD(7 downto 4))--for binary minute to 10th minute 7-segment display
begin	
	case minuteBCD(7 downto 4) is
		when "0000" => minT <= "1111110";
		when "0001" => minT <= "0110000";
		when "0010" => minT <= "1101101";
		when "0011" => minT <= "1111001";
		when "0100" => minT  <= "0110011";
		when "0101" => minT <= "1011011";
		when "0110" => minT <= "1011111";
		when "0111" => minT <= "1110000";
		when "1000" => minT <= "1111111";
		when "1001" => minT <= "1110011";
		when others => minT <= "1001111";--The shows ERROR
	end case;
end process;
process (hourBCD(3 downto 0))--for binary hour to 0th hour 7-segment display
begin
	case hourBCD(3 downto 0) is
		when "0000" => hourO <= "1111110";
		when "0001" => hourO <= "0110000";
		when "0010" => hourO <= "1101101";
		when "0011" => hourO <= "1111001";
		when "0100" => hourO <= "0110011";
		when "0101" => hourO <= "1011011";
		when "0110" => hourO <= "1011111";
		when "0111" => hourO <= "1110000";
		when "1000" => hourO <= "1111111";
		when "1001" => hourO <= "1110011";
		when others => hourO <= "1001111";--The shows ERROR
	end case;
end process;
process (hourBCD(7 downto 4))--for binary hour to 10th hour 7-segment display
begin
	case hourBCD(7 downto 4) is
		when "0000" => hourT <= "1111110";
		when "0001" => hourT <= "0110000";
		when "0010" => hourT <= "1101101";
		when "0011" => hourT <= "1111001";
		when "0100" => hourT <= "0110011";
		when "0101" => hourT <= "1011011";
		when "0110" => hourT <= "1011111";
		when "0111" => hourT <= "1110000";
		when "1000" => hourT <= "1111111";
		when "1001" => hourT <= "1110011";
		when others => hourT <= "1001111";--The shows ERROR
	end case;
end process;
end Behavioral;
--END