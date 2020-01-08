-- permutation32_2_TI

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity permutation32_2_TI is
    port (

    clk, rst : in std_logic;
	in0a, in1a, in2a, in3a, in4a  : in  std_logic_vector(64 - 1 downto 0);
	in0b, in1b, in2b, in3b, in4b  : in  std_logic_vector(64 - 1 downto 0);
	out0a, out1a, out2a, out3a, out4a : out std_logic_vector(64 - 1 downto 0);
	out0b, out1b, out2b, out3b, out4b : out std_logic_vector(64 - 1 downto 0);
    m : std_logic_vector(96 - 1 downto 0);
	rcin : in std_logic_vector(7 downto 0);
	perm_start : in std_logic;
	done : out std_logic
	);

end entity permutation32_2_TI;

architecture structural of permutation32_2_TI is

type state_type is (S_START, S_0, S_1, S_2, S_3, S_4, S_5, S_6, S_7, S_8, S_9, S_10, S_11);
signal state, next_state : state_type;

signal run, clr_run, set_run, running, set_running, clr_running, diffsel : std_logic;

signal x0a, x1a, x2a, x3a, x4a : std_logic_vector(32 - 1 downto 0);
signal x0b, x1b, x2b, x3b, x4b : std_logic_vector(32 - 1 downto 0);

signal x0_hi_rega, x1_hi_rega, x2_hi_rega, x3_hi_rega, x4_hi_rega : std_logic_vector(32 - 1 downto 0);
signal x0_hi_regb, x1_hi_regb, x2_hi_regb, x3_hi_regb, x4_hi_regb : std_logic_vector(32 - 1 downto 0);

signal x0_lo_rega, x1_lo_rega, x2_lo_rega, x3_lo_rega, x4_lo_rega : std_logic_vector(32 - 1 downto 0);
signal x0_lo_regb, x1_lo_regb, x2_lo_regb, x3_lo_regb, x4_lo_regb : std_logic_vector(32 - 1 downto 0);

signal next_x0_1_rega, next_x1_2_rega, next_x2_3_rega : std_logic_vector(32 - 1 downto 0);
signal next_x4_0_rega, x4_0_rega : std_logic_vector(32 - 1 downto 0);

signal next_x0_1_regb, next_x1_2_regb, next_x2_3_regb : std_logic_vector(32 - 1 downto 0);
signal next_x4_0_regb, x4_0_regb : std_logic_vector(32 - 1 downto 0);

signal next_x0_hi_reg_1a, next_x4_0_reg_1a, next_x1_hi_reg_1a, next_x2_hi_reg_1a, next_x3_hi_reg_1a, next_x4_hi_reg_1a : std_logic_vector(32 - 1 downto 0);
signal next_x0_hi_reg_1b, next_x4_0_reg_1b, next_x1_hi_reg_1b, next_x2_hi_reg_1b, next_x3_hi_reg_1b, next_x4_hi_reg_1b : std_logic_vector(32 - 1 downto 0);

signal next_x0_hi_reg_2a, next_x4_0_reg_2a, next_x1_hi_reg_2a, next_x2_hi_reg_2a, next_x3_hi_reg_2a, next_x4_hi_reg_2a : std_logic_vector(32 - 1 downto 0);
signal next_x0_hi_reg_2b, next_x4_0_reg_2b, next_x1_hi_reg_2b, next_x2_hi_reg_2b, next_x3_hi_reg_2b, next_x4_hi_reg_2b : std_logic_vector(32 - 1 downto 0);

signal next_x0_lo_reg_1a, next_x1_lo_reg_1a, next_x2_lo_reg_1a, next_x3_lo_reg_1a, next_x4_lo_reg_1a : std_logic_vector(32 - 1 downto 0);
signal next_x0_lo_reg_1b, next_x1_lo_reg_1b, next_x2_lo_reg_1b, next_x3_lo_reg_1b, next_x4_lo_reg_1b : std_logic_vector(32 - 1 downto 0);

