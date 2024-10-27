-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Jakub Lůčný (xlucnyj00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic;
        DOUT     : out std_logic_vector(7 downto 0);
        DOUT_VLD : out std_logic
    );
end entity;



-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is

    -- Signals used
    signal c_count1 : std_logic_vector(3-1 downto 0);
    signal rst_cc1 : std_logic;
    signal maxc1 : std_logic;
    signal c_count2 : std_logic_vector(4-1 downto 0);
    signal rst_cc2 : std_logic;
    signal rst_bc : std_logic;
    signal maxb : std_logic;
    signal bit_count : std_logic_vector(4-1 downto 0);
    signal sample : std_logic;
    signal c_count3 : std_logic_vector(5-1 downto 0);
    signal rst_cc3 : std_logic;
    signal maxc2 : std_logic;

begin
    ------------------------------ 1. COUNTER --------------------------------
    c_counter1_p: process(CLK, rst_cc1)
    begin
        if rising_edge(CLK) then
            if rst_cc1 = '1' then
                c_count1 <= (others => '0');
            else
                c_count1 <= c_count1 + 1;
            end if;
        end if;
    end process c_counter1_p;
    -- comparator
    maxc1 <= '1' when c_count1 = "111" else '0';

    ------------------------------ 2. COUNTER -----------------------------
    c_counter2_p: process(CLK, rst_cc2)
    begin
        if rising_edge(CLK) then
            if rst_cc2 = '1' then
                c_count2 <= (others => '0');
            else
                c_count2 <= c_count2 + 1;
            end if;
        end if;
    end process c_counter2_p;
    -- Comparator 
    sample <= '1' when c_count2 = "1111" else '0';

    ----------------------------- 3. COUNTER -------(bit counter)--------------
    bit_counter_p: process(CLK, rst_bc, sample)
    begin
        if rising_edge(CLK) then
            if rst_bc = '1' then
                bit_count <= (others => '0');
            elsif sample = '1' then
                bit_count <= bit_count + 1;
            end if;
        end if;
    end process bit_counter_p;
    -- comparator
    maxb <= '1' when bit_count = "1000" else '0';

    ----------------------------- 4. COUNTER ---------------------------------
    c_counter3_p: process(CLK, rst_cc3)
    begin
        if rising_edge(CLK) then
            if rst_cc3 = '1' then
                c_count3 <= (others => '0');
            else
                c_count3 <= c_count3 + 1;
            end if;
        end if;
    end process c_counter3_p;
    -- Comparator 
    maxc2 <= '1' when c_count3 = "10111" else '0';

    ------------------------- Demultiplexor ------------------------
    demultiplexor_p: process(CLK, RST, sample)
    begin
        if RST = '1' then
            DOUT <= (others => '0');
        elsif rising_edge(CLK) then
            if sample = '1' then
                case bit_count is
                    when "0000" => DOUT(0) <= DIN;
                    when "0001" => DOUT(1) <= DIN;
                    when "0010" => DOUT(2) <= DIN;
                    when "0011" => DOUT(3) <= DIN;
                    when "0100" => DOUT(4) <= DIN;
                    when "0101" => DOUT(5) <= DIN;
                    when "0110" => DOUT(6) <= DIN;
                    when "0111" => DOUT(7) <= DIN;
                    when others => null;
                end case;
            end if;
        end if;
    end process demultiplexor_p;

    -- Instance of RX FSM
    fsm: entity work.UART_RX_FSM
    port map (
        CLK => CLK,
        RST => RST,
        DIN => DIN,
        C_COUNTER1 => maxc1,
        C_COUNTER3 => maxc2,
        BIT_COUNTER => maxb,
        RST_CC1 => rst_cc1,
        RST_CC2 => rst_cc2,
        RST_CC3 => rst_cc3,
        RST_BC => rst_bc,
        DOUT_VLD => DOUT_VLD
    );

end architecture;
