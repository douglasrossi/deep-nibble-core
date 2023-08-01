library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dnu_pkg.all;

entity ingen is
  generic (
    p_WIDTH : positive := 4;
    p_LEVEL : positive := 1
  );
  port (
    i_CLK : in std_logic;
    i_RST : in std_logic;
    -- i_CTRL inputs
    i_SETD : in std_logic;
    i_D    : in std_logic_vector(7 downto 0);
    i_RELU : in std_logic;
    i_SETK : in std_logic;
    i_K    : in std_logic_vector(7 downto 0);
    i_RAND : in std_logic_vector(6 downto 0);
    i_RS   : in std_logic;
    i_ZRFX : in std_logic;
    -- INGEN input
    i_SEL   : in std_logic_vector(p_LEVEL - 1 downto 0);
    i_A_GEN : in std_logic_vector(3 downto 0);
    i_B_GEN : in std_logic_vector(3 downto 0);
    -- DNU output
    o_YDN  : out std_logic_vector(3 downto 0);
    o_YBF  : out std_logic_vector(15 downto 0);
    o_YMAX : out std_logic_vector(15 downto 0)
  );
end ingen;

architecture rtl of ingen is

  signal w_A : t_VECT((2 ** p_LEVEL) - 1 downto 0) (p_WIDTH - 1 downto 0);
  signal w_B : t_VECT((2 ** p_LEVEL) - 1 downto 0) (p_WIDTH - 1 downto 0);

  component dnu is
    generic (
      p_WIDTH : positive := 16;
      p_LEVEL : positive := 4
    );
    port (
      i_CLK : in std_logic;
      i_RST : in std_logic;
      -- i_CTRL inputs
      i_SETD : in std_logic;
      i_D    : in std_logic_vector(7 downto 0);
      i_RELU : in std_logic;
      i_SETK : in std_logic;
      i_K    : in std_logic_vector(7 downto 0);
      i_RAND : in std_logic_vector(6 downto 0);
      i_RS   : in std_logic;
      i_ZRFX : in std_logic;
      -- DNU input
      i_A : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (3 downto 0);
      i_B : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (3 downto 0);

      -- DNU output
      o_YDN  : out std_logic_vector(3 downto 0);
      o_YBF  : out std_logic_vector(15 downto 0);
      o_YMAX : out std_logic_vector(15 downto 0)
    );
  end component;

begin

  generate_inputs :
  for i in 0 to 2 ** p_LEVEL - 1 generate
    w_A (i) <= i_A_GEN when to_integer(unsigned(i_SEL)) = i else
    (others => '0');
    w_B (i) <= i_B_GEN when to_integer(unsigned(i_SEL)) = i else
    (others => '0');
  end generate;

  dnu_inst : dnu
  generic map(
    p_WIDTH => 16,
    p_LEVEL => p_LEVEL
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    -- i_CTRL inputs
    i_SETD => i_SETD,
    i_D    => i_D,
    i_RELU => i_RELU,
    i_SETK => i_SETK,
    i_K    => i_K,
    i_RAND => i_RAND,
    i_RS   => i_RS,
    i_ZRFX => i_ZRFX,

    -- DNU input
    i_A => w_A,
    i_B => w_B,

    -- DNU output
    o_YDN  => o_YDN,
    o_YBF  => o_YBF,
    o_YMAX => o_YMAX
  );
end rtl;