signal next_x0_lo_reg_2a, next_x1_lo_reg_2a, next_x2_lo_reg_2a, next_x3_lo_reg_2a, next_x4_lo_reg_2a : std_logic_vector(32 - 1 downto 0);
signal next_x0_lo_reg_2b, next_x1_lo_reg_2b, next_x2_lo_reg_2b, next_x3_lo_reg_2b, next_x4_lo_reg_2b : std_logic_vector(32 - 1 downto 0);

signal next_x0_lo_rega, next_x1_lo_rega,  next_x2_lo_rega, next_x3_lo_rega, next_x4_lo_rega : std_logic_vector(32 - 1 downto 0);
signal next_x0_lo_regb, next_x1_lo_regb,  next_x2_lo_regb, next_x3_lo_regb, next_x4_lo_regb : std_logic_vector(32 - 1 downto 0);

signal next_x0_hi_rega, next_x1_hi_rega, next_x2_hi_rega, next_x3_hi_rega, next_x4_hi_rega  : std_logic_vector(32 - 1 downto 0);
signal next_x0_hi_regb, next_x1_hi_regb, next_x2_hi_regb, next_x3_hi_regb, next_x4_hi_regb  : std_logic_vector(32 - 1 downto 0);

signal x0_xor_x4a, x2rc, x1_xor_x2a, x3_xor_x4a : std_logic_vector(32 - 1 downto 0);
signal x0_xor_x4b, x1_xor_x2b, x3_xor_x4b : std_logic_vector(32 - 1 downto 0);

signal x0_1_rega, x0_reg_xor_x4a, not_x2_3a, x2_3_rega : std_logic_vector(32 - 1 downto 0);
signal x1_2_rega : std_logic_vector(32  - 1 downto 0);

signal x0_1_regb, x0_reg_xor_x4b, not_x2_3b, x2_3_regb : std_logic_vector(32 - 1 downto 0);
signal x1_2_regb : std_logic_vector(32  - 1 downto 0);

signal x3_xor_and_x2a, x0_reg_xor_x1a : std_logic_vector(32 - 1 downto 0);
signal x3_xor_and_x2b, x0_reg_xor_x1b : std_logic_vector(32 - 1 downto 0);

signal en_x2_3_reg, en_x1_2_reg : std_logic;

signal en_x0_hi_reg, en_x0_1_reg, en_x1_hi_reg, en_x2_hi_reg, en_x3_hi_reg, en_x4_hi_reg : std_logic;
signal en_x0_lo_reg, en_x4_0_reg, en_x1_lo_reg, en_x2_lo_reg, en_x3_lo_reg, en_x4_lo_reg : std_logic;

signal upper : std_logic;
signal en_rc_reg : std_logic;
signal rc, rc_reg, next_rc_reg : std_logic_vector(7 downto 0);
signal next_rc_reg_hi, next_rc_reg_lo : std_logic_vector(3 downto 0);
signal and_in1a, and_in2a, and_in1b, and_in2b : std_logic_vector(32 - 1 downto 0);
signal and_outa, and_outb : std_logic_vector(32 - 1 downto 0); 
signal and_sel : std_logic_vector(2 downto 0);
signal insel : std_logic_vector(1 downto 0);

begin
-- control
  done <= not running; -- when done asserts, correct results are registered in output regs
  
