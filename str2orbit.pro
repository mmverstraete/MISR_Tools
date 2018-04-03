FUNCTION str2orbit, misr_orbit_str, misr_orbit, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function converts a valid STRING representation of a
   ;  MISR ORBIT into its LONG equivalent; it performs the converse
   ;  operation of function orbit2str.
   ;
   ;  ALGORITHM: This function checks the validity of the positional
   ;  parameter
   ;  misr_orbit_str, provided as an STRING value and converts the
   ;  numerical component of the argument into an LONG.
   ;
   ;  SYNTAX: rc = str2orbit(misr_orbit_str, misr_orbit, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_orbit_str {STRING} [I]: The selected STRING representation
   ;      of the MISR ORBIT.
   ;
   ;  *   misr_orbit {LONG} [O]: The required MISR ORBIT number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
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
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. The output positional parameter misr_orbit
   ;      contains the ORBIT number.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter misr_orbit is set to
   ;      0.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misr_orbit_str is not of
   ;      type STRING.
   ;
   ;  *   Error 120: Input positional parameter misr_orbit_str does not
   ;      start with the expected character P.
   ;
   ;  *   Error 130: The numerical value of input argument misr_orbit_str
   ;      is invalid.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   first_char.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The input argument misr_orbit_str is expected to be
   ;      formatted as Oyyyyyy where yyyyyy is the numeric value of the
   ;      MISR ORBIT, but a lower case o and the presence of blank spaces
   ;      before or after this initial character, or after the number
   ;      yyyyyy, is tolerated. See the example below.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_orbit_str = ' o 68050 '
   ;      IDL> rc = str2orbit(misr_orbit_str, misr_orbit, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ', rc, ' and excpt_cond = >' + excpt_cond + '<'
   ;      rc =        0 and excpt_cond = ><
   ;      IDL> PRINT, 'misr_orbit = ', misr_orbit
   ;      misr_orbit =        68050
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–11–15: Version 0.9 — Initial release.
   ;
   ;  *   2017–11–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–16: Version 1.1 — Implement optional debugging.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2018 Michel M. Verstraete.
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
   ;Sec-Cod
   ;  Initialize the default return code and the exception condition message:
   return_code = 0
   IF KEYWORD_SET(debug) THEN BEGIN
      debug = 1
   ENDIF ELSE BEGIN
      debug = 0
   ENDELSE
   excpt_cond = ''

   ;  Initialize the output positional parameters to invalid values:
   misr_orbit = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_orbit_str, misr_orbit.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with an invalid misr_orbit_str:
      IF (is_string(misr_orbit_str) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input argument misr_orbit_str is not a string.'
         RETURN, error_code
      ENDIF
   ENDIF

   misr_orbit_str = strstr(misr_orbit_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)

   IF (debug) THEN BEGIN

      IF (STRUPCASE(first_char(misr_orbit_str)) NE 'O') THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input argument misr_orbit_str is not starting with O.'
         misr_orbit = 0
         RETURN, error_code
      ENDIF
   ENDIF

   misr_orbit = LONG(strstr(STRMID(misr_orbit_str, 1), $
      DEBUG = debug, EXCPT_COND = excpt_cond))

   IF (debug) THEN BEGIN

      IF (chk_misr_orbit(misr_orbit, DEBUG = debug, $
         EXCPT_COND = excpt_cond) NE 0) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Numerical value of input argument misr_orbit_str is invalid.'
         misr_orbit = 0
         RETURN, error_code
      ENDIF
   ENDIF

   RETURN, return_code

END
