library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bf16 is
  port (
    i_S2 : in std_logic;
    i_E2 : in std_logic_vector(7 downto 0);
    i_M2 : in std_logic_vector(6 downto 0);
    o_SB : out std_logic;
    o_EB : out std_logic_vector(7 downto 0);
    o_MB : out std_logic_vector(6 downto 0)
  );
end bf16;

architecture rtl of bf16 is
  signal w_E : unsigned (7 downto 0);

begin

  w_E <= unsigned(i_E2) + "1111111";

  o_SB <= i_S2;
  o_EB <= std_logic_vector(w_E);
  o_MB <= i_M2;

end rtl;