-- stage 0

  insel <= upper & run;

  with insel select
     x0a <= in0a(63 downto 32) when "00",
           x0_hi_rega       when "01",
           in0a(31 downto 0)  when "10",
           x0_lo_rega         when "11",
           (others => '0')   when others;
           
  with insel select
     x1a <= in1a(63 downto 32) when "00",
           x1_hi_rega       when "01",
           in1a(31 downto 0)  when "10",
           x1_lo_rega         when "11",
           (others => '0')   when others;
           
  with insel select
     x2a <= in2a(63 downto 32) when "00",
           x2_hi_rega       when "01",
           in2a(31 downto 0)  when "10",
           x2_lo_rega         when "11",
           (others => '0')   when others;

  with insel select
     x3a <= in3a(63 downto 32) when "00",
           x3_hi_rega       when "01",
           in3a(31 downto 0)  when "10",
           x3_lo_rega         when "11",
           (others => '0')   when others;

  with insel select
     x4a <= in4a(63 downto 32) when "00",
           x4_hi_rega       when "01",
           in4a(31 downto 0)  when "10",
           x4_lo_rega         when "11",
           (others => '0')   when others;

   with insel select
     x0b <= in0b(63 downto 32) when "00",
           x0_hi_regb       when "01",
           in0b(31 downto 0)  when "10",
           x0_lo_regb         when "11",
           (others => '0')   when others;
           
  with insel select
     x1b <= in1b(63 downto 32) when "00",
           x1_hi_regb       when "01",
           in1b(31 downto 0)  when "10",
           x1_lo_regb         when "11",
           (others => '0')   when others;
           
  with insel select
     x2b <= in2b(63 downto 32) when "00",
           x2_hi_regb       when "01",
           in2b(31 downto 0)  when "10",
           x2_lo_regb         when "11",
           (others => '0')   when others;

  with insel select
     x3b <= in3b(63 downto 32) when "00",
           x3_hi_regb       when "01",
           in3b(31 downto 0)  when "10",
           x3_lo_regb         when "11",
           (others => '0')   when others;

  with insel select
     x4b <= in4b(63 downto 32) when "00",
           x4_hi_regb       when "01",
           in4b(31 downto 0)  when "10",
           x4_lo_regb         when "11",
           (others => '0')   when others;

  rc <= rcin when (perm_start = '1') else rc_reg;
  next_rc_reg_hi <= std_logic_vector(unsigned(rc(7 downto 4)) - 1);
  next_rc_reg_lo <= std_logic_vector(unsigned(rc(3 downto 0)) + 1);
  next_rc_reg <= rcin when (perm_start = '1') else next_rc_reg_hi & next_rc_reg_lo;
  
 -- stage 0 and 5 
  x0_xor_x4a <= x0a xor x4a;
  x0_xor_x4b <= x0b xor x4b;
  
  x2rc <= x2a when (upper = '0') else x2a(31 downto 8) & (x2a(7 downto 0) xor rc); --(no round constant in high value)
  
  x1_xor_x2a <= x1a xor x2rc;
  x1_xor_x2b <= x1b xor x2b;
  
  x3_xor_x4a <= x3a xor x4a;
  x3_xor_x4b <= x3b xor x4b;

  next_x4_0_rega <= and_outa xor x3_xor_x4a; -- stage 0 and 5
  next_x4_0_regb <= and_outb xor x3_xor_x4b; -- stage 0 and 5
  
-- stage 1 and 6

  next_x0_1_rega <= x0_xor_x4a xor and_outa; -- stage 1 and 6
  next_x0_1_regb <= x0_xor_x4b xor and_outb; -- stage 1 and 6
  
-- stage 2 and 7

  next_x1_2_rega <= x1a xor and_outa; -- stages 2 and 7
  next_x1_2_regb <= x1b xor and_outb; -- stages 2 and 7
  
-- stage 3 and 8

  next_x2_3_rega <= x1_xor_x2a xor and_outa;
  next_x2_3_regb <= x1_xor_x2b xor and_outb;
  
  x0_reg_xor_x1a <= x0_1_rega xor x1_2_rega;
  x0_reg_xor_x1b <= x0_1_regb xor x1_2_regb;
  
-- stages 4 and 9

  x0_reg_xor_x4a <= x0_1_rega xor x4_0_rega;
  x0_reg_xor_x4b <= x0_1_regb xor x4_0_regb;
  
  not_x2_3a <= not x2_3_rega;
  not_x2_3b <= x2_3_regb; -- only 1 share gets negated
  
  
  x3_xor_and_x2a <= x3a xor and_outa xor x2_3_rega;
  x3_xor_and_x2b <= x3b xor and_outb xor x2_3_regb;
  
-- stage 4 only

  next_x0_hi_reg_1a <= x0_reg_xor_x4a; -- no permutation until last stage
  next_x0_hi_reg_1b <= x0_reg_xor_x4b; -- no permutation until last stage
  
  next_x1_hi_reg_1a <= x0_reg_xor_x1a; -- no permutation until last stage
  next_x1_hi_reg_1b <= x0_reg_xor_x1b; -- no permutation until last stage
  
  next_x2_hi_reg_1a <= not_x2_3a; -- no permutation until last stage
  next_x2_hi_reg_1b <= not_x2_3b; -- no permutation until last stage
  
  next_x3_hi_reg_1a <= x3_xor_and_x2a; -- no permutation until last stage
  next_x3_hi_reg_1b <= x3_xor_and_x2b; -- no permutation until last stage
  
  next_x4_hi_reg_1a <= x4_0_rega; -- no permutation until last stage
  next_x4_hi_reg_1b <= x4_0_regb; -- no permutation until last stage

