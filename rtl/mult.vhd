library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult is
  port (
    i_CLK  : in std_logic;
    i_ENA  : in std_logic;
    i_ZRFX : in std_logic;
    i_A    : in std_logic_vector(3 downto 0);
    i_B    : in std_logic_vector(3 downto 0);
    o_P    : out std_logic_vector(15 downto 0)
  );
end mult;

architecture rtl of mult is
  signal w_RST  : std_logic;
  signal w_SIGN : std_logic;
  signal w_EXP  : std_logic_vector(3 downto 0);
  signal w_ADDR : std_logic_vector(4 downto 0);
  signal w_P    : std_logic_vector(14 downto 0);
  signal r_P    : std_logic_vector(14 downto 0);

  component romx
    port (
      i_ADDR : in std_logic_vector(4 downto 0);
      o_DATA : out std_logic_vector(14 downto 0)
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
  w_SIGN <= i_A(3) xor i_B(3);
  w_EXP  <= std_logic_vector(unsigned(i_A) + unsigned(i_B));
  w_ADDR <= w_SIGN & w_EXP;
  w_RST  <= i_ZRFX and i_B(2) and i_B(1) and i_B(0);

  romx_inst : romx
  port map(
    i_ADDR => w_ADDR,
    o_DATA => w_P
  );

  reg_inst : reg
  generic map(
    p_WIDTH => 16
  )
  port map(
    i_CLK => i_CLK,
    i_RST => w_RST,
    i_ENA => i_ENA,
    i_D   => w_SIGN & w_P,
    o_Q   => o_P
  );

end rtl;