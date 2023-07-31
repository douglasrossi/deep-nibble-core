library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lod is
  port (
    i_DATA : in std_logic_vector(26 downto 1);
    o_DATA : out std_logic_vector(4 downto 0)
  );
end lod;

architecture rtl of lod is

  function maxindex(a : std_logic_vector) return natural is
    variable index      : natural := 0;
  begin
    for i in 1 to 26 loop
      if a(i) = '1' then
        index := i;
      end if;
    end loop;
    return index;
  end function;

begin

  o_DATA <= std_logic_vector(to_unsigned(maxindex(i_DATA), o_DATA'length));

end rtl;