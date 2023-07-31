library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uint is
  port (
    i_DATA : in std_logic_vector(31 downto 0);
    o_DATA : out std_logic_vector(30 downto 0)
  );
end uint;

architecture rtl of uint is
  signal w_NDATA : std_logic_vector(30 downto 0);

begin

  w_NDATA <= not(i_DATA(30 downto 0));
  o_DATA  <= i_DATA(30 downto 0) when i_DATA(31) = '0' else
    std_logic_vector(unsigned(w_NDATA) + 1);

end rtl;