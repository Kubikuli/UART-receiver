library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity UART_RX is
  port (
    CLK: in std_logic;
    RST: in std_logic;
    DIN: in std_logic;
    DOUT: out std_logic_vector (7 downto 0);
    DOUT_VLD: out std_logic
  );
end entity;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx_fsm is
  port (
    clk : in std_logic;
    rst : in std_logic;
    din : in std_logic;
    c_counter1 : in std_logic;
    c_counter3 : in std_logic;
    bit_counter : in std_logic;
    rst_cc1 : out std_logic;
    rst_cc2 : out std_logic;
    rst_cc3 : out std_logic;
    rst_bc : out std_logic;
    dout_vld : out std_logic);
end entity uart_rx_fsm;

architecture rtl of uart_rx_fsm is
  signal state : std_logic_vector (1 downto 0);
  signal next_state : std_logic_vector (1 downto 0);
  signal n115_o : std_logic_vector (1 downto 0);
  signal n119_o : std_logic;
  signal n121_o : std_logic_vector (1 downto 0);
  signal n123_o : std_logic;
  signal n125_o : std_logic_vector (1 downto 0);
  signal n127_o : std_logic;
  signal n129_o : std_logic_vector (1 downto 0);
  signal n131_o : std_logic;
  signal n134_o : std_logic;
  signal n136_o : std_logic_vector (1 downto 0);
  signal n138_o : std_logic;
  signal n139_o : std_logic_vector (3 downto 0);
  signal n142_o : std_logic;
  signal n145_o : std_logic_vector (1 downto 0);
  signal n149_o : std_logic;
  signal n151_o : std_logic;
  signal n153_o : std_logic;
  signal n155_o : std_logic;
  signal n156_o : std_logic_vector (3 downto 0);
  signal n160_o : std_logic;
  signal n165_o : std_logic;
  signal n170_o : std_logic;
  signal n175_o : std_logic;
  signal n178_q : std_logic_vector (1 downto 0);
begin
  rst_cc1 <= n160_o;
  rst_cc2 <= n165_o;
  rst_cc3 <= n170_o;
  rst_bc <= n175_o;
  dout_vld <= n142_o;
  -- uart_rx_fsm.vhd:31:12
  state <= n178_q; -- (signal)
  -- uart_rx_fsm.vhd:32:12
  next_state <= n145_o; -- (signal)
  -- uart_rx_fsm.vhd:40:13
  n115_o <= next_state when rst = '0' else "00";
  -- uart_rx_fsm.vhd:55:24
  n119_o <= not din;
  -- uart_rx_fsm.vhd:55:17
  n121_o <= state when n119_o = '0' else "01";
  -- uart_rx_fsm.vhd:54:13
  n123_o <= '1' when state = "00" else '0';
  -- uart_rx_fsm.vhd:59:17
  n125_o <= state when c_counter1 = '0' else "10";
  -- uart_rx_fsm.vhd:58:13
  n127_o <= '1' when state = "01" else '0';
  -- uart_rx_fsm.vhd:63:17
  n129_o <= state when bit_counter = '0' else "11";
  -- uart_rx_fsm.vhd:62:13
  n131_o <= '1' when state = "10" else '0';
  -- uart_rx_fsm.vhd:67:17
  n134_o <= '0' when c_counter3 = '0' else '1';
  -- uart_rx_fsm.vhd:67:17
  n136_o <= state when c_counter3 = '0' else "00";
  -- uart_rx_fsm.vhd:66:13
  n138_o <= '1' when state = "11" else '0';
  n139_o <= n138_o & n131_o & n127_o & n123_o;
  -- uart_rx_fsm.vhd:53:9
  with n139_o select n142_o <=
    n134_o when "1000",
    '0' when "0100",
    '0' when "0010",
    '0' when "0001",
    'X' when others;
  -- uart_rx_fsm.vhd:53:9
  with n139_o select n145_o <=
    n136_o when "1000",
    n129_o when "0100",
    n125_o when "0010",
    n121_o when "0001",
    "XX" when others;
  -- uart_rx_fsm.vhd:83:13
  n149_o <= '1' when state = "00" else '0';
  -- uart_rx_fsm.vhd:84:13
  n151_o <= '1' when state = "01" else '0';
  -- uart_rx_fsm.vhd:86:13
  n153_o <= '1' when state = "10" else '0';
  -- uart_rx_fsm.vhd:89:13
  n155_o <= '1' when state = "11" else '0';
  n156_o <= n155_o & n153_o & n151_o & n149_o;
  -- uart_rx_fsm.vhd:82:9
  with n156_o select n160_o <=
    '1' when "1000",
    '1' when "0100",
    '0' when "0010",
    '1' when "0001",
    'X' when others;
  -- uart_rx_fsm.vhd:82:9
  with n156_o select n165_o <=
    '1' when "1000",
    '0' when "0100",
    '1' when "0010",
    '1' when "0001",
    'X' when others;
  -- uart_rx_fsm.vhd:82:9
  with n156_o select n170_o <=
    '0' when "1000",
    '1' when "0100",
    '1' when "0010",
    '1' when "0001",
    'X' when others;
  -- uart_rx_fsm.vhd:82:9
  with n156_o select n175_o <=
    '1' when "1000",
    '0' when "0100",
    '1' when "0010",
    '1' when "0001",
    'X' when others;
  -- uart_rx_fsm.vhd:39:9
  process (clk)
  begin
    if rising_edge (clk) then
      n178_q <= n115_o;
    end if;
  end process;
end rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of uart_rx is
  signal wrap_CLK: std_logic;
  signal wrap_RST: std_logic;
  signal wrap_DIN: std_logic;
  subtype typwrap_DOUT is std_logic_vector (7 downto 0);
  signal wrap_DOUT: typwrap_DOUT;
  signal wrap_DOUT_VLD: std_logic;
  signal c_count1 : std_logic_vector (2 downto 0);
  signal rst_cc1 : std_logic;
  signal maxc1 : std_logic;
  signal c_count2 : std_logic_vector (3 downto 0);
  signal rst_cc2 : std_logic;
  signal rst_bc : std_logic;
  signal maxb : std_logic;
  signal bit_count : std_logic_vector (3 downto 0);
  signal sample : std_logic;
  signal c_count3 : std_logic_vector (4 downto 0);
  signal rst_cc3 : std_logic;
  signal maxc2 : std_logic;
  signal n5_o : std_logic_vector (2 downto 0);
  signal n7_o : std_logic_vector (2 downto 0);
  signal n12_o : std_logic;
  signal n13_o : std_logic;
  signal n18_o : std_logic_vector (3 downto 0);
  signal n20_o : std_logic_vector (3 downto 0);
  signal n25_o : std_logic;
  signal n26_o : std_logic;
  signal n31_o : std_logic_vector (3 downto 0);
  signal n32_o : std_logic_vector (3 downto 0);
  signal n34_o : std_logic_vector (3 downto 0);
  signal n39_o : std_logic;
  signal n40_o : std_logic;
  signal n45_o : std_logic_vector (4 downto 0);
  signal n47_o : std_logic_vector (4 downto 0);
  signal n52_o : std_logic;
  signal n53_o : std_logic;
  signal n58_o : std_logic;
  signal n60_o : std_logic;
  signal n62_o : std_logic;
  signal n64_o : std_logic;
  signal n66_o : std_logic;
  signal n68_o : std_logic;
  signal n70_o : std_logic;
  signal n72_o : std_logic;
  signal n73_o : std_logic_vector (7 downto 0);
  signal n74_o : std_logic;
  signal n75_o : std_logic;
  signal n76_o : std_logic;
  signal n77_o : std_logic;
  signal n78_o : std_logic;
  signal n79_o : std_logic;
  signal n80_o : std_logic;
  signal n81_o : std_logic;
  signal n82_o : std_logic;
  signal n83_o : std_logic;
  signal n84_o : std_logic;
  signal n85_o : std_logic;
  signal n86_o : std_logic;
  signal n87_o : std_logic;
  signal n88_o : std_logic;
  signal n89_o : std_logic;
  signal n90_o : std_logic_vector (7 downto 0);
  signal fsm_c_rst_cc1 : std_logic;
  signal fsm_c_rst_cc2 : std_logic;
  signal fsm_c_rst_cc3 : std_logic;
  signal fsm_c_rst_bc : std_logic;
  signal fsm_c_dout_vld : std_logic;
  signal n101_q : std_logic_vector (2 downto 0);
  signal n102_q : std_logic_vector (3 downto 0);
  signal n103_q : std_logic_vector (3 downto 0);
  signal n104_q : std_logic_vector (4 downto 0);
  signal n105_o : std_logic_vector (7 downto 0);
  signal n106_q : std_logic_vector (7 downto 0);