-- stage 9 only

  next_x0_lo_reg_1a <= x0_reg_xor_x4a; -- no permutation until last stage
  next_x0_lo_reg_1b <= x0_reg_xor_x4b; -- no permutation until last stage
  
  next_x1_lo_reg_1a <= x0_reg_xor_x1a; -- no permutation until last stage
  next_x1_lo_reg_1b <= x0_reg_xor_x1b; -- no permutation until last stage
  
  next_x2_lo_reg_1a <= not_x2_3a; -- no permutation until last stage
  next_x2_lo_reg_1b <= not_x2_3b; -- no permutation until last stage
  
  next_x3_lo_reg_1a <= x3_xor_and_x2a; -- no permutation until last stage
  next_x3_lo_reg_1b <= x3_xor_and_x2b; -- no permutation until last stage
  
  next_x4_lo_reg_1a <= x4_0_rega; -- no permutation until last stage
  next_x4_lo_reg_1b <= x4_0_regb; -- no permutation until last stage

  
-- stage 10 only

  --next_x0_reg <= x0_reg_xor_x4_reg xor (x0_reg_xor_x4_reg(18 downto 0) & x0_reg_xor_x4_reg(63 downto 19)) xor
  --               (x0_reg_xor_x4_reg(27 downto 0) & x0_reg_xor_x4_reg(63 downto 28)); -- permutation

--  next_x0_hi_reg_2a <= x0_hi_rega xor (x0_reg_xor_x4a(18 downto 0) & x0_hi_rega(31 downto 19)) xor
--                    (x0_reg_xor_x4a(27 downto 0) & x0_hi_rega(31 downto 28));

--  next_x0_hi_reg_2b <= x0_hi_regb xor (x0_reg_xor_x4b(18 downto 0) & x0_hi_regb(31 downto 19)) xor
--                    (x0_reg_xor_x4b(27 downto 0) & x0_hi_regb(31 downto 28));
                  
--  next_x0_lo_reg_2a <= x0_reg_xor_x4a xor (x0_hi_rega(18 downto 0) & x0_reg_xor_x4a(31 downto 19)) xor
--                    (x0_hi_rega(27 downto 0) & x0_reg_xor_x4a(31 downto 28));

