library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sadder is
  generic (
    p_WIDTH : positive := 16
  );
  port (
    i_A : in std_logic_vector(p_WIDTH - 1 downto 0);
    i_B : in std_logic_vector(p_WIDTH - 1 downto 0);
    o_S : out std_logic_vector(p_WIDTH downto 0)
  );
end sadder;

architecture rtl of sadder is
  signal w_S : signed (p_WIDTH downto 0);

begin
  w_S <= (signed(i_A(p_WIDTH - 1) & i_A) + signed(i_B));
  o_S <= std_logic_vector(w_S);
end rtl;