library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dnu is
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
        
        -- DNU input values
        -- i_A : in
        -- i_B : in
        
        -- DNU outputs
        o_YDN : out std_logic_vector(3 downto 0);
        o_YFP : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of dnu is

    component nslq
        port (
        i_CLK : in std_logic;
        i_RST : in std_logic;
        i_Z : in std_logic_vector(23 downto 0);
        i_SETK : in std_logic;
        i_K : in std_logic_vector(3 downto 0);
        i_SETP : in std_logic;
        i_P : in std_logic_vector(3 downto 0);
        i_RECT : in std_logic;
        i_GETK : in std_logic;
        i_RAND : in std_logic_vector(9 downto 0);
        o_YDN : out std_logic_vector(3 downto 0);
        o_YFP : out std_logic_vector(15 downto 0);
        o_ZERO : out std_logic;
        o_YMAX : out std_logic
      );
    end component;
    
begin

    

end architecture;