begin
  wrap_clk <= clk;
  wrap_rst <= rst;
  wrap_din <= din;
  dout <= wrap_dout;
  dout_vld <= wrap_dout_vld;
  wrap_DOUT <= n106_q;
  wrap_DOUT_VLD <= fsm_c_dout_vld;
  -- uart_rx.vhd:26:12
  c_count1 <= n101_q; -- (signal)
  -- uart_rx.vhd:27:12
  rst_cc1 <= fsm_c_rst_cc1; -- (signal)
  -- uart_rx.vhd:28:12
  maxc1 <= n13_o; -- (signal)
  -- uart_rx.vhd:29:12
  c_count2 <= n102_q; -- (signal)
  -- uart_rx.vhd:30:12
  rst_cc2 <= fsm_c_rst_cc2; -- (signal)
  -- uart_rx.vhd:31:12
  rst_bc <= fsm_c_rst_bc; -- (signal)
  -- uart_rx.vhd:32:12
  maxb <= n40_o; -- (signal)
  -- uart_rx.vhd:33:12
  bit_count <= n103_q; -- (signal)
  -- uart_rx.vhd:34:12
  sample <= n26_o; -- (signal)
  -- uart_rx.vhd:35:12
  c_count3 <= n104_q; -- (signal)
  -- uart_rx.vhd:36:12
  rst_cc3 <= fsm_c_rst_cc3; -- (signal)
  -- uart_rx.vhd:37:12
  maxc2 <= n53_o; -- (signal)
  -- uart_rx.vhd:47:38
  n5_o <= std_logic_vector (unsigned (c_count1) + unsigned'("001"));
  -- uart_rx.vhd:44:13
  n7_o <= n5_o when rst_cc1 = '0' else "000";
  -- uart_rx.vhd:52:32
  n12_o <= '1' when c_count1 = "111" else '0';
  -- uart_rx.vhd:52:18
  n13_o <= '0' when n12_o = '0' else '1';
  -- uart_rx.vhd:61:38
  n18_o <= std_logic_vector (unsigned (c_count2) + unsigned'("0001"));
  -- uart_rx.vhd:58:13
  n20_o <= n18_o when rst_cc2 = '0' else "0000";
  -- uart_rx.vhd:66:33
  n25_o <= '1' when c_count2 = "1111" else '0';
  -- uart_rx.vhd:66:19
  n26_o <= '0' when n25_o = '0' else '1';
  -- uart_rx.vhd:75:40
  n31_o <= std_logic_vector (unsigned (bit_count) + unsigned'("0001"));
  -- uart_rx.vhd:74:13
  n32_o <= bit_count when sample = '0' else n31_o;
  -- uart_rx.vhd:72:13
  n34_o <= n32_o when rst_bc = '0' else "0000";
  -- uart_rx.vhd:80:32
  n39_o <= '1' when bit_count = "1000" else '0';
  -- uart_rx.vhd:80:17
  n40_o <= '0' when n39_o = '0' else '1';
  -- uart_rx.vhd:89:38
  n45_o <= std_logic_vector (unsigned (c_count3) + unsigned'("00001"));
  -- uart_rx.vhd:86:13
  n47_o <= n45_o when rst_cc3 = '0' else "00000";
  -- uart_rx.vhd:94:32
  n52_o <= '1' when c_count3 = "10111" else '0';
  -- uart_rx.vhd:94:18
  n53_o <= '0' when n52_o = '0' else '1';
  -- uart_rx.vhd:104:21
  n58_o <= '1' when bit_count = "0000" else '0';
  -- uart_rx.vhd:105:21
  n60_o <= '1' when bit_count = "0001" else '0';
  -- uart_rx.vhd:106:21
  n62_o <= '1' when bit_count = "0010" else '0';
  -- uart_rx.vhd:107:21
  n64_o <= '1' when bit_count = "0011" else '0';
  -- uart_rx.vhd:108:21
  n66_o <= '1' when bit_count = "0100" else '0';
  -- uart_rx.vhd:109:21
  n68_o <= '1' when bit_count = "0101" else '0';
  -- uart_rx.vhd:110:21
  n70_o <= '1' when bit_count = "0110" else '0';
  -- uart_rx.vhd:111:21
  n72_o <= '1' when bit_count = "0111" else '0';
  n73_o <= n72_o & n70_o & n68_o & n66_o & n64_o & n62_o & n60_o & n58_o;
  n74_o <= n106_q (0);
  -- uart_rx.vhd:103:17
  with n73_o select n75_o <=
    n74_o when "10000000",
    n74_o when "01000000",
    n74_o when "00100000",
    n74_o when "00010000",
    n74_o when "00001000",
    n74_o when "00000100",
    n74_o when "00000010",
    wrap_DIN when "00000001",
    n74_o when others;
  n76_o <= n106_q (1);
  -- uart_rx.vhd:103:17
  with n73_o select n77_o <=
    n76_o when "10000000",
    n76_o when "01000000",
    n76_o when "00100000",
    n76_o when "00010000",
    n76_o when "00001000",
    n76_o when "00000100",
    wrap_DIN when "00000010",
    n76_o when "00000001",
    n76_o when others;
  n78_o <= n106_q (2);
  -- uart_rx.vhd:103:17
  with n73_o select n79_o <=
    n78_o when "10000000",
    n78_o when "01000000",
    n78_o when "00100000",
    n78_o when "00010000",
    n78_o when "00001000",
    wrap_DIN when "00000100",
    n78_o when "00000010",
    n78_o when "00000001",
    n78_o when others;
  n80_o <= n106_q (3);
  -- uart_rx.vhd:103:17
  with n73_o select n81_o <=
    n80_o when "10000000",
    n80_o when "01000000",
    n80_o when "00100000",
    n80_o when "00010000",
    wrap_DIN when "00001000",
    n80_o when "00000100",
    n80_o when "00000010",
    n80_o when "00000001",
    n80_o when others;
  n82_o <= n106_q (4);
  -- uart_rx.vhd:103:17
  with n73_o select n83_o <=
    n82_o when "10000000",
    n82_o when "01000000",
    n82_o when "00100000",
    wrap_DIN when "00010000",
    n82_o when "00001000",
    n82_o when "00000100",
    n82_o when "00000010",
    n82_o when "00000001",
    n82_o when others;
  n84_o <= n106_q (5);
  -- uart_rx.vhd:103:17
  with n73_o select n85_o <=
    n84_o when "10000000",
    n84_o when "01000000",
    wrap_DIN when "00100000",
    n84_o when "00010000",
    n84_o when "00001000",
    n84_o when "00000100",
    n84_o when "00000010",
    n84_o when "00000001",
    n84_o when others;
  n86_o <= n106_q (6);
  -- uart_rx.vhd:103:17
  with n73_o select n87_o <=
    n86_o when "10000000",
    wrap_DIN when "01000000",
    n86_o when "00100000",
    n86_o when "00010000",
    n86_o when "00001000",
    n86_o when "00000100",
    n86_o when "00000010",
    n86_o when "00000001",
    n86_o when others;
  n88_o <= n106_q (7);
  -- uart_rx.vhd:103:17
  with n73_o select n89_o <=
    wrap_DIN when "10000000",
    n88_o when "01000000",
    n88_o when "00100000",
    n88_o when "00010000",
    n88_o when "00001000",
    n88_o when "00000100",
    n88_o when "00000010",
    n88_o when "00000001",
    n88_o when others;
  n90_o <= n89_o & n87_o & n85_o & n83_o & n81_o & n79_o & n77_o & n75_o;
  -- uart_rx.vhd:119:5
  fsm : entity work.uart_rx_fsm port map (
    clk => wrap_CLK,
    rst => wrap_RST,
    din => wrap_DIN,
    c_counter1 => maxc1,
    c_counter3 => maxc2,
    bit_counter => maxb,
    rst_cc1 => fsm_c_rst_cc1,
    rst_cc2 => fsm_c_rst_cc2,
    rst_cc3 => fsm_c_rst_cc3,
    rst_bc => fsm_c_rst_bc,
    dout_vld => fsm_c_dout_vld);
  -- uart_rx.vhd:43:9
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n101_q <= n7_o;
    end if;
  end process;
  -- uart_rx.vhd:57:9
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n102_q <= n20_o;
    end if;
  end process;
  -- uart_rx.vhd:71:9
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n103_q <= n34_o;
    end if;
  end process;
  -- uart_rx.vhd:85:9
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n104_q <= n47_o;
    end if;
  end process;
  -- uart_rx.vhd:101:9
  n105_o <= n106_q when sample = '0' else n90_o;
  -- uart_rx.vhd:101:9
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n106_q <= "00000000";
    elsif rising_edge (wrap_CLK) then
      n106_q <= n105_o;
    end if;
  end process;
end rtl;
