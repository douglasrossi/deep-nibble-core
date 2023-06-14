library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity slq is
  port (
    i_CLK  : in std_logic;
    i_RST  : in std_logic;
    i_RECT : in std_logic;
    i_S    : in std_logic;
    i_GETK : in std_logic;
    i_E    : in std_logic_vector(4 downto 0);
    i_M    : in std_logic_vector(9 downto 0);
    i_RAND : in std_logic_vector(9 downto 0);
    i_K    : in std_logic_vector(2 downto 0);
    o_YDN  : out std_logic_vector(3 downto 0);
    o_ZERO : out std_logic;
    o_YMAX : out std_logic
  );
end slq;

architecture rtl of slq is

  signal w_GREATER      : std_logic;
  signal w_LESS         : std_logic;
  signal w_OVERFLOW     : std_logic;
  signal w_UNDERFLOW    : std_logic;
  signal w_ANDRECTS     : std_logic;
  signal w_EN           : std_logic;
  signal w_ANDSGETK     : std_logic;
  signal w_UNDERFLOWMUX : std_logic;
  signal w_SUM          : unsigned(5 downto 0);
  signal w_MUXOUT       : unsigned(5 downto 0);
  signal w_KSUB         : unsigned(5 downto 0);
  signal w_SUBMUX       : unsigned(2 downto 0);
  signal w_MUXSEL       : std_logic_vector(1 downto 0);
  signal w_REG          : std_logic_vector(5 downto 0);

  -- register component
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

  w_ANDSGETK <= i_S and (not i_GETK);
  w_ANDRECTS <= i_RECT and w_ANDSGETK;

  -- i_M and i_RAND greater than verification
  process (i_M, i_RAND)
  begin
    if (i_M > i_RAND) then
      w_GREATER <= '1';
    else
      w_GREATER <= '0';
    end if;
  end process;

  -- i_E + (i_M > i_RAND)
  w_SUM <= (i_E(4) & unsigned(i_E)) + ("0000" & w_GREATER);

  -- i_K - w_REG
  w_KSUB <= unsigned(w_REG) - ("000" & unsigned(i_K));

  -- register enable process 
  process (w_SUM, w_REG)
  begin
    if (w_SUM > unsigned(w_REG)) then
      w_EN <= '1';
    else
      w_EN <= '0';
    end if;
  end process;

  -- register
  reg_inst : reg
  generic map(
    p_WIDTH => 6
  )
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => w_EN,
    i_D   => std_logic_vector(w_SUM),
    o_Q   => w_REG
  );

  -- Mux inside
  process (w_SUM, w_KSUB, i_GETK)
  begin
    case i_GETK is
      when '0' => w_MUXOUT    <= w_SUM;
      when '1' => w_MUXOUT    <= w_KSUB;
      when others => w_MUXOUT <= (others => '0');
    end case;
  end process;

  -- Normal signal
  w_SUBMUX <= 7 - w_MUXOUT(2 downto 0);

  -- Underflow step
  process (w_MUXOUT)
  begin
    if (w_MUXOUT < 8) then
      w_LESS <= '1';
    else
      w_LESS <= '0';
    end if;
  end process;

  o_ZERO <= w_LESS;

  -- underflow final
  w_UNDERFLOW <= w_LESS or w_ANDRECTS;

  -- overflow process
  process (w_MUXOUT)
  begin
    if (w_MUXOUT > 15) then
      w_OVERFLOW <= '1';
    else
      w_OVERFLOW <= '0';
    end if;
  end process;

  w_MUXSEL <= (w_OVERFLOW & w_UNDERFLOW);

  o_YMAX <= (not w_ANDSGETK) and w_EN;

  w_UNDERFLOWMUX <= (not i_GETK) and i_RAND(9);

  -- Output mux 
  process (w_MUXSEL, w_SUBMUX, w_ANDSGETK, w_UNDERFLOWMUX)
  begin
    case w_MUXSEL is
      when "00" => o_YDN   <= w_ANDSGETK & std_logic_vector(w_SUBMUX);
      when "01" => o_YDN   <= w_UNDERFLOWMUX & "111";
      when "10" => o_YDN   <= w_ANDSGETK & "000";
      when "11" => o_YDN   <= w_UNDERFLOWMUX & "111";
      when others => o_YDN <= (others => '0');
    end case;
  end process;

end rtl;