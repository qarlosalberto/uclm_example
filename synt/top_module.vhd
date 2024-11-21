library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_module is
    port (
        a : in  std_logic_vector(7 downto 0);
        b : in  std_logic_vector(7 downto 0);
        sel : in  std_logic_vector(1 downto 0); -- select signal: "00" for addition, "01" for subtraction, "10" for multiplication
        result : out std_logic_vector(15 downto 0) -- 16 bits to accommodate multiplication results
    );
end top_module;

architecture structural of top_module is
    signal sum_result : std_logic_vector(7 downto 0);
    signal sub_result : std_logic_vector(7 downto 0);
    signal mul_result : std_logic_vector(15 downto 0);
begin
    -- instantiate adder
    adder_inst : entity work.adder
        port map (
            a => a,
            b => b,
            result => sum_result
        );

    -- instantiate subtractor
    subtractor_inst : entity work.subtractor
        port map (
            a => a,
            b => b,
            result => sub_result
        );

    -- instantiate multiplier
    multiplier_inst : entity work.multiplier
        port map (
            a => a,
            b => b,
            result => mul_result
        );

    -- output logic based on sel
    result <= std_logic_vector(resize(signed(sum_result), 16)) when sel = "00" else
              std_logic_vector(resize(signed(sub_result), 16)) when sel = "01" else
              mul_result when sel = "10" else
              (others => '0'); -- default case
end structural;