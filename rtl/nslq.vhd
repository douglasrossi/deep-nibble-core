library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nslq is
  port (
    i_CLK : in std_logic;
    i_RST : in std_logic;
    -- I2FP input
    i_Z : in std_logic_vector(23 downto 0);
    -- DLN inputs
    i_SETK : in std_logic;
    i_K    : in std_logic_vector(3 downto 0);
    i_SETP : in std_logic;
    i_P    : in std_logic_vector(3 downto 0);
    -- SLQ inputs
    i_RECT : in std_logic;
    i_GETK : in std_logic;
    i_RAND : in std_logic_vector(9 downto 0);
    -- NSLQ outputs
    o_YDN  : out std_logic_vector(3 downto 0);
    o_YFP  : out std_logic_vector(15 downto 0);
    o_ZERO : out std_logic;
    o_YMAX : out std_logic
  );
end entity;

architecture rtl of nslq is

  component i2fp
    port (
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_ENA : in std_logic;
      i_Z   : in std_logic_vector(23 downto 0);
      o_S   : out std_logic;
      o_E   : out std_logic_vector(4 downto 0);
      o_M   : out std_logic_vector(9 downto 0)
    );
  end component;

  component dln
    port (
      i_CLK  : in std_logic;
      i_RST  : in std_logic;
      i_S    : in std_logic;
      i_SETK : in std_logic;
      i_K    : in std_logic_vector(3 downto 0);
      i_SETP : in std_logic;
      i_P    : in std_logic_vector(3 downto 0);
      i_E    : in std_logic_vector(4 downto 0);
      i_M    : in std_logic_vector(9 downto 0);
      o_S    : out std_logic;
      o_K    : out std_logic_vector(2 downto 0);
      o_E    : out std_logic_vector(4 downto 0);
      o_M    : out std_logic_vector(9 downto 0)
    );
  end component;

  component slq
    port (
      i_CLK  : in std_logic;
      i_RST  : in std_logic;
      i_RECT : in std_logic;
      i_S    : in std_logic;
      i_GETK : in std_logic;
      i_E    : in std_logic_vector(4 downto 0);
      i_M    : in std_logic_vector(9 downto 0);
      i_RAND : in std_logic_vector(9 downto 0);
      i_K    : in std_logic_vector(2 downto 0);
      o_YDN  : out std_logic_vector(3 downto 0);
      o_ZERO : out std_logic;
      o_YMAX : out std_logic
    );
  end component;

  signal w_S0 : std_logic;
  signal w_S1 : std_logic;
  signal w_E0 : std_logic_vector(4 downto 0);
  signal w_E1 : std_logic_vector(4 downto 0);
  signal w_M0 : std_logic_vector(9 downto 0);
  signal w_M1 : std_logic_vector(9 downto 0);
  signal w_K  : std_logic_vector(2 downto 0);

begin
  i2fp_inst : i2fp
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => '1',
    i_Z   => i_Z,
    o_S   => w_S0,
    o_E   => w_E0,
    o_M   => w_M0
  );

  dln_inst : dln
  port map(
    i_CLK  => i_CLK,
    i_RST  => i_RST,
    i_S    => w_S0,
    i_SETK => i_SETK,
    i_K    => i_K,
    i_SETP => i_SETP,
    i_P    => i_P,
    i_E    => w_E0,
    i_M    => w_M0,
    o_S    => w_S1,
    o_K    => w_K,
    o_E    => w_E1,
    o_M    => w_M1
  );

  slq_inst : slq
  port map(
    i_CLK  => i_CLK,
    i_RST  => i_RST,
    i_RECT => i_RECT,
    i_S    => w_S1,
    i_GETK => i_GETK,
    i_E    => w_E1,
    i_M    => w_M1,
    i_RAND => i_RAND,
    i_K    => w_K,
    o_YDN  => o_YDN,
    o_ZERO => o_ZERO,
    o_YMAX => o_YMAX
  );

  o_YFP <= (w_S1 & w_E1 & w_M1);

end architecture;