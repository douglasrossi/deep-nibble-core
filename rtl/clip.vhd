library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clip is
  port (
    i_UND : in std_logic_vector(2 downto 0);
    i_OVF : in std_logic_vector(2 downto 0);
    i_S4  : in std_logic;
    i_E4  : in std_logic_vector(7 downto 0);
    i_RS  : in std_logic;
    o_YDN : out std_logic_vector(3 downto 0)
  );
end clip;

architecture rtl of clip is
  signal w_UND  : std_logic_vector(3 downto 0);
  signal w_OVF  : std_logic_vector(3 downto 0);
  signal w_NORM : std_logic_vector(2 downto 0);
begin
  w_UND(3 downto 1) <= i_UND;
  w_UND(0)          <= '1' when (signed(i_E4) <- 7) else
  '0';

  w_OVF(3 downto 1) <= i_OVF;
  w_OVF(0)          <= '1' when (signed(i_E4) > 0) else
  '0';

  w_NORM <= std_logic_vector(unsigned(not(i_E4(2 downto 0))) + 1);

  o_YDN <= i_RS & "111" when (unsigned(w_UND) > unsigned(w_OVF)) else
    i_S4 & "000" when (unsigned(w_OVF) /= 0) else
    i_S4 & w_NORM;

end rtl;