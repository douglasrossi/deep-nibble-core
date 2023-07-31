library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ymax is
  port (
    i_CLK  : in std_logic;
    i_CLR  : in std_logic;
    i_EB   : in std_logic_vector(7 downto 0);
    i_MB   : in std_logic_vector(6 downto 0);
    o_YMAX : out std_logic_vector(15 downto 0)
  );
end ymax;

architecture rtl of ymax is
  signal w_B   : std_logic_vector(14 downto 0);
  signal w_Q   : std_logic_vector(14 downto 0);
  signal w_ENA : std_logic;

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

  w_B   <= i_EB & i_MB;
  w_ENA <= '1' when (unsigned(w_B) > unsigned(w_Q)) else
    '0';

  reg_inst : reg
  generic map(
    p_WIDTH => 15
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_CLR,
    i_ENA => w_ENA,
    i_D   => w_B,
    o_Q   => w_Q
  );

  o_YMAX <= '0' & w_Q;

end rtl;