library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2fp is
  port (
    i_CLK : in std_logic;
    i_RST : in std_logic;
    i_Z   : in std_logic_vector(31 downto 0);
    o_S   : out std_logic;
    o_E   : out std_logic_vector(4 downto 0);
    o_M   : out std_logic_vector(6 downto 0)
  );
end i2fp;

architecture rtl of i2fp is
  signal w_UNSIGN : std_logic_vector(30 downto 0);
  signal w_E      : std_logic_vector(4 downto 0);
  signal w_M      : std_logic_vector(6 downto 0);
  signal w_SEM    : std_logic_vector(12 downto 0);
  signal w_U2L    : std_logic_vector(31 downto 0);

  component uint
    port (
      i_DATA : in std_logic_vector(31 downto 0);
      o_DATA : out std_logic_vector(30 downto 0)
    );
  end component;

  component lod
    port (
      i_DATA : in std_logic_vector(26 downto 1);
      o_DATA : out std_logic_vector(4 downto 0)
    );
  end component;

  component muxm
    port (
      i_DATA : in std_logic_vector(30 downto 0);
      i_SEL  : in std_logic_vector(4 downto 0);
      o_DATA : out std_logic_vector(6 downto 0)
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

  U0_unsign : uint
  port map(
    i_DATA => i_Z,
    o_DATA => w_UNSIGN
  );

  U0_leading : lod
  port map(
    i_DATA => w_U2L(26 downto 1),
    o_DATA => w_E
  );

  U0_muxm : muxm
  port map(
    i_DATA => w_U2L(30 downto 0),
    i_SEL  => w_E,
    o_DATA => w_M
  );

  reg_inst_pre : reg
  generic map(
    p_WIDTH => 32
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => '1',
    i_D   => i_Z(31) & w_UNSIGN,
    o_Q   => w_U2L
  );

  reg_inst_pos : reg
  generic map(
    p_WIDTH => 13
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => '1',
    i_D   => w_U2L(31) & w_E & w_M,
    o_Q   => w_SEM
  );

  o_S <= w_SEM(12);
  o_E <= w_SEM(11 downto 7);
  o_M <= w_SEM(6 downto 0);

end rtl;