library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity norm is
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
    o_M3   : out std_logic_vector(6 downto 0));
end norm;

architecture rtl of norm is

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
  signal w_SUB : unsigned(7 downto 0);

begin

  o_M3 <= i_M2;
  o_S3 <= i_S2;

  reg_inst : reg
  generic map(
    p_WIDTH => 8
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_SETK,
    i_D   => i_K,
    o_Q   => w_D
  );

  w_SUB <= (unsigned(i_E2)) - unsigned(w_D);
  o_E3  <= std_logic_vector(w_SUB);

  o_OVF3 <= w_D(7) and w_SUB(7);
  o_UND3 <= (not w_D(7)) and w_SUB(7);

end rtl;