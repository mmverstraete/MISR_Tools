FUNCTION is_frompath, $
   misr_path, $
   misr_orbit, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function checks that the specified MISR ORBIT does
   ;  belong to the specified PATH.
   ;
   ;  ALGORITHM: This function relies of the MISR Toolkit to determine the
   ;  correct PATH associated with the given ORBIT, and returns 1 if the
   ;  input positional parameters are consistent, or 0 otherwise.
   ;
   ;  SYNTAX: res = is_frompath(misr_path, misr_orbit, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
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
   ;      returns 1 if the input positional parameter misr_orbit does
   ;      belong to the specified misr_path, and 0 otherwise, and the
   ;      output keyword parameter excpt_cond is set to a null string, if
   ;      the optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided in the
   ;      call.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns -1, and the output keyword parameter excpt_cond contains
   ;      a message about the exception condition encountered, if the
   ;      optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_path is invalid.
   ;
   ;  *   Error 120: The input positional parameter misr_orbit is invalid.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      [Insert the command and its outcome]
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2019–03–17: Version 1.0 — Initial release.
   ;
   ;  *   2019–03–20: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2019 Michel M. Verstraete.
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
   ;      be included in its entirety in all copies or substantial
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
   return_code = -1

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_path, misr_orbit.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_path' is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Retrieve the MISR Path number for the input Orbit number:
   status = MTK_ORBIT_TO_PATH(misr_orbit, true_path)

   ;  Assess whether the input psrsmeters are consistent:
   IF (misr_path EQ true_path) THEN RETURN, 1 ELSE RETURN, 0

END
