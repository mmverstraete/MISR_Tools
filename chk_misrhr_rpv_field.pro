FUNCTION chk_misrhr_rpv_field, misrhr_rpv_field, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function checks the validity of the positional
   ;  parameter
   ;  misrhr_rpv_field.
   ;
   ;  ALGORITHM: This function indicates whether the value of the input
   ;  positional parameter misrhr_rpv_field is one of
   ;  [’Rho’, ’k’, ’Theta’, ’Rhoc’, ’Cost’, ’Sigmas_Rho’, ’Sigmas_k’, ’Sigmas_Theta’].
   ;
   ;  SYNTAX: rc = chk_misrhr_rpv_field(misrhr_rpv_field, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misrhr_rpv_field {STRING} [I/O]: The selected MISR-HR RPV field
   ;      name.
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
   ;      provided in the call. The input positional parameter
   ;      misrhr_rpv_field is valid.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The input positional parameter misrhr_rpv_field is
   ;      invalid.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misrhr_rpv_field is not of
   ;      type STRING.
   ;
   ;  *   Error 300: The input positional parameter misrhr_rpv_field is
   ;      invalid.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Upon returning from this function, the value of the
   ;      input positional parameter misrhr_rpv_field is properly
   ;      capitalized.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misrhr_rpv_field = 'k'
   ;      IDL> rc = chk_misrhr_rpv_field(misrhr_rpv_field, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ', excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;
   ;      IDL> misrhr_rpv_field = 'FAPAR'
   ;      IDL> rc = chk_misrhr_rpv_field(misrhr_rpv_field, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ', excpt_cond = >' + excpt_cond + '<'
   ;      rc = 300, excpt_cond = >Error 300 in CHK_MISRHR_RPV_FIELD:
   ;         Invalid misrhr_rpv_field name.<
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–01–20: Version 0.9 — Initial release.
   ;
   ;  *   2018–02–20: Version 1.0 — Initial public release.
   ;
   ;  *   2018–05–28: Version 1.1 — Add logic to properly capitalize the
   ;      input positional parameter misrhr_rpv_field, recognize 3
   ;      different Sigmas types, and documentation update.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
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

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code and the exception condition message:
   return_code = 0
   excpt_cond = ''

   ;  Set the default values of essential input keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misrhr_rpv_field.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misrhr_rpv_field' is not of string type:
      IF (is_string(misrhr_rpv_field) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input argument misrhr_rpv_field must be of string type.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Ensure the variable 'misrhr_rpv_field' does not include heading or
   ;  trailing spaces:
   misrhr_rpv_field = strstr(misrhr_rpv_field)

   ;  Ensure the proper capitalization of the input argument:
   misrhr_rpv_field = misrhr_rpv_field.ToLower()
   misrhr_rpv_field = misrhr_rpv_field.CapWords('_')
   IF (misrhr_rpv_field EQ 'K') THEN misrhr_rpv_field = 'k'
   IF (misrhr_rpv_field EQ 'Sigmas_K') THEN misrhr_rpv_field = 'Sigmas_k'

   ;  Define the valid values of misrhr_rpv_field:
   misrhr_rpv_fields = ['Rho', 'k', 'Theta', 'Rhoc', 'Cost', $
      'Sigmas_Rho', 'Sigmas_k', 'Sigmas_Theta']

   ;  Check that the argument misrhr_rpv_field is valid:
   idx = WHERE(misrhr_rpv_field EQ misrhr_rpv_fields, count)

   IF (count NE 1) THEN BEGIN
      error_code = 300

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misrhr_rpv_field' is invalid:
      IF (debug) THEN BEGIN
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Invalid misrhr_rpv_field name.'
      ENDIF
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
