FUNCTION chk_misr_mode, misr_mode, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function checks the validity of the positional
   ;  parameter misr_mode.
   ;
   ;  ALGORITHM: This function indicates whether the value of the input
   ;  positional parameter misr_mode is one of [’GM’, ’LM’].
   ;
   ;  SYNTAX: rc = chk_misr_mode, misr_mode, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I/O]: The MISR spectral mode name.
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
   ;      provided in the call. The input positional parameter misr_mode
   ;      is valid; upon exiting this function, misr_mode is a 2-character
   ;      upper case mode name.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns [a non-zero error code, or some non-sandard returned
   ;      value], and the output keyword parameter excpt_cond contains a
   ;      message about the exception condition encountered, if the
   ;      optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided. The
   ;      input positional parameter misr_mode may be invalid.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misr_mode is not of type
   ;      STRING.
   ;
   ;  *   Error 110: Input positional parameter misr_mode is not a scalar.
   ;
   ;  *   Error 300: Input positional parameter misr_mode is invalid.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_scalar.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The input positional parameter misr_mode is properly
   ;      capitalized on output.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_mode = ' gm '
   ;      IDL> rc = chk_misr_mode(misr_mode, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ' and excpt_cond = >' + excpt_cond + '<.'
   ;      rc = 0 and excpt_cond = ><.
   ;      IDL> PRINT, 'misr_mode = >' + misr_mode + '<.'
   ;      misr_mode = >GM<.
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–05–01: Version 0.9 — Initial release.
   ;
   ;  *   2018–05–10: Version 1.0 — Initial public release.
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

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_mode.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misr_mode' is not of STRING type:
      IF (is_string(misr_mode) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': Input argument misr_mode must be of STRING type.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misr_mode' is not a scalar:
      IF (is_scalar(misr_mode) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': Input argument misr_mode must be a scalar.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Ensure the proper capitalization of the 'misr_mode' argument:
   misr_mode = STRUPCASE(strstr(misr_mode))

   ;  Get the MISR mode names:
   res = set_misr_specs()
   misr_modes = res.ModeNames

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misr_mode' is invalid:
   idx = WHERE(misr_mode EQ misr_modes, count)

   IF (count NE 1) THEN BEGIN
      error_code = 300
      IF (debug) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ": Invalid misr_mode name: must be one of ['GM', 'LM']."
      ENDIF
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