--  next_x0_lo_reg_2b <= x0_reg_xor_x4b xor (x0_hi_regb(18 downto 0) & x0_reg_xor_x4b(31 downto 19)) xor
--                    (x0_hi_regb(27 downto 0) & x0_reg_xor_x4b(31 downto 28));

 next_x0_hi_reg_2a <= x0_hi_rega xor (x0_lo_rega(18 downto 0) & x0_hi_rega(31 downto 19)) xor
                    (x0_lo_rega(27 downto 0) & x0_hi_rega(31 downto 28));

  next_x0_hi_reg_2b <= x0_hi_regb xor (x0_lo_regb(18 downto 0) & x0_hi_regb(31 downto 19)) xor
                    (x0_lo_regb(27 downto 0) & x0_hi_regb(31 downto 28));
                  
  next_x0_lo_reg_2a <= x0_lo_rega xor (x0_hi_rega(18 downto 0) & x0_lo_rega(31 downto 19)) xor
                    (x0_hi_rega(27 downto 0) & x0_lo_rega(31 downto 28));

  next_x0_lo_reg_2b <= x0_lo_regb xor (x0_hi_regb(18 downto 0) & x0_lo_regb(31 downto 19)) xor
                    (x0_hi_regb(27 downto 0) & x0_lo_regb(31 downto 28));
 
  out0a <= x0_hi_rega & x0_lo_rega;
  out0b <= x0_hi_regb & x0_lo_regb;
  
  --next_x1_reg <= x0_reg_xor_x1_reg xor (x0_reg_xor_x1_reg(60 downto 0) & x0_reg_xor_x1_reg(63 downto 61)) xor
  --               (x0_reg_xor_x1_reg(38 downto 0) & x0_reg_xor_x1_reg(63 downto 39)); -- permutation


  next_x1_hi_reg_2a <= x1_hi_rega xor (x1_hi_rega(28 downto 0) & x1_lo_rega(31 downto 29)) xor
                    (x1_hi_rega(6 downto 0) & x1_lo_rega(31 downto 7));
  next_x1_hi_reg_2b <= x1_hi_regb xor (x1_hi_regb(28 downto 0) & x1_lo_regb(31 downto 29)) xor
                    (x1_hi_regb(6 downto 0) & x1_lo_regb(31 downto 7));

  next_x1_lo_reg_2a <= x1_lo_rega xor (x1_lo_rega(28 downto 0) & x1_hi_rega(31 downto 29)) xor
                   (x1_lo_rega(6 downto 0) & x1_hi_rega(31 downto 7)); 

  next_x1_lo_reg_2b <= x1_lo_regb xor (x1_lo_regb(28 downto 0) & x1_hi_regb(31 downto 29)) xor
                   (x1_lo_regb(6 downto 0) & x1_hi_regb(31 downto 7)); 

  out1a <= x1_hi_rega & x1_lo_rega;
  out1b <= x1_hi_regb & x1_lo_regb;
  
  --next_x2_reg <= not_x2_3_reg xor (not_x2_3_reg(0) & not_x2_3_reg(63 downto 1)) xor  
  --               (not_x2_3_reg(5 downto 0) & not_x2_3_reg(63 downto 6)); -- permutation
  
  next_x2_hi_reg_2a <= x2_hi_rega xor (x2_lo_rega(0) & x2_hi_rega(31 downto 1)) xor
                    (x2_lo_rega(5 downto 0) & x2_hi_rega(31 downto 6));

  next_x2_hi_reg_2b <= x2_hi_regb xor (x2_lo_regb(0) & x2_hi_regb(31 downto 1)) xor
                    (x2_lo_regb(5 downto 0) & x2_hi_regb(31 downto 6));

  next_x2_lo_reg_2a <= x2_lo_rega xor  (x2_hi_rega(0) & x2_lo_rega(31 downto 1)) xor
                    (x2_hi_rega(5 downto 0) & x2_lo_rega(31 downto 6));

  next_x2_lo_reg_2b <= x2_lo_regb xor  (x2_hi_regb(0) & x2_lo_regb(31 downto 1)) xor
                    (x2_hi_regb(5 downto 0) & x2_lo_regb(31 downto 6));

  out2a <= x2_hi_rega & x2_lo_rega;
  out2b <= x2_hi_regb & x2_lo_regb;
  
  --next_x3_reg <= x3_xor_and_x2 xor (x3_xor_and_x2(9 downto 0) & x3_xor_and_x2(63 downto 10)) xor
  --               (x3_xor_and_x2(16 downto 0) & x3_xor_and_x2(63 downto 17)); -- permutation
  --out3 <= x3_reg;
  
  next_x3_hi_reg_2a <= x3_hi_rega xor (x3_lo_rega(9 downto 0) & x3_hi_rega(31 downto 10)) xor
                    (x3_lo_rega(16 downto 0) & x3_hi_rega(31 downto 17));
   
  next_x3_hi_reg_2b <= x3_hi_regb xor (x3_lo_regb(9 downto 0) & x3_hi_regb(31 downto 10)) xor
                    (x3_lo_regb(16 downto 0) & x3_hi_regb(31 downto 17));

  next_x3_lo_reg_2a <= x3_lo_rega xor (x3_hi_rega(9 downto 0) & x3_lo_rega(31 downto 10)) xor
                    (x3_hi_rega(16 downto 0) & x3_lo_rega(31 downto 17));

  next_x3_lo_reg_2b <= x3_lo_regb xor (x3_hi_regb(9 downto 0) & x3_lo_regb(31 downto 10)) xor
                    (x3_hi_regb(16 downto 0) & x3_lo_regb(31 downto 17));
                    
  out3a <= x3_hi_rega & x3_lo_rega;
  out3b <= x3_hi_regb & x3_lo_regb;
  
  --next_x4_reg <= x4_0_reg xor (x4_0_reg(6 downto 0) & x4_0_reg(63 downto 7)) xor
  --               (x4_0_reg(40 downto 0) & x4_0_reg(63 downto 41)); -- permutation
   
  next_x4_hi_reg_2a <= x4_hi_rega xor (x4_lo_rega(6 downto 0) & x4_hi_rega(31 downto 7)) xor
                    (x4_hi_rega(8 downto 0) & x4_lo_rega(31 downto 9));
                    
  next_x4_hi_reg_2b <= x4_hi_regb xor (x4_lo_regb(6 downto 0) & x4_hi_regb(31 downto 7)) xor
                    (x4_hi_regb(8 downto 0) & x4_lo_regb(31 downto 9));
                    
  next_x4_lo_reg_2a <= x4_lo_rega xor (x4_hi_rega(6 downto 0) & x4_lo_rega(31 downto 7)) xor
                    (x4_lo_rega(8 downto 0) & x4_hi_rega(31 downto 9));
                    
  next_x4_lo_reg_2b <= x4_lo_regb xor (x4_hi_regb(6 downto 0) & x4_lo_regb(31 downto 7)) xor
                    (x4_lo_regb(8 downto 0) & x4_hi_regb(31 downto 9)); 

  out4a <= x4_hi_rega & x4_lo_rega;
  out4b <= x4_hi_regb & x4_lo_regb;
  
