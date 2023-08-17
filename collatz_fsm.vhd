LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;
use ieee.std_logic_arith.all;

entity collatz_fsm is
    port ( clk, mem, start : in std_logic;
           i : in integer;
           o, debug : out integer;
           over : out std_logic );
end collatz_fsm;

architecture arc of collatz_fsm is
type State_type is (A, B, C);
signal state : State_type;
begin
    process(clk, start) is
    variable tempVal : integer := 0;
    variable abVal : integer := 0;
    variable bcVal : integer := 0;
    begin
        if rising_edge(start) then -- has to be a switch
            state <= A;
        end if;
        if rising_edge(clk) then
            case state is
                when A =>
                    if mem = '1' then
                        abVal := tempVal;
                    elsif mem = '0' then
                        abVal := i;
                    end if;
                    state <= B;
                when B =>
                    if abVal mod 2 = 0 then
                        bcVal := abVal / 2;
                    else
                        bcVal := 3 * abVal + 1;
                    end if;
                    state <= C;
                when C =>
                    if bcVal > 255 then
                        tempVal := 0;
                        over <= '1';
                    else
                        tempVal := bcVal;
                        over <= '0';
                    end if;
                    o <= tempVal;
                    state <= A;
                when others =>
                    report "Switch is off.";
            end case;
        end if;
    end process;
end architecture arc;