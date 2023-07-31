library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dnor is
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
    o_M1   : out std_logic_vector(6 downto 0));
end dnor;

architecture rtl of dnor is

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

  signal w_D   : std_logic_vector(7 downto 0);
  signal w_SUM : unsigned(8 downto 0);

begin

  o_M1 <= i_M0;
  o_S1 <= i_S0;

  reg_inst : reg
  generic map(
    p_WIDTH => 8
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_SETD,
    i_D   => i_D,
    o_Q   => w_D
  );

  w_SUM <= ('0' & unsigned(w_D)) + ("0000" & unsigned(i_E0));
  o_E1  <= std_logic_vector(w_SUM(7 downto 0));

  o_OVF1 <= (not w_D(7)) and w_SUM(8);
  o_UND1 <= w_D(7) and w_SUM(8);

end rtl;