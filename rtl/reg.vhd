library ieee;
use ieee.std_logic_1164.all;

entity reg is
  generic (
    p_WIDTH : positive := 32
  );
  port (
    i_CLK : in std_logic;
    i_RST : in std_logic;
    i_ENA : in std_logic;
    i_D   : in std_logic_vector(p_WIDTH - 1 downto 0);
    o_Q   : out std_logic_vector(p_WIDTH - 1 downto 0)
  );
end reg;

architecture rtl of reg is

begin

  process (i_CLK, i_RST)
  begin
    if (i_RST = '0') then
      o_Q <= (others => '0');
    elsif (rising_edge(i_CLK)) then
      if (i_ENA = '1') then
        o_Q <= i_D;
      end if;
    end if;
  end process;

end rtl;