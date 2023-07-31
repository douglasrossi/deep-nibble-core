library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sr is
  port (
    i_S3   : in std_logic;
    i_E3   : in std_logic_vector(7 downto 0);
    i_M3   : in std_logic_vector(6 downto 0);
    i_RAND : in std_logic_vector(6 downto 0);
    o_S4   : out std_logic;
    o_OVF4 : out std_logic;
    o_E4   : out std_logic_vector(7 downto 0)
  );
end sr;

architecture rtl of sr is

  signal w_GREATER : std_logic;
  signal w_SUM     : unsigned(8 downto 0);

begin

  o_S4 <= i_S3;

  process (i_M3, i_RAND)
  begin
    if (i_M3 > i_RAND) then
      w_GREATER <= '1';
    else
      w_GREATER <= '0';
    end if;
  end process;

  w_SUM <= ('0' & unsigned(i_E3)) + ("00000000" & w_GREATER);

  o_E4 <= std_logic_vector(w_SUM(7 downto 0));

  o_OVF4 <= w_SUM(8);

end architecture;