-- global and gate

  next_x0_hi_rega <= next_x0_hi_reg_1a when (diffsel = '0') else next_x0_hi_reg_2a;
  next_x1_hi_rega <= next_x1_hi_reg_1a when (diffsel = '0') else next_x1_hi_reg_2a;
  next_x2_hi_rega <= next_x2_hi_reg_1a when (diffsel = '0') else next_x2_hi_reg_2a;
  next_x3_hi_rega <= next_x3_hi_reg_1a when (diffsel = '0') else next_x3_hi_reg_2a;
  next_x4_hi_rega <= next_x4_hi_reg_1a when (diffsel = '0') else next_x4_hi_reg_2a;

  next_x0_hi_regb <= next_x0_hi_reg_1b when (diffsel = '0') else next_x0_hi_reg_2b;
  next_x1_hi_regb <= next_x1_hi_reg_1b when (diffsel = '0') else next_x1_hi_reg_2b;
  next_x2_hi_regb <= next_x2_hi_reg_1b when (diffsel = '0') else next_x2_hi_reg_2b;
  next_x3_hi_regb <= next_x3_hi_reg_1b when (diffsel = '0') else next_x3_hi_reg_2b;
  next_x4_hi_regb <= next_x4_hi_reg_1b when (diffsel = '0') else next_x4_hi_reg_2b;
  
  next_x0_lo_rega <= next_x0_lo_reg_1a when (diffsel = '0') else next_x0_lo_reg_2a;
  next_x1_lo_rega <= next_x1_lo_reg_1a when (diffsel = '0') else next_x1_lo_reg_2a;
  next_x2_lo_rega <= next_x2_lo_reg_1a when (diffsel = '0') else next_x2_lo_reg_2a;
  next_x3_lo_rega <= next_x3_lo_reg_1a when (diffsel = '0') else next_x3_lo_reg_2a;
  next_x4_lo_rega <= next_x4_lo_reg_1a when (diffsel = '0') else next_x4_lo_reg_2a;

  next_x0_lo_regb <= next_x0_lo_reg_1b when (diffsel = '0') else next_x0_lo_reg_2b;
  next_x1_lo_regb <= next_x1_lo_reg_1b when (diffsel = '0') else next_x1_lo_reg_2b;
  next_x2_lo_regb <= next_x2_lo_reg_1b when (diffsel = '0') else next_x2_lo_reg_2b;
  next_x3_lo_regb <= next_x3_lo_reg_1b when (diffsel = '0') else next_x3_lo_reg_2b;
  next_x4_lo_regb <= next_x4_lo_reg_1b when (diffsel = '0') else next_x4_lo_reg_2b;

  with and_sel select	
	and_in1a <= x0_xor_x4a when "000",
	           x1a        when "001",
			   x1_xor_x2a when "010",
			   x3a        when "011",
			   x3_xor_x4a when "100",
			   (others => '0') when others;

  with and_sel select	
	and_in1b <= x0_xor_x4b when "000",
	           x1b        when "001",
			   x1_xor_x2b when "010",
			   x3b        when "011",
			   x3_xor_x4b when "100",
			   (others => '0') when others;


  with and_sel select	
	and_in2a <= x1a        when "000",
	           x1_xor_x2a when "001",
			   x3a        when "010",
			   x3_xor_x4a when "011",
			   x0_xor_x4a when "100",
			   (others => '0') when others;

  with and_sel select	
	and_in2b <= x1b        when "000",
	           x1_xor_x2b when "001",
			   x3b        when "010",
			   x3_xor_x4b when "011",
			   x0_xor_x4b when "100",
			   (others => '0') when others;
			   

   and_instance: entity work.and_3TI(structural)
    generic map(N => 32)
	port map(
	xa => and_in1a,
	xb => and_in1b,
	ya => and_in2a,
	yb => and_in2b,
	m => m, 
	o1  => and_outa,
	o2 => and_outb
	);
 
  sync_process: process(clk)
  begin
	if (rising_edge(clk)) then
	   if (rst = '1') then
			run <= '0';
			state <= S_START;
			running <= '0';
		else
			if (en_rc_reg = '1') then -- stage 0	
				rc_reg <= next_rc_reg;
			end if;
			if (en_x4_0_reg = '1') then -- stage 0
				x4_0_rega <= next_x4_0_rega;
				x4_0_regb <= next_x4_0_regb;
			end if;
			if (en_x0_1_reg = '1') then -- stage 1
				x0_1_rega <= next_x0_1_rega;
				x0_1_regb <= next_x0_1_regb;
			end if;
			  if (en_x1_2_reg = '1') then -- stage 2
				 x1_2_rega <= next_x1_2_rega;
				 x1_2_regb <= next_x1_2_regb;
			end if;
			if (en_x2_3_reg = '1') then -- stage 3
				x2_3_rega <= next_x2_3_rega;
				x2_3_regb <= next_x2_3_regb;
			end if;
			if (en_x1_hi_reg = '1') then -- stage 4
				x1_hi_rega <= next_x1_hi_rega;
				x1_hi_regb <= next_x1_hi_regb;
			end if;
 		   if (en_x0_hi_reg = '1') then -- stage 4
				 x0_hi_rega <= next_x0_hi_rega;
				 x0_hi_regb <= next_x0_hi_regb;
			end if;
			if (en_x2_hi_reg = '1') then -- stage 4
				 x2_hi_rega <= next_x2_hi_rega;
				 x2_hi_regb <= next_x2_hi_regb;
			end if;
			if (en_x3_hi_reg = '1') then -- stage 4
				x3_hi_rega <= next_x3_hi_rega;
				x3_hi_regb <= next_x3_hi_regb;
			end if;
			if (en_x4_hi_reg = '1') then -- stage 4
				x4_hi_rega <= next_x4_hi_rega;
				x4_hi_regb <= next_x4_hi_regb;
			end if;
			if (en_x1_lo_reg = '1') then -- stage 4
				x1_lo_rega <= next_x1_lo_rega;
				x1_lo_regb <= next_x1_lo_regb;
			end if;
 		   if (en_x0_lo_reg = '1') then -- stage 4
				 x0_lo_rega <= next_x0_lo_rega;
				 x0_lo_regb <= next_x0_lo_regb;
			end if;
			if (en_x2_lo_reg = '1') then -- stage 4
				 x2_lo_rega <= next_x2_lo_rega;
				 x2_lo_regb <= next_x2_lo_regb;
			end if;
			if (en_x3_lo_reg = '1') then -- stage 4
				x3_lo_rega <= next_x3_lo_rega;
				x3_lo_regb <= next_x3_lo_regb;
			end if;
			if (en_x4_lo_reg = '1') then -- stage 4
				x4_lo_rega <= next_x4_lo_rega;
				x4_lo_regb <= next_x4_lo_regb;
			end if;
			if (set_run = '1') then -- stage 4
				run <= '1';
			end if;
			if (clr_run = '1') then -- stage 4
				run <= '0';
			end if;
			if (set_running = '1') then
				running <= '1';
			end if;
			if (clr_running = '1') then
				running <= '0';
			end if;
			state <= next_state;
			end if;
		end if;
  end process;

  state_process: process(state, perm_start, rc(3 downto 0)) 
  begin
	--defaults
	en_x0_hi_reg <= '0';
	en_x1_hi_reg <= '0';
	en_x2_hi_reg <= '0';
	en_x3_hi_reg <= '0';
	en_x4_hi_reg <= '0';
	en_x0_lo_reg <= '0';
	en_x1_lo_reg <= '0';
	en_x2_lo_reg <= '0';
	en_x3_lo_reg <= '0';
	en_x4_lo_reg <= '0';
	en_x4_0_reg <= '0';
	en_x0_1_reg <= '0';
	en_x1_2_reg <= '0';
	en_x2_3_reg <= '0';
	upper <= '0';
	diffsel <= '0';

	en_rc_reg <= '0';
	clr_run <= '0';
	set_run <= '0';
	set_running <= '0';
	clr_running <= '0';
	
	and_sel <= "000";
	
	case state is
		
		when S_START => 
		
			if (perm_start = '1') then
			    en_x4_0_reg <= '1';
				set_running <= '1';
				en_rc_reg <= '1';
				next_state <= S_1;
			else
			   next_state <= S_START;
			end if;
			
		when S_0 => 
			
			en_x4_0_reg <= '1';
			next_state <= S_1;
		
		when S_1 => 
		    
			and_sel <= "001"; 
			en_x0_1_reg <= '1';
			next_state <= S_2;
			
		when S_2 => 
		    
			and_sel <= "010";
            en_x1_2_reg <= '1';
            next_state <= S_3;

        when S_3 => 

		   and_sel <= "011";
			en_x2_3_reg <= '1';
			next_state <= S_4;
			
		when S_4 =>
		
		    en_x0_hi_reg <= '1';
			en_x1_hi_reg <= '1';
			en_x2_hi_reg <= '1';
			en_x3_hi_reg <= '1';
			en_x4_hi_reg <= '1';
			and_sel <= "100";
			next_state <= S_5;

		when S_5 => 
			
			upper <= '1';
			en_x4_0_reg <= '1';
			next_state <= S_6;
		    and_sel <= "000";

		when S_6 => 
		    
			and_sel <= "001"; 
			upper <= '1';
			en_x0_1_reg <= '1';
			next_state <= S_7;
			
		when S_7 => 
		    
		    and_sel <= "010";
		    upper <= '1';
            en_x1_2_reg <= '1';
            next_state <= S_8;

        when S_8 => 

		    and_sel <= "011";
		    upper <= '1';
			en_x2_3_reg <= '1';
			en_rc_reg <= '1';
			next_state <= S_9;

        when S_9 => 

		    en_x0_lo_reg <= '1';
			en_x1_lo_reg <= '1';
			en_x2_lo_reg <= '1';
			en_x3_lo_reg <= '1';
			en_x4_lo_reg <= '1';
			upper <= '1';
			and_sel <= "100";
            next_state <= S_10;
			
        when S_10 => 
            diffsel <= '1';	-- selects differential layer output	
		    en_x0_lo_reg <= '1';
			en_x1_lo_reg <= '1';
			en_x2_lo_reg <= '1';
            en_x0_hi_reg <= '1';
			en_x1_hi_reg <= '1';
			en_x2_hi_reg <= '1';
            next_state <= S_11;

		when S_11 =>

            diffsel <= '1';	-- selects differential layer output	
			en_x3_lo_reg <= '1';
			en_x4_lo_reg <= '1';
			en_x3_hi_reg <= '1';
			en_x4_hi_reg <= '1';
			if (rc(3 downto 0) = x"c") then -- stop criteria
				clr_run <= '1';
				clr_running <= '1';
				next_state <= S_START;
			else 
				set_run <= '1';
				next_state <= S_0;
			end if;

		when others =>
		
	   end case;
    
	end process;
			
end structural;
