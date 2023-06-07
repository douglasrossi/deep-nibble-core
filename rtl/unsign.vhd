library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unsign is
  port (
    i_DATA : in std_logic_vector(23 downto 0);
    o_DATA : out std_logic_vector(22 downto 0)
  );
end unsign;

architecture rtl of unsign is
  signal w_NDATA : std_logic_vector(22 downto 0);

begin

  w_NDATA <= not(i_DATA(22 downto 0));
  o_DATA  <= i_DATA(22 downto 0) when i_DATA(23) = '0' else
    std_logic_vector(unsigned(w_NDATA) + 1);

end rtl;