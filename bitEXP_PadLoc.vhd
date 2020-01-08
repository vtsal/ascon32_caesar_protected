-------------------------------------------------------------------------------
--! @file       bitEXP_PadLoc.vhd
--! @brief      Cipher core for ldummy1
--! @project    CAESAR Candidate Evaluation
--! @author     Farnoud Farahmand
--! @copyright  Copyright (c) 2017 Cryptographic Engineering Research Group
--!             ECE Department, George Mason University Fairfax, VA, U.S.A.
--!             All rights Reserved.
--! @license    This project is released under the GNU Public License.
--!             The license and distribution terms for this file may be
--!             found in the file LICENSE in this distribution or at
--!             http://www.gnu.org/licenses/gpl-3.0.txt
--! @note       This is publicly available encryption source code that falls
--!             under the License Exception TSU (Technology and software-
--!             —unrestricted)
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.design_pkg.all;

entity bitEXP_PadLoc is
    
    port(
        input           : in   std_logic_vector(PWdiv8 -1 downto 0);
        output          : out  std_logic_vector(PW     -1 downto 0)
        );

end bitEXP_PadLoc;

architecture structure of bitEXP_PadLoc is

begin

    G1: for i in 0 to (PWdiv8-1) generate
		output ((8*i)+7) <= input(i);
		G2: for j in 0 to 6 generate        
			output ((8*i)+j) <= '0';
		end generate;
	end generate;	
						 
end structure;

