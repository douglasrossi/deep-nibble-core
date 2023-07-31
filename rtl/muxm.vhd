library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity muxm is
  port (
    i_DATA : in std_logic_vector(30 downto 0);
    i_SEL  : in std_logic_vector(4 downto 0);
    o_DATA : out std_logic_vector(6 downto 0)
  );
end muxm;

architecture rtl of muxm is
  signal w_SEL : natural range 0 to 30;
  signal w_M   : std_logic_vector(37 downto 0);

begin
  w_SEL  <= to_integer(unsigned(i_SEL));
  w_M    <= i_DATA & "1000000";
  o_DATA <= w_M(w_SEL + 6 downto w_SEL);

end rtl;