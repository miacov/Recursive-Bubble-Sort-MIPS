# Recursive Bubble Sort Algorithm in MIPS
Using Recursive Bubble Sort to sort n integer values in ascending order in MIPS

## Algorithm Description
* Program begins at the start of the table and examines numbers in pairs
* If the number is larger than the one following, then a swap occurs
* Continuing this until the end of the table will ensure the largest number is at the end of the table
* Repeat this process recursively and each time examine one position less from the end of the table (as the largest numbers will end up at the last position examined each time)
* Process terminates when no swap occurs, as the table will now be sorted in ascending order

## Register Usage
The MIPS register usage convention is followed:
* $t registers: temporary, not preserved across procedure calls
* $s registers: saved values, preserved across procedure calls
* $a registers: parameters passed to procedures, not preserved across procedure calls
* $v registers: procedure return results, syscalls ($v0)
* $ra register: return address
* $sp register: stack pointer
* $fp register: frame pointer
