FUNCTION chk_misr_orbit, $
   misr_orbit, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function checks the validity of the input positional
   ;  parameter misr_orbit.
   ;
   ;  ALGORITHM: This function indicates whether the value of the input
   ;  positional parameter misr_orbit is within [995L, 200000L].
   ;
   ;  SYNTAX: rc = chk_misr_orbit(misr_orbit, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_orbit {LONG} [I/O]: The selected MISR ORBIT number.
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
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. Upon exiting this function, the I/O
   ;      positional parameter misr_orbit is a valid ORBIT number.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The input positional parameter misr_orbit is invalid.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misr_orbit is not of type
   ;      numeric.
   ;
   ;  *   Error 120: Input positional parameter misr_orbit is not a
   ;      scalar.
   ;
   ;  *   Error 200: Input positional parameter misr_orbit is invalid:
   ;      must be within [995L, 200000L].
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_scalar.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Since the purpose of this function is to check the
   ;      validity of the input positional parameter misr_orbit, all tests
   ;      are performed irrespective of the setting of the input keyword
   ;      parameter DEBUG. The keywords DEBUG and EXCPT_COND are included
   ;      for consistency, and to allow reporting of the exception
   ;      condition if one is encountered.
   ;
   ;  *   NOTE 2: The input positional parameter misr_orbit is recast as
   ;      type LONG on output.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = chk_misr_orbit(68050L, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + $
   ;         ', excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;
   ;      IDL> rc = chk_misr_orbit(100L, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + $
   ;         ', excpt_cond = >' + excpt_cond + '<'
   ;      rc = 200, excpt_cond = >Error 200 in CHK_MISR_ORBIT:
   ;      Invalid misr_orbit number: must be within [995L, 112000L].<
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
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
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

   ;  Implement all tests: See Note 1 above.

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
   n_reqs = 1
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameter(s): misr_orbit.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is not of numeric type:
   IF (is_numeric(misr_orbit) NE 1) THEN BEGIN
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
         rout_name + ': Input positional parameter misr_orbit must be of numeric type.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is not a scalar:
   IF (is_scalar(misr_orbit) NE 1) THEN BEGIN
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
         rout_name + ': Input positional parameter misr_orbit must be a scalar.'
      RETURN, error_code
   ENDIF

   ;  Ensure the variable 'misr_orbit' is of INT type:
   misr_orbit = LONG(misr_orbit)

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misr_orbit' is invalid (the first Orbit which contains data
   ;  is 995, acquired on 24 February 2000, and the upper limit is currently
   ;  set to Orbit 200,000, scheduled to be acquired on 25 July 2037):
   IF ((misr_orbit LT 995L) OR (misr_orbit GT 200000L)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Invalid misr_orbit number: must be within [995L, 200000L].'
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
