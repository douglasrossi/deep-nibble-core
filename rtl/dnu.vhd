library ieee;
use ieee.std_logic_1164.all;

package dnu_pkg is
  type t_VECT is array (natural range <>) of std_logic_vector;
  type t_MATR is array (natural range <>, natural range <>) of std_logic_vector;
end dnu_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dnu_pkg.all;

entity dnu is
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
end entity;

architecture rtl of dnu is

  signal w_P    : t_VECT ((2 ** p_LEVEL) - 1 downto 0) (p_WIDTH - 1 downto 0);
  signal w_Z    : std_logic_vector(31 downto 0);
  signal w_S0   : std_logic;
  signal w_E0   : std_logic_vector(4 downto 0);
  signal w_M0   : std_logic_vector(6 downto 0);
  signal w_S1   : std_logic;
  signal w_OVF1 : std_logic;
  signal w_UND1 : std_logic;
  signal w_E1   : std_logic_vector(7 downto 0);
  signal w_M1   : std_logic_vector(6 downto 0);
  signal w_UND2 : std_logic;
  signal w_S2   : std_logic;
  signal w_E2   : std_logic_vector(7 downto 0);
  signal w_M2   : std_logic_vector(6 downto 0);
  signal w_SB   : std_logic;
  signal w_EB   : std_logic_vector(7 downto 0);
  signal w_MB   : std_logic_vector(6 downto 0);

  signal w_S3   : std_logic;
  signal w_OVF3 : std_logic;
  signal w_UND3 : std_logic;
  signal w_E3   : std_logic_vector(7 downto 0);
  signal w_M3   : std_logic_vector(6 downto 0);
  signal w_S4   : std_logic;
  signal w_OVF4 : std_logic;
  signal w_E4   : std_logic_vector(7 downto 0);

  component mult
    port (
      i_CLK  : in std_logic;
      i_ENA  : in std_logic;
      i_ZRFX : in std_logic;
      i_A    : in std_logic_vector(3 downto 0);
      i_B    : in std_logic_vector(3 downto 0);
      o_P    : out std_logic_vector(15 downto 0)
    );
  end component;

  component acc
    generic (
      p_WIDTH : positive;
      p_LEVEL : positive
    );
    port (
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_ENA : in std_logic;
      i_P   : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (p_WIDTH - 1 downto 0);
      o_Z   : out std_logic_vector(31 downto 0)
    );
  end component;

  component i2fp
    port (
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_Z   : in std_logic_vector(31 downto 0);
      o_S   : out std_logic;
      o_E   : out std_logic_vector(4 downto 0);
      o_M   : out std_logic_vector(6 downto 0)
    );
  end component;

  component dnor
    port (
      i_CLK  : in std_logic;
      i_RST  : in std_logic;
      i_S0   : in std_logic;
      i_E0   : in std_logic_vector(4 downto 0);
      i_SETD : in std_logic;
      i_D    : in std_logic_vector(7 downto 0);
      i_M0   : in std_logic_vector(6 downto 0);
      o_S1   : out std_logic;
      o_OVF1 : out std_logic;
      o_UND1 : out std_logic;
      o_E1   : out std_logic_vector(7 downto 0);
      o_M1   : out std_logic_vector(6 downto 0)
    );
  end component;

  component relu
    port (
      i_CLK  : in std_logic;
      i_ENA  : in std_logic;
      i_RELU : in std_logic;
      i_S1   : in std_logic;
      i_E1   : in std_logic_vector(7 downto 0);
      i_M1   : in std_logic_vector(6 downto 0);
      o_UND2 : out std_logic;
      o_S2   : out std_logic;
      o_E2   : out std_logic_vector(7 downto 0);
      o_M2   : out std_logic_vector(6 downto 0)
    );
  end component;

  component norm
    port (
      i_CLK  : in std_logic;
      i_RST  : in std_logic;
      i_S2   : in std_logic;
      i_E2   : in std_logic_vector(7 downto 0);
      i_SETK : in std_logic;
      i_K    : in std_logic_vector(7 downto 0);
      i_M2   : in std_logic_vector(6 downto 0);
      o_S3   : out std_logic;
      o_OVF3 : out std_logic;
      o_UND3 : out std_logic;
      o_E3   : out std_logic_vector(7 downto 0);
      o_M3   : out std_logic_vector(6 downto 0)
    );
  end component;

  component sr
    port (
      i_S3   : in std_logic;
      i_E3   : in std_logic_vector(7 downto 0);
      i_M3   : in std_logic_vector(6 downto 0);
      i_RAND : in std_logic_vector(6 downto 0);
      o_S4   : out std_logic;
      o_OVF4 : out std_logic;
      o_E4   : out std_logic_vector(7 downto 0)
    );
  end component;

  component clip
    port (
      i_UND : in std_logic_vector(2 downto 0);
      i_OVF : in std_logic_vector(2 downto 0);
      i_S4  : in std_logic;
      i_E4  : in std_logic_vector(7 downto 0);
      i_RS  : in std_logic;
      o_YDN : out std_logic_vector(3 downto 0)
    );
  end component;

  component bf16
    port (
      i_S2 : in std_logic;
      i_E2 : in std_logic_vector(7 downto 0);
      i_M2 : in std_logic_vector(6 downto 0);
      o_SB : out std_logic;
      o_EB : out std_logic_vector(7 downto 0);
      o_MB : out std_logic_vector(6 downto 0)
    );
  end component;

  component ymax
    port (
      i_CLK  : in std_logic;
      i_CLR  : in std_logic;
      i_EB   : in std_logic_vector(7 downto 0);
      i_MB   : in std_logic_vector(6 downto 0);
      o_YMAX : out std_logic_vector(15 downto 0)
    );
  end component;

