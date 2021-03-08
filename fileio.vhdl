-- ------------------------------------------------------------------------------------------------
-- B. Lang, OS
-- ------------------------------------------------------------------------------------------------

use STD.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

entity example_file_io_tb is
  constant S_WIDTH   : natural := 4; -- stimulus width
  constant R_WIDTH   : natural := 6; -- result width
  constant FREQUENCY : REAL := 50_000_000.000; -- HZ
end example_file_io_tb;
 
architecture behave of example_file_io_tb is
  signal   stimulus    : std_logic_vector(S_WIDTH-1 downto 0);
  signal   result      : std_logic_vector(R_WIDTH-1 downto 0);
  signal   result_sync : std_logic_vector(R_WIDTH-1 downto 0);
  signal   clock       : std_logic := '0';
begin
  
  clock <= not clock after (0.5 sec / FREQUENCY);

  -- example circuit for demonstrating pipe communication 
  result <= "000001" when stimulus="0000" else
            "000010" when stimulus="0001" else
            "000100" when stimulus="0010" else
            "001000" when stimulus="0011" else
            "010000" when stimulus="0100" else
            "100000" when stimulus="0101" else
            "110000" when stimulus="0110" else
            "011000" when stimulus="0111" else
            "001100" when stimulus="1000" else
            "000110" when stimulus="1001" else
            "000011" when stimulus="1010" else
            "001001" when stimulus="1011" else
            "100000" when stimulus="1100" else
            "110000" when stimulus="1101" else
            "111000" when stimulus="1110" else
            "111100" when stimulus="1111" else
            "XXXXXX";

  process(clock)
  begin
    if rising_edge(clock) then
      result_sync <= result;
    end if;
  end process;

  process
    -- file io vars
    file     i_file      : text;
    constant i_filename  : string := "\\.\pipe\PipeA";
    file     o_file      : text;
    constant o_filename  : string := "\\.\pipe\PipeB";
    variable open_status : file_open_status;
    variable good        : boolean;
    variable i_line      : line;
    variable o_line      : line;
    -- stimulus vars
    variable v_stimulus  : std_logic_vector(S_WIDTH-1 downto 0);
    variable terminate   : std_logic;
    
    variable v_SPACE     : character;
    constant divider     : string :=  " --- ";
  begin
    -- open stimulus file
    loop
      file_open(open_status, i_file, i_filename,  read_mode);
      exit when open_status = open_ok;
    end loop;
    -- open result file
    loop
      file_open(open_status,o_file, o_filename, write_mode);
      exit when open_status = open_ok;
    end loop;
    -- processing loop    
    loop
        wait until falling_edge(clock);
        -- read stimulus
        readline(i_file, i_line);
        read(i_line, v_stimulus, good); next when not good;
        read(i_line, terminate, good); next when not good;
        stimulus <= v_stimulus;
        report "stimulus read" severity note;
        -- write results
        write(o_line, result);
        write(o_line, character(' '));
        write(o_line, result_sync);
        write(o_line, divider);
        write(o_line, now);
        writeline(o_file, o_line);
        flush(o_file);
        report "result written" severity note;
        --
        exit when terminate /= '0';
    end loop;
 
    file_close(i_file);
    file_close(o_file);
    
    report "Done" severity note;
    
    wait;
  end process;
 
end behave;