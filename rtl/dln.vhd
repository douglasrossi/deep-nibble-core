library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dln is
  port (
    i_CLK : in std_logic;
    i_RST : in std_logic;
    i_S : in std_logic;
    i_SETK : in std_logic;
    i_K : in std_logic_vector(3 downto 0);
    i_SETP : in std_logic;
    i_P : in std_logic_vector(3 downto 0);
    i_E : in std_logic_vector(4 downto 0);
    i_M : in std_logic_vector(9 downto 0);
    o_S : out std_logic;
    o_K : out std_logic_vector(2 downto 0);
    o_E : out std_logic_vector(4 downto 0);
    o_M : out std_logic_vector(9 downto 0)
  );
end dln;

architecture rtl of dln is

  signal w_K, w_P : std_logic_vector(2 downto 0) := (others => '0');
  signal w_SUB : unsigned(2 downto 0) := (others => '0');

  -- Register component   
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

  -- Register K   
  reg_K : reg
  generic map(
    p_WIDTH => 3
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_SETK,
    i_D => i_K(2 downto 0),
    o_Q => w_K
  );

  -- Register P 
  reg_P : reg
  generic map(
    p_WIDTH => 3
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_SETP,
    i_D => i_P(2 downto 0),
    o_Q => w_P
  );
  
  -- o_K and o_S output
  o_K <= w_K;
  o_S <= i_S;
  o_M <= i_M;

  -- i_K - i_P
  w_SUB <= unsigned(w_K) - unsigned(w_P);
  
  -- (i_K - i_P) + i_E
  o_E <= std_logic_vector(w_SUB + unsigned(i_E));

end architecture;