-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Jakub Lůčný (xlucnyj00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity UART_RX_FSM is
    port(
       CLK          : in std_logic;
       RST          : in std_logic;
       DIN          : in std_logic;
       C_COUNTER1   : in std_logic;
       C_COUNTER3   : in std_logic;
       BIT_COUNTER  : in std_logic;
       RST_CC1      : out std_logic;
       RST_CC2      : out std_logic;
       RST_CC3      : out std_logic;
       RST_BC       : out std_logic;
       DOUT_VLD     : out std_logic
    );
end entity;



architecture behavioral of UART_RX_FSM is
    
    type t_state is (IDLE, START_BIT, DATA, STOP_BIT);
    signal state : t_state;
    signal next_state : t_state;

begin

    -- Present state register
    state_register: process(CLK, RST)
    begin
        if rising_edge(CLK) then
            -- reset to default state
            if RST = '1' then
                state <= IDLE;
            else
                state <= next_state;
            end if;
        end if;
    end process;

    -- Transition between states
    next_state_logic: process(state, DIN, C_COUNTER1, C_COUNTER3, BIT_COUNTER)
    begin
        next_state <= state; -- default behaviour, FSM stays in the same state
        DOUT_VLD    <= '0';  -- default value of Mealy output DOUT_VLD is 0
        case state is
            when IDLE =>
                if DIN = '0' then
                    next_state <= START_BIT;
                end if;
            when START_BIT =>
                if C_COUNTER1 = '1' then
                    next_state <= DATA;
                end if;
            when DATA =>
                if BIT_COUNTER = '1' then
                    next_state <= STOP_BIT;
                end if;
            when STOP_BIT =>
                if C_COUNTER3 = '1' then
                    next_state <= IDLE;
                    DOUT_VLD <= '1';
                end if;
        end case;
    end process;

    -- Output combinatorial logic
    output_logic: process(state)
    begin
        -- default values
        RST_CC1     <= '1';
        RST_CC2     <= '1';
        RST_CC3     <= '1';
        RST_BC      <= '1';
        case state is
            when IDLE =>
            when START_BIT =>
                RST_CC1 <= '0';
            when DATA =>
                RST_CC2 <= '0';
                RST_BC <= '0';
            when STOP_BIT =>
                RST_CC3 <= '0';
        end case;
    end process;

end architecture;
