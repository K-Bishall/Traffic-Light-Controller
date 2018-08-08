-- 4 way traffic light control

library ieee;
use ieee.std_logic_1164.all;

-- port definition
-- clr: clears all outputs
-- mode: '0' - auto, '1' - manual
-- green, yellow, red: lights in 4 ways E-W-N-S order
-- zebraRed, zebraGreen: zebra crossing lights EW-NS order

entity controller is
    port(clr: in std_logic;
         mode: in std_logic;
         green: out std_logic_vector(3 downto 0);
         yellow: out std_logic_vector(3 downto 0);
         red: out std_logic_vector(3 downto 0);
         zebraRed: out std_logic(1 downto 0);
         zebraGreen: out std_logic(1 downto 0));
end controller;

architecture arch of controller is


begin

end arch ; -- arch

