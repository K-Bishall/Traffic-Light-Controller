-- 4 way traffic light control

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- port definition
-- clr: clears all outputs
-- mode: '0' - auto, '1' - manual
-- switch: manual mode direction selector: E-W-N-S order
-- green, yellow, red: lights in 4 ways E-W-N-S order
-- zebraRed, zebraGreen: zebra crossing lights EW-NS order

entity controller is
    port(clr: in std_logic;
         clk: in std_logic;
         mode: in std_logic;
         switch: in std_logic_vector(3 downto 0);
         green: out std_logic_vector(3 downto 0);
         yellow: out std_logic_vector(3 downto 0);
         red: out std_logic_vector(3 downto 0);
         zebraRed: out std_logic_vector(1 downto 0);
         zebraGreen: out std_logic_vector(1 downto 0));
end controller;


architecture arch of controller is

    -- used in timer to generate delay
    constant longCount : integer := 30; --count 30 clock pulses 
    constant shortCount : integer := 10; --count 10 clock pulses

    signal state: integer range 0 to 11;
    -- variable pre_status: integer := 0;
    signal timeout: std_logic := '0'; -- flag : '1' if timeout in any state
    signal Tl, Ts: std_logic := '0';  -- signals to trigger timer function : Tl - long time, Ts - short time

begin --architecture

    -- sequential circuit to determine present state
    seq: process (clr, mode, timeout, clk)
    begin
        if mode = '0' then
            if clr = '1' then
                state <= 0;
            elsif timeout = '1' and rising_edge(clk) then
                state <= (state + 1) mod 12;
            end if;

        -- manual mode
        elsif mode = '1' then
            -- save current state
            -- pre_state := state;
            
            if switch(3) = '1' then
                state <= 4;
            elsif switch(2) = '1' then
                state <= 2;
            elsif switch(1) = '1' then
                state <= 10;
            elsif switch(0) = '1' then
                state <= 8;
            end if;
        end if;
    end process;

    -- combinational circuit which maps present state to correspongind lights
    comb: process (state)
    begin
        Tl <= '0'; Ts <= '0';
        case state is
            when 0 =>
                -- EW green and Zebra NS GREEN, all others RED
                green(3 downto 2) <= "11"; red(3 downto 2) <= "00"; -- EW
                green(1 downto 0) <= "00"; red(1 downto 0) <= "11"; -- NS
                yellow(3 downto 0) <= "0000";

                zebraGreen(1) <= '0'; zebraRed(1) <= '1'; --EW
                zebraGreen(0) <= '1'; zebraRed(0) <= '0'; --NS

                -- start timer
                Tl <= '1';
            
            when 1 =>
                -- E - yellow, turn off green
                yellow(3) <= '1'; green(3) <= '0';

                -- start timer
                Ts <= '1';
            
            when 2 =>
                -- E-red, turn off yellow
                red(3) <= '1'; yellow(3) <= '0';
                --Zebra-NS red, turnoff green
                zebraRed(0) <= '1'; zebraGreen(0) <= '0';

                --start timer
                Tl <= '1';
            
            when 3 =>
                -- W-yellow, turn off green
                yellow(2) <= '1'; green(2) <= '0';

                --start timer
                Ts <= '1';

            when 4 =>
                -- W-red, turn off yellow
                red(2) <= '1'; yellow(2) <= '0';
                -- E-green, turn off red
                green(3) <= '1'; red(3) <= '0';

                --start timer
                Tl <= '1';
            
            when 5 =>
                -- E-yellow, turn off green
                yellow(3) <= '1'; green(3) <= '0';

                --start timer
                Ts <= '1';

            when 6 =>
                --E-red, turnoff yellow
                red(3) <= '1'; yellow(3) <= '0';
                --NS - green, turn off red
                green(1 downto 0) <= "11"; red(1 downto 0) <= "00";
                --Zebra-EW green, turn off red
                zebraGreen(1) <= '1'; zebraRed(1) <= '0';

                --start timer
                Tl <= '1';
            
            when 7 =>
                -- N-yellow, turnoff green
                yellow(1) <= '1'; green(1) <= '0';

                --start timer
                Ts <= '1';

            when 8 =>
                --N-red, turn off yellow
                red(1) <= '1'; yellow(1) <= '0';
                --Zebra EW- red, turnoff green
                zebraRed(1) <= '1'; zebraGreen(1) <= '0';

                --start timer
                Tl <= '1';

            when 9 =>
                --S-yellow, turnoff green
                yellow(0) <= '1'; green(0) <= '0';

                --start timer
                Ts <= '1';
            
            when 10 =>
                --S-red, turn off yellow
                red(0) <= '1'; yellow(0) <= '0';
                --N-green, turnoff red
                green(1) <= '1'; red(1) <= '1';

                --start timer
                Tl <= '1';

            when 11 =>
                --N-yellow, turn off green
                yellow(1) <= '1'; green(1) <= '0';

                --start timer
                Ts <= '1';

        end case;
    end process;

    -- timer process
    timer: process(Tl, Ts, clk)
    variable count : integer;
    begin
        timeout <= '0';
        count := 0;
        if Tl = '1' then
            for i in 1 to longCount loop
                if rising_edge(clk) and count <= longCount then
                    count := count + 1;
                end if;
        end loop;
		timeout <= '1';
        -- Tl <= '0';

        elsif Ts = '1' then
            -- timeout <= '0';
            -- count := 0;
            for i in 1 to shortCount loop
                if rising_edge(clk) and count <= shortCount then
                    count := count +1;
                end if;
        end loop;
		  timeout <= '1';
        -- Ts <= '0';
                
        end if;

    end process;

end arch ; -- arch

