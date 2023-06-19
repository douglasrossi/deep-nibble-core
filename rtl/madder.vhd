library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dnu_pkg.all;

entity madder is
  generic (
    p_WIDTH : positive := 16;
    p_LEVEL : positive := 4
  );
  port (
    i_P : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (p_WIDTH - 1 downto 0);
    o_S : out std_logic_vector(p_WIDTH + p_LEVEL - 1 downto 0)
  );
end madder;

architecture rtl of madder is

  signal w_S : t_MATR((2 ** p_LEVEL) - 1 downto 0, p_LEVEL downto 0) (p_WIDTH + p_LEVEL - 1 downto 0);

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

  row :
  for j in p_LEVEL downto 1 generate
    col :
    for i in 0 to (((2 ** j)/2) - 1) generate
      sadder_inst : sadder
      generic map(
        p_WIDTH => p_WIDTH + p_LEVEL - j
      )
      port map(
        i_A(p_WIDTH + p_LEVEL - j - 1 downto 0) => w_S(2 * i, j)(p_WIDTH + p_LEVEL - j - 1 downto 0),
        i_B(p_WIDTH + p_LEVEL - j - 1 downto 0) => w_S(2 * i + 1, j)(p_WIDTH + p_LEVEL - j - 1 downto 0),
        o_S(p_WIDTH + p_LEVEL - j downto 0)     => w_S(i, j - 1)(p_WIDTH + p_LEVEL - j downto 0)
      );

    end generate;
  end generate;

  start :
  for i in 0 to 2 ** p_LEVEL - 1 generate
    w_S(i, p_LEVEL)(p_WIDTH - 1 downto 0) <= i_P(i);
  end generate;

  o_S <= w_S(0, 0);

end rtl;