begin

  start :
  for i in 0 to 2 ** p_LEVEL - 1 generate
    mul_inst : mult
    port map(
      i_CLK  => i_CLK,
      i_ENA  => '1',
      i_ZRFX => i_ZRFX,
      i_A    => i_A(i),
      i_B    => i_B(i),
      o_P    => w_P(i)
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

  i2fp_inst : i2fp
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_Z   => w_Z,
    o_S   => w_S0,
    o_E   => w_E0,
    o_M   => w_M0
  );

  dnor_inst : dnor
  port map(
    i_CLK  => i_CLK,
    i_RST  => i_RST,
    i_S0   => w_S0,
    i_E0   => w_E0,
    i_SETD => i_SETD,
    i_D    => i_D,
    i_M0   => w_M0,
    o_S1   => w_S1,
    o_OVF1 => w_OVF1,
    o_UND1 => w_UND1,
    o_E1   => w_E1,
    o_M1   => w_M1
  );

  relu_inst : relu
  port map(
    i_CLK  => i_CLK,
    i_ENA  => '1',
    i_RELU => i_RELU,
    i_S1   => w_S1,
    i_E1   => w_E1,
    i_M1   => w_M1,
    o_UND2 => w_UND2,
    o_S2   => w_S2,
    o_E2   => w_E2,
    o_M2   => w_M2
  );

  norm_inst : norm
  port map(
    i_CLK  => i_CLK,
    i_RST  => i_RST,
    i_S2   => w_S2,
    i_E2   => w_E2,
    i_SETK => i_SETK,
    i_K    => i_K,
    i_M2   => w_M2,
    o_S3   => w_S3,
    o_OVF3 => w_OVF3,
    o_UND3 => w_UND3,
    o_E3   => w_E3,
    o_M3   => w_M3
  );

  sr_inst : sr
  port map(
    i_S3   => w_S3,
    i_E3   => w_E3,
    i_M3   => w_M3,
    i_RAND => i_RAND,
    o_S4   => w_S4,
    o_OVF4 => w_OVF4,
    o_E4   => w_E4
  );
  clip_inst : clip
  port map(
    i_UND => w_UND1 & w_UND2 & w_UND3,
    i_OVF => w_OVF1 & w_OVF3 & w_OVF4,
    i_S4  => w_S4,
    i_E4  => w_E4,
    i_RS  => i_RS,
    o_YDN => o_YDN
  );

  bf16_inst : bf16
  port map(
    i_S2 => w_S2,
    i_E2 => w_E2,
    i_M2 => w_M2,
    o_SB => w_SB,
    o_EB => w_EB,
    o_MB => w_MB
  );

  o_YBF <= w_SB & w_EB & w_MB;

  ymax_inst : ymax
  port map(
    i_CLK  => i_CLK,
    i_CLR  => i_RST,
    i_EB   => w_EB,
    i_MB   => w_MB,
    o_YMAX => o_YMAX
  );
end rtl;
