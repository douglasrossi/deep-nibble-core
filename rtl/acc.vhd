library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dnu_pkg.all;

entity acc is
  generic (
    p_WIDTH : positive := 16;
    p_LEVEL : positive := 4
  );
  port (
    i_CLK : in std_logic;
    i_RST : in std_logic;
    i_ENA : in std_logic;
    i_P   : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (p_WIDTH - 1 downto 0);
    o_Z   : out std_logic_vector(31 downto 0)
  );
end acc;

architecture rtl of acc is

  signal w_S : std_logic_vector(p_WIDTH + p_LEVEL - 1 downto 0);
  signal w_D : std_logic_vector(p_WIDTH + p_LEVEL - 1 downto 0);
  signal w_Q : std_logic_vector(p_WIDTH + p_LEVEL - 1 downto 0);

  component madder
    generic (
      p_WIDTH : positive := 16;
      p_LEVEL : positive := 4
    );
    port (
      i_P : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (p_WIDTH - 1 downto 0);
      o_S : out std_logic_vector(p_WIDTH + p_LEVEL - 1 downto 0)
    );
  end component;

  component reg
    generic (
      p_WIDTH : positive
    );
    port (
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_ENA : in std_logic;
      i_D   : in std_logic_vector(p_WIDTH - 1 downto 0);
      o_Q   : out std_logic_vector(p_WIDTH - 1 downto 0)
    );
  end component;
begin

  madder_inst : madder
  generic map(
    p_WIDTH => p_WIDTH,
    p_LEVEL => p_LEVEL
  )
  port map(
    i_P => i_P,
    o_S => w_S
  );

  reg_inst : reg
  generic map(
    p_WIDTH => p_WIDTH + p_LEVEL
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_ENA,
    i_D   => w_D,
    o_Q   => w_Q
  );

  w_D <= std_logic_vector(signed(w_S) + signed(w_Q));

  o_Z(p_WIDTH + p_LEVEL - 1 downto 0) <= w_Q;
  o_Z(31 downto p_WIDTH + p_LEVEL)    <= (others => w_Q(p_WIDTH + p_LEVEL - 1));

end rtl;