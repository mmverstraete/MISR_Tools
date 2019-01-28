FUNCTION orbit2str, $
   misr_orbit, $
   misr_orbit_str, $
   NOHEADER = noheader, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function converts a valid MISR ORBIT number into a
   ;  properly formatted STRING, with or without the O header.
   ;
   ;  ALGORITHM: This function converts the input positional parameter
   ;  misr_orbit, provided as an LONG value, into a zero-padded STRING
   ;  formatted as Oyyyyyy (by default), or as yyyyyy if the optional
   ;  input keyword parameter NOHEADER is set.
   ;
   ;  SYNTAX: rc = orbit2str(misr_orbit, misr_orbit_str, $
   ;  NOHEADER = noheader, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_orbit_str {STRING} [O]: A STRING representation of the MISR
   ;      ORBIT with or without the O header, depending on the input
   ;      keyword parameter NOHEADER.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   NOHEADER = noheader{INT} [I] (Default value: 0): Flag to avoid
   ;      (1) or add (0) the header O to the ouput positional parameter
   ;      misr_orbit_str.
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
   ;      provided in the call. The output positional parameter
   ;      misr_orbit_str contains the string version of the ORBIT, with or
   ;      without the O header.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter misr_orbit_str is set
   ;      to a null STRING.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misr_orbit is invalid.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: A STRING value for the input positional argument
   ;      misr_orbit is tolerated and results in correct output positional
   ;      argument misr_orbit_str if the input keyword parameter DEBUG is
   ;      NOT set, but an error message is issued if this keyword is set,
   ;      because this situation likely corresponds to an unintentional
   ;      incorrect user call (see the last example below).
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_orbit = 68050
   ;      IDL> rc = orbit2str(misr_orbit, misr_orbit_s, misr_orbit_str, $
   ;         DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ', rc, ' and excpt_cond = >' + excpt_cond + '<'
   ;      rc =        0 and excpt_cond = ><
   ;      IDL> PRINT, 'misr_orbit_s = >' + misr_orbit_s + '<'
   ;      misr_orbit_s = >068050<
   ;      IDL> PRINT, 'misr_orbit_str = >' + misr_orbit_str + '<'
   ;      misr_orbit_str = >O068050<
   ;
   ;      IDL> misr_orbit = '65487'
   ;      IDL> rc = orbit2str(misr_orbit, misr_orbit_s, misr_orbit_str)
   ;      IDL> PRINT, 'rc = ' + strstr(rc)
   ;      rc = 0
   ;      IDL> PRINT, 'misr_orbit_s = >' + misr_orbit_s + '<'
   ;      misr_orbit_s = >065487<
   ;      IDL> PRINT, 'misr_orbit_str = >' + misr_orbit_str + '<'
   ;      misr_orbit_str = >B065487<
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
   return_code = 0

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(noheader)) THEN noheader = 1 ELSE noheader = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Initialize the output positional parameter(s):
   misr_orbit_str = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_orbit, misr_orbit_str.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter misr_orbit is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Generate the string version of the MISR Orbit:
   mo = STRTRIM(STRING(misr_orbit, FORMAT = '(I06)'), 2)
   IF (noheader) THEN misr_orbit_str = mo ELSE misr_orbit_str = 'O' + mo

   RETURN, return_code

END
