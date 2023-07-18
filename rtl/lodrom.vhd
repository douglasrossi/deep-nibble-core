library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lodrom is
  port
  (
    i_DATA : in std_logic_vector(23 downto 1);
    o_DATA : out std_logic_vector(4 downto 0)
  );
end lodrom;

architecture rtl of lodrom is
  signal w_DATA : std_logic_vector(4 downto 0);
begin

  --   o_DATA <= "10111" when i_DATA = "1----------------------" else
  --     "10110" when i_DATA = "01---------------------"  else
  --     "10101" when i_DATA = "001--------------------"  else
  --     "10100" when i_DATA = "0001-------------------"  else
  --     "10011" when i_DATA = "00001------------------"  else
  --     "10010" when i_DATA = "000001-----------------"  else
  --     "10001" when i_DATA = "0000001----------------"  else
  --     "10000" when i_DATA = "00000001---------------"  else
  --     "01111" when i_DATA = "000000001--------------"  else
  --     "01110" when i_DATA = "0000000001-------------"  else
  --     "01101" when i_DATA = "00000000001------------"  else
  --     "01100" when i_DATA = "000000000001-----------"  else
  --     "01011" when i_DATA = "0000000000001----------"  else
  --     "01010" when i_DATA = "00000000000001---------"  else
  --     "01001" when i_DATA = "000000000000001--------"  else
  --     "01000" when i_DATA = "0000000000000001-------"  else
  --     "00111" when i_DATA = "00000000000000001------"  else
  --     "00110" when i_DATA = "000000000000000001-----"  else
  --     "00101" when i_DATA = "0000000000000000001----"  else
  --     "00100" when i_DATA = "00000000000000000001---"  else
  --     "00011" when i_DATA = "000000000000000000001--"  else
  --     "00010" when i_DATA = "0000000000000000000001-" else
  --     "00001" when i_DATA = "00000000000000000000001" else
  --     "00000";

  w_DATA(4) <= i_DATA(23) or i_DATA(22) or i_DATA(21) or i_DATA(20) or i_DATA(19) or i_DATA(18) or i_DATA(17) or i_DATA(16);

  w_DATA(3) <= (i_DATA(15) or i_DATA(14) or i_DATA(13) or i_DATA(12) or i_DATA(11) or i_DATA(10) or i_DATA(9) or i_DATA(8)) and not w_DATA(4);

  w_DATA(2) <= i_DATA(23) or 
  (not i_DATA(23) and i_DATA(22)) or 
  (not i_DATA(23) and not i_DATA(22) and i_DATA(21)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and i_DATA(20)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and i_DATA(15)) or
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and i_DATA(14)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and i_DATA(13)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and i_DATA(12)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and i_DATA(7)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and not i_DATA(7) and i_DATA(6)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and not i_DATA(7) and not i_DATA(6) and i_DATA(5)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and not i_DATA(7) and not i_DATA(6) and not i_DATA(5) and i_DATA(4));

  w_DATA(1) <= i_DATA(23) or 
  (not i_DATA(23) and i_DATA(22)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and i_DATA(19)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and i_DATA(18)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and i_DATA(15)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and i_DATA(14)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and i_DATA(11)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and i_DATA(10)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and i_DATA(7)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and not i_DATA(7) and i_DATA(6)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and not i_DATA(7) and not i_DATA(6) and not i_DATA(5) and not i_DATA(4) and i_DATA(3)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and not i_DATA(7) and not i_DATA(6) and not i_DATA(5) and not i_DATA(4) and not i_DATA(3) and i_DATA(2));

  w_DATA(0) <= i_DATA(23) or 
  (not i_DATA(23) and not i_DATA(22) and i_DATA(21)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and i_DATA(19)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and i_DATA(17)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and i_DATA(15)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and i_DATA(13)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and i_DATA(11)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and i_DATA(9)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and i_DATA(7)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and not i_DATA(7) and not i_DATA(6) and i_DATA(5)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and not i_DATA(7) and not i_DATA(6) and not i_DATA(5) and not i_DATA(4) and i_DATA(3)) or 
  (not i_DATA(23) and not i_DATA(22) and not i_DATA(21) and not i_DATA(20) and not i_DATA(19) and not i_DATA(18) and not i_DATA(17) and not i_DATA(16) and not i_DATA(15) and not i_DATA(14) and not i_DATA(13) and not i_DATA(12) and not i_DATA(11) and not i_DATA(10) and not i_DATA(9) and not i_DATA(8) and not i_DATA(7) and not i_DATA(6) and not i_DATA(5) and not i_DATA(4) and not i_DATA(3) and not i_DATA(2) and i_DATA(1));

  o_DATA <= w_DATA;

end rtl;