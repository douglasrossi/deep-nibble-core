library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nslq is
  port (
    i_CLK : in std_logic;
    i_RST : in std_logic;
    -- NORM input
    i_S2   : in std_logic;
    i_E2   : in std_logic_vector(4 downto 0);
    i_SETK : in std_logic;
    i_K    : in std_logic_vector(7 downto 0);
    i_M2   : in std_logic_vector(6 downto 0);
    -- SR inputs
    i_RAND : in std_logic_vector(6 downto 0);
    -- NSLQ outputs
    o_YDN  : out std_logic_vector(3 downto 0);
    o_YFP  : out std_logic_vector(15 downto 0);
    o_ZERO : out std_logic;
    o_YMAX : out std_logic
  );
end entity;

architecture rtl of nslq is

  signal w_S3   : std_logic;
  signal w_OVF3 : std_logic;
  signal w_UND3 : std_logic;
  signal w_E3   : std_logic_vector(7 downto 0);
  signal w_M3   : std_logic_vector(6 downto 0);
  signal w_S4   : std_logic;
  signal w_OVF4 : std_logic;
  signal w_E4   : std_logic_vector(7 downto 0);

  component norm
    port (
      i_CLK  : in std_logic;
      i_RST  : in std_logic;
      i_S2   : in std_logic;
      i_E2   : in std_logic_vector(4 downto 0);
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

begin

  norm_inst : norm
  port map(
    i_CLK  => i_CLK,
    i_RST  => i_RST,
    i_S2   => i_S2,
    i_E2   => i_E2,
    i_SETK => i_SETK,
    i_K    => i_K,
    i_M2   => i_M2,
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
    i_UND => i_UND,
    i_OVF => i_OVF,
    i_S4  => i_S4,
    i_E4  => i_E4,
    i_RS  => i_RS,
    o_YDN => o_YDN
  );
  o_YFP <= (w_S1 & w_E1 & w_M1);

end architecture;