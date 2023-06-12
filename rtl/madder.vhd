library ieee;
use ieee.std_logic_1164.all;

package madder_pkg is
  type t_VECT is array (natural range <>) of std_logic_vector;
end madder_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.madder_pkg.all;

entity madder is
  generic (
    p_WIDTH : positive := 16;
    p_COL   : positive := 16
  );
  port (
    i_P : in t_VECT (p_COL - 1 downto 0) (p_WIDTH - 1 downto 0);
    o_S : out t_VECT (p_COL/2 - 1 downto 0)(p_WIDTH downto 0)
  );
end madder;

architecture rtl of madder is

  component sadder
    generic (
      p_WIDTH : positive
    );
    port (
      i_A : in std_logic_vector(p_WIDTH - 1 downto 0);
      i_B : in std_logic_vector(p_WIDTH - 1 downto 0);
      o_S : out std_logic_vector(p_WIDTH downto 0)
    );
  end component;

begin

  col :
  for i in 0 to p_COL/2 - 1 generate
    sadder_inst : sadder
    generic map(
      p_WIDTH => p_WIDTH
    )
    port map(
      i_A => i_P(i),
      i_B => i_P(i + (p_COL/2)),
      o_S => o_S(i)
    );

  end generate;

end rtl;