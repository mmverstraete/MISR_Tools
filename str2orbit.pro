FUNCTION str2orbit, $
   misr_orbit_str, $
   misr_orbit, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function converts a valid STRING representation of a
   ;  MISR ORBIT, with or without the O header, into its LONG equivalent;
   ;  it performs the converse operation of function orbit2str.
   ;
   ;  ALGORITHM: This function checks the validity of the input positional
   ;  parameter
   ;  misr_orbit_str, provided as an STRING value, removes the B header if
   ;  it is present, and converts remaining string to a LONG integer.
   ;
   ;  SYNTAX: rc = str2orbit(misr_orbit_str, misr_orbit, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_orbit_str {STRING} [I]: The selected STRING representation
   ;      of the MISR ORBIT, with or without the O header.
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
   ;  RETURNED VALUE TYPE: INT.
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
   ;  *   Error 200: The numerical value of input positional parameter
   ;      misr_orbit_str is invalid.
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
   ;  *   NOTE 1: The input positional parameter misr_orbit_str is
   ;      expected to be a STRING formatted as Oyyyyyy or oyyyyyy or
   ;      yyyyyy, where yyyyyy is the numeric value of the MISR ORBIT.
   ;
   ;  *   NOTE 2: The presence of blank spaces before or after the
   ;      character O, or after the number yyyyyy, is tolerated. See the
   ;      example below.
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
   ;
   ;  *   2018–04–24: Version 1.2 — Improve debugging diagnostic.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–02–25: Version 2.01 — Bug fix: Preserve input argument.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the assignment
   ;      of numeric return codes), and switch to 3-parts version
   ;      identifiers.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2020 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following three
   ;      conditions:
   ;
   ;      1. The above copyright notice and this permission notice shall
   ;      be included in their entirety in all copies or substantial
   ;      portions of the Software.
   ;
   ;      2. THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY
   ;      KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
   ;      WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
   ;      AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;      3. The current version of this Software is freely available from
   ;
   ;      https://github.com/mmverstraete.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com
   ;Sec-Cod

   COMPILE_OPT idl2, HIDDEN

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code:
   return_code = 0

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Initialize the output positional parameter(s):
   misr_orbit = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_orbit_str, misr_orbit.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter misr_orbit_str is not of type string:
      IF (is_string(misr_orbit_str) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter misr_orbit_str is not a string.'
         RETURN, error_code
      ENDIF
   ENDIF

   misr_orbit_str = strstr(misr_orbit_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)

   ;  Remove the 'O' header if it is present:
   fc = first_char(misr_orbit_str)
   IF ((fc EQ 'o') OR (fc EQ 'O')) THEN BEGIN
      misr_orbit_s = STRMID(misr_orbit_str, 1)
   ENDIF ELSE BEGIN
      misr_orbit_s = misr_orbit_str
   ENDELSE

   misr_orbit = LONG(strstr(misr_orbit_s))

   IF (debug) THEN BEGIN
      IF (chk_misr_orbit(misr_orbit, DEBUG = debug, $
         EXCPT_COND = excpt_cond) NE 0) THEN BEGIN
         error_code = 200
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Numerical value of input positional parameter ' + $
            'misr_orbit_str is invalid.'
         misr_orbit = 0
         RETURN, error_code
      ENDIF
   ENDIF

   RETURN, return_code

END
