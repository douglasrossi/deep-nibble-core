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

  signal w_MAXINDEX : natural range 0 to 31;
  signal w_UNSIGN   : std_logic_vector(22 downto 0);
  signal w_E        : std_logic_vector(4 downto 0);
  signal w_M        : std_logic_vector(32 downto 0);

  component unsign
    port (
      i_DATA : in std_logic_vector(23 downto 0);
      o_DATA : out std_logic_vector(22 downto 0)
    );
  end component;

  component leading
    port (
      i_DATA : in std_logic_vector(22 downto 0);
      o_DATA : out std_logic_vector(4 downto 0)
    );
  end component;
begin

  U0_unsign : unsign
  port map(
    i_DATA => i_Z,
    o_DATA => w_UNSIGN
  );

  U0_leading : leading
  port map(
    i_DATA => w_UNSIGN,
    o_DATA => w_E
  );

  w_M        <= w_UNSIGN & "1000000000";
  w_MAXINDEX <= to_integer(unsigned(w_E));
  o_S        <= i_Z(23);
  o_E        <= w_E;
  o_M        <= w_M(w_MAXINDEX + 9 downto w_MAXINDEX);

end rtl;