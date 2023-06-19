library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.madder_pkg.all;

entity dnu is
  generic (
    p_WIDTH : positive := 16;
    p_LEVEL : positive := 4
  );
  port (
    i_CLK : in std_logic;
    i_RST : in std_logic;
    -- i_CTRL inputs
    i_SETK : in std_logic;
    i_K    : in std_logic_vector(3 downto 0);
    i_SETP : in std_logic;
    i_P    : in std_logic_vector(3 downto 0);
    i_RECT : in std_logic;
    i_GETK : in std_logic;
    i_RAND : in std_logic_vector(9 downto 0);
    o_ZERO : out std_logic;
    o_YMAX : out std_logic;
    -- DNU input
    i_A : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (3 downto 0);
    i_B : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (3 downto 0);

    -- DNU output
    o_YDN : out std_logic_vector(3 downto 0);
    o_YFP : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of dnu is

  signal w_P : t_VECT ((2 ** p_LEVEL) - 1 downto 0) (p_WIDTH - 1 downto 0);
  signal w_Z : std_logic_vector(23 downto 0);

  component xmul
    port (
      i_A : in std_logic_vector(3 downto 0);
      i_B : in std_logic_vector(3 downto 0);
      o_P : out std_logic_vector(15 downto 0)
    );
  end component;

  component acc
    generic (
      p_WIDTH : positive := 16;
      p_LEVEL : positive := 4
    );
    port (
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_ENA : in std_logic;
      i_P   : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (p_WIDTH - 1 downto 0);
      o_Z   : out std_logic_vector(23 downto 0)
    );
  end component;

  component nslq
    port (
      i_CLK  : in std_logic;
      i_RST  : in std_logic;
      i_Z    : in std_logic_vector(23 downto 0);
      i_SETK : in std_logic;
      i_K    : in std_logic_vector(3 downto 0);
      i_SETP : in std_logic;
      i_P    : in std_logic_vector(3 downto 0);
      i_RECT : in std_logic;
      i_GETK : in std_logic;
      i_RAND : in std_logic_vector(9 downto 0);
      o_YDN  : out std_logic_vector(3 downto 0);
      o_YFP  : out std_logic_vector(15 downto 0);
      o_ZERO : out std_logic;
      o_YMAX : out std_logic
    );
  end component;

begin

  start :
  for i in 0 to 2 ** p_LEVEL - 1 generate
    xmul_inst : xmul
    port map(
      i_A => i_A(i),
      i_B => i_B(i),
      o_P => w_P(i)
    );
  end generate;

  acc_inst : acc
  generic map(
    p_WIDTH => p_WIDTH,
    p_LEVEL => p_LEVEL
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => '1',
    i_P   => w_P,
    o_Z   => w_Z
  );

  nslq_inst : nslq
  port map(
    i_CLK  => i_CLK,
    i_RST  => i_RST,
    i_Z    => w_Z,
    i_SETK => i_SETK,
    i_K    => i_K,
    i_SETP => i_SETP,
    i_P    => i_P,
    i_RECT => i_RECT,
    i_GETK => i_GETK,
    i_RAND => i_RAND,
    o_YDN  => o_YDN,
    o_YFP  => o_YFP,
    o_ZERO => o_ZERO,
    o_YMAX => o_YMAX
  );

end rtl;