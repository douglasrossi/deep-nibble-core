library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity slq is
  port (
    i_RECT : in std_logic;
    i_S : in std_logic;
    i_E : in std_logic_vector(4 downto 0);
    i_M : in std_logic_vector(9 downto 0);
    i_RAND : in std_logic_vector(9 downto 0);
    o_Y : out std_logic_vector(3 downto 0)
  );
end slq;

architecture rtl of slq is

  signal w_GREATER, w_LESS, w_OVERFLOW, w_UNDERFLOW, w_ANDRECTS : std_logic := '0';
  signal w_SUM : unsigned(5 downto 0) := (others => '0');
  signal w_SUB : unsigned(2 downto 0) := (others => '0');
  signal w_MUXSEL : std_logic_vector(1 downto 0) := (others => '0');

begin

  w_ANDRECTS <= i_RECT and i_S;

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
  w_SUM <= '0' & unsigned(i_E) + (w_GREATER & "0000");

  -- Normal signal
  w_SUB <= 7 - w_SUM(2 downto 0);

  -- underflow step
  process (w_SUM)
  begin
    if (w_SUM < 8) then
      w_LESS <= '1';
    else
      w_LESS <= '0';
    end if;
  end process;

  -- underflow final
  w_UNDERFLOW <= w_LESS or w_ANDRECTS;

  -- overflow process
  process (w_SUM)
  begin
    if (w_SUM > 15) then
      w_OVERFLOW <= '1';
    else
      w_OVERFLOW <= '0';
    end if;
  end process;

  w_MUXSEL <= (w_OVERFLOW & w_UNDERFLOW);

  -- output multiplexer 
  process (w_SUB, i_RAND, i_S, w_MUXSEL)
  begin
    case w_MUXSEL is
      when "00" => o_Y <= i_S & std_logic_vector(w_SUB);
      when "01" => o_Y <= i_S & "000";
      when "10" => o_Y <= i_RAND(9) & "111";
      when others => o_Y <= (others => '0');
    end case;
  end process;

end rtl;