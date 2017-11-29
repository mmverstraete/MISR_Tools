FUNCTION str2block, misr_block_str, misr_block, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function converts a valid STRING representation of a
   ;  MISR BLOCK into its INT equivalent; it performs the converse
   ;  operation of function block2str.
   ;
   ;  ALGORITHM: This function checks the validity of the positional
   ;  parameter misr_block_str, provided as an STRING value and converts
   ;  the numerical component of the argument into an INT.
   ;
   ;  SYNTAX:
   ;  rc = str2block(misr_block_str, misr_block, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_block_str {STRING} [I]: The selected STRING representation
   ;      of the MISR BLOCK.
   ;
   ;  *   misr_block {INT} [O]: The required MISR BLOCK number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INTEGER.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      provides the desired result in the output argument misr_block,
   ;      returns the value 0, and the output keyword parameter excpt_cond
   ;      is set to a null string.
   ;
   ;  *   If an exception condition has been detected, the output argument
   ;      misr_block is set to 0, this function returns a non-zero error
   ;      code, and the output keyword parameter excpt_cond contains a
   ;      message about the exception condition encountered.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misr_block_str is not of
   ;      type STRING.
   ;
   ;  *   Error 120: Input positional parameter misr_block_str does not
   ;      start with the expected character P.
   ;
   ;  *   Error 130: The numerical value of input argument misr_block_str
   ;      is invalid.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   first_char.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The input argument misr_block_str is expected to be
   ;      formatted as Bzzz where zzz is the numeric value of the MISR
   ;      BLOCK, but a lower case b and the presence of blank spaces
   ;      before or after this initial character, or after the number zzz,
   ;      is tolerated. See the example below.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_block_str = ' b 111 '
   ;      IDL> rc = str2block(misr_block_str, misr_block, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ', rc, ' and excpt_cond = >' + excpt_cond + '<'
   ;      rc =        0 and excpt_cond = ><
   ;      IDL> PRINT, 'misr_block = ', misr_block
   ;      misr_block =      111
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–11–30: Version 1.0 — Initial release.
   ;
   ;
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following
   ;      conditions:
   ;
   ;      The above copyright notice and this permission notice shall be
   ;      included in all copies or substantial portions of the Software.
   ;
   ;      THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
   ;      EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
   ;      OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   ;      NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com.
   ;
   ;
   ;Sec-Cod
   ;  Initialize the return code and the error message:
   return_code = 0
   excpt_cond = ''

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
   n_reqs = 2
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameter(s): misr_block_str, misr_block.'
      misr_block = 0
      RETURN, error_code
   ENDIF

   ;  Check the validity of the input positional parameter PATH:
   IF (is_string(misr_block_str) NE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input argument misr_block_str is not a string.'
      misr_block = 0
      RETURN, error_code
   ENDIF
   misr_block_str = strstr(misr_block_str)
   IF (STRUPCASE(first_char(misr_block_str)) NE 'B') THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input argument misr_block_str is not starting with B.'
      misr_block = 0
      RETURN, error_code
   ENDIF
   misr_block = FIX(strstr(STRMID(misr_block_str, 1)))
   IF (chk_misr_block(misr_block, EXCPT_COND = excpt_cond) NE 0) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 130
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Numerical value of input argument misr_block_str is invalid.'
      misr_block = 0
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
