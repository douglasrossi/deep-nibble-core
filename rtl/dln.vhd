library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dln is
  port (
    i_CLK : in std_logic;
    i_RST : in std_logic;
    i_S : in std_logic;
    i_GETK : in std_logic;
    i_SETK : in std_logic;
    i_K : in std_logic_vector(3 downto 0);
    i_SETN : in std_logic;
    i_P : in std_logic_vector(3 downto 0);
    i_E : in std_logic_vector(4 downto 0);
    i_M : in std_logic_vector(9 downto 0);
    o_M : out std_logic_vector(9 downto 0);
    o_E : out std_logic_vector(5 downto 0);
    o_S : out std_logic
  );
end dln;

architecture rtl of dln is

  signal w_K, w_P : std_logic_vector(3 downto 0) := (others => '0');
  signal w_SUB : signed(4 downto 0) := (others => '0');
  signal w_SUM : signed(5 downto 0) := (others => '0');
  signal w_greater : std_logic := '0';
  signal w_REG : std_logic_vector(5 downto 0) := (others => '0');
  signal w_SUBMUX : signed(5 downto 0) := (others => '0');

  -- register component   
  component reg
    generic (
      p_WIDTH : positive
    );
    port (
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_ENA : in std_logic;
      i_D : in std_logic_vector(p_WIDTH - 1 downto 0);
      o_Q : out std_logic_vector(p_WIDTH - 1 downto 0)
    );
  end component;

begin

  -- register K   
  reg_K : reg
  generic map(
    p_WIDTH => 4
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_SETK,
    i_D => i_K,
    o_Q => w_K
  );

  -- register P 
  reg_P : reg
  generic map(
    p_WIDTH => 4
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_SETN,
    i_D => i_P,
    o_Q => w_P
  );

  w_SUB <= ('0' & signed(w_K)) - ('0' & signed(w_P));

  w_SUM <= ('0' & w_SUB) + ('0' & signed(i_E));

  -- greater verification
  process (w_SUM, w_REG)
  begin
    if (w_SUM > signed(w_REG)) then
      w_greater <= '1';
    else
      w_greater <= '0';
    end if;
  end process;

  -- register K   
  reg_I : reg
  generic map(
    p_WIDTH => 6
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => w_greater,
    i_D => std_logic_vector(w_SUM),
    o_Q => w_REG
  );

  w_SUBMUX <= '0' & signed(w_K) - signed(w_REG);
  process (w_SUM, w_SUB, i_GETK)
  begin
    case i_GETK is
      when '0' => o_E <= std_logic_vector(w_SUM);
      when '1' => o_E <= std_logic_vector(w_SUBMUX);
      when others => o_E <= (others => '0');
    end case;
  end process;

  o_S <= i_S;
  o_M <= i_M;

end architecture;