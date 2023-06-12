library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2fp is
  port (
    i_Z : in std_logic_vector(23 downto 0);
    o_S : out std_logic;
    o_E : out std_logic_vector(4 downto 0);
    o_M : out std_logic_vector(9 downto 0)
  );
end i2fp;

architecture rtl of i2fp is
  signal w_UNSIGN : std_logic_vector(22 downto 0);
  signal w_E      : std_logic_vector(4 downto 0);

  component uint
    port (
      i_DATA : in std_logic_vector(23 downto 0);
      o_DATA : out std_logic_vector(22 downto 0)
    );
  end component;

  component lod
    port (
      i_DATA : in std_logic_vector(22 downto 0);
      o_DATA : out std_logic_vector(4 downto 0)
    );
  end component;

  component muxm
    port (
      i_DATA : in std_logic_vector(23 downto 1);
      i_SEL  : in std_logic_vector(4 downto 0);
      o_DATA : out std_logic_vector(9 downto 0)
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
    i_DATA => w_UNSIGN,
    o_DATA => w_E
  );

  U0_muxm : muxm
  port map(
    i_DATA => w_UNSIGN,
    i_SEL  => w_E,
    o_DATA => o_M
  );

  o_S <= i_Z(23);
  o_E <= w_E;

end rtl;