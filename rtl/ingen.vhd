library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dnu_pkg.all;

entity ingen is
  generic (
    p_WIDTH : positive := 4;
    p_LEVEL : positive := 4
  );
  port (
    i_CLK : in std_logic;
    i_RST : in std_logic;
    -- i_CTRL inputs
    i_SETK : in std_logic;
    -- i_K    : in std_logic_vector(3 downto 0);
    i_SETP : in std_logic;
    -- i_P    : in std_logic_vector(3 downto 0);
    i_RECT : in std_logic;
    i_GETK : in std_logic;
    -- i_RAND : in std_logic_vector(9 downto 0);
    o_ZERO : out std_logic;
    o_YMAX : out std_logic;
    -- DNU output
    o_YDN : out std_logic_vector(3 downto 0);
    o_YFP : out std_logic_vector(15 downto 0);
    -- Input gen
    i_A : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (3 downto 0);
    i_B : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (3 downto 0)
  );
end ingen;

architecture rtl of ingen is

  signal w_A : t_VECT((2 ** p_LEVEL) - 1 downto 0) (p_WIDTH - 1 downto 0);
  signal w_B : t_VECT((2 ** p_LEVEL) - 1 downto 0) (p_WIDTH - 1 downto 0);

  component dnu is
    generic (
      p_WIDTH : positive := 16;
      p_LEVEL : positive := 4
    );
    port (
      i_CLK : in std_logic;
      i_RST : in std_logic;
      -- i_CTRL inputs
      i_SETK : in std_logic;
      i_K    : in std_logic_vector(3 downto 0);
      i_SETP : in std_logic;
      i_P    : in std_logic_vector(3 downto 0);
      i_RECT : in std_logic;
      i_GETK : in std_logic;
      i_RAND : in std_logic_vector(9 downto 0);
      o_ZERO : out std_logic;
      o_YMAX : out std_logic;
      -- DNU input
      i_A : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (3 downto 0);
      i_B : in t_VECT ((2 ** p_LEVEL) - 1 downto 0) (3 downto 0);

      -- DNU output
      o_YDN : out std_logic_vector(3 downto 0);
      o_YFP : out std_logic_vector(15 downto 0)
    );
  end component;

begin

  -- generate_inputs :
  -- for i in 0 to 2 ** p_LEVEL - 1 generate
  --   w_A (i) <= i_DATA(i);
  --   w_B (i) <= i_DATA(2 ** p_LEVEL - 1 - i);
  -- end generate;

  dnu_inst : dnu
  generic map(
    p_WIDTH => 16,
    p_LEVEL => p_LEVEL
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    -- i_CTRL inputs
    i_SETK => i_SETK,
    i_K    => i_A (0),
    i_SETP => i_SETP,
    i_P    => i_B (0),
    i_RECT => i_RECT,
    i_GETK => i_GETK,
    i_RAND => i_A (1) & i_A (2) & i_A (3)(1 downto 0),
    o_ZERO => o_ZERO,
    o_YMAX => o_YMAX,
    -- DNU input
    i_A => i_A,
    i_B => i_B,

    -- DNU output
    o_YDN => o_YDN,
    o_YFP => o_YFP
  );

end rtl;