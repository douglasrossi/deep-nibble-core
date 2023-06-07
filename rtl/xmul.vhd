library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xmul is
  port (
    i_A : in std_logic_vector(3 downto 0);
    i_B : in std_logic_vector(3 downto 0);
    o_P : out std_logic_vector(15 downto 0)
  );
end xmul;

architecture rtl of xmul is
  signal w_SIGN : std_logic;
  signal w_EXP  : std_logic_vector(3 downto 0);
  signal w_ADDR : std_logic_vector(4 downto 0);
  signal w_P    : std_logic_vector(14 downto 0);

  component romx
    port (
      i_ADDR : in std_logic_vector(4 downto 0);
      o_DATA : out std_logic_vector(14 downto 0)
    );
  end component;

begin
  w_SIGN <= i_A(3) xor i_B(3);
  w_EXP  <= std_logic_vector(unsigned(i_A) + unsigned(i_B));
  w_ADDR <= w_SIGN & w_EXP;

  romx_inst : romx
  port map(
    i_ADDR => w_ADDR,
    o_DATA => w_P
  );

  o_P <= w_SIGN & w_P;

end rtl;