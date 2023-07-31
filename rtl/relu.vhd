library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity relu is
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
end relu;

architecture rtl of relu is

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

  signal w_D0, w_D1 : std_logic_vector(15 downto 0);
  signal w_CLR      : std_logic;

begin

  w_CLR  <= i_RELU and i_S1;
  o_UND2 <= w_CLR;

  w_D0(15)          <= i_S1;
  w_D0(14 downto 7) <= i_E1;
  w_D0(6 downto 0)  <= i_M1;

  reg_inst : reg
  generic map(
    p_WIDTH => 16
  )
  port map(
    i_CLK => i_CLK,
    i_RST => w_CLR,
    i_ENA => i_ENA,
    i_D   => w_D0,
    o_Q   => w_D1
  );

  o_S2 <= w_D1(15);
  o_E2 <= w_D1(14 downto 7);
  o_M2 <= w_D1(6 downto 0);

end architecture;