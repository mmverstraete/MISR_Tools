FUNCTION chk_misrhr_tip_field, misrhr_tip_field, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function checks the validity of the positional
   ;  parameter misrhr_tip_field.
   ;
   ;  ALGORITHM: This function indicates whether the value of the input
   ;  positional parameter misrhr_tip_field is one of
   ;  [’EffLAI’, ’EffSSA_VIS’, ’EffAsym_VIS’, ’TrueBkgdAlbedo_VIS’, ’EffSSA_NIR’, ’EffAsym_NIR’, ’TrueBkgdAlbedo_NIR’, ’Cost’, ’BHR_VIS’, ’BHR_NIR’, ’ABS_VIS’, ’ABS_NIR’, ’TRN_VIS’, ’TRN_NIR’, ’StdDevParams’, ’ObsCovarFluxes’, ’PriorBHR_Spectral’, ’PriorBHR_VIS’, ’PriorBHR_NIR’, ’Uncert’, ’Green’, ’SnowFlag’, ’SnowSolution’].
   ;
   ;  SYNTAX: rc = chk_misrhr_tip_field(misrhr_tip_field, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misrhr_tip_field {STRING} [I/O]: The selected MISR-HR TIP field
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
   ;      misrhr_tip_field is valid.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The input positional parameter misrhr_tip_field is
   ;      invalid.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misrhr_tip_field is not of
   ;      type STRING.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function...
   ;
   ;  EXAMPLES:
   ;
   ;      [Insert the command and its outcome]
   ;
   ;  REFERENCES:
   ;
   ;  *   -   Paper and DOI
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–01–20: Version 0.9 — Initial release.
   ;
   ;  *   2018–02–20: Version 1.0 — Initial public release.
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
   ;  Initialize the default return code and the exception condition message:
   return_code = 0
   IF KEYWORD_SET(debug) THEN BEGIN
      debug = 1
   ENDIF ELSE BEGIN
      debug = 0
   ENDELSE
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misrhr_tip_field.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misrhr_tip_field' is not of string type:
      IF (is_string(misrhr_tip_field) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input argument misrhr_tip_field must be of string type.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Ensure the variable 'misrhr_tip_field' does not include heading or
   ;  trailing spaces:
   misrhr_tip_field = strstr(misrhr_tip_field)

   ;  Define the valid values of misrhr_tip_field:
   misrhr_tip_fields = ['EffLAI', 'EffSSA_VIS', 'EffAsym_VIS', $
      'TrueBkgdAlbedo_VIS', 'EffSSA_NIR', 'EffAsym_NIR', $
      'TrueBkgdAlbedo_NIR', 'Cost', 'BHR_VIS', 'BHR_NIR', $
      'ABS_VIS', 'ABS_NIR', 'TRN_VIS', 'TRN_NIR', 'StdDevParams', $
      'ObsCovarFluxes', 'PriorBHR_Spectral', 'PriorBHR_VIS', $
      'PriorBHR_NIR', 'Uncert', 'Green', 'SnowFlag', 'SnowSolution']

   ;  Check that the argument misrhr_tip_field is valid:
   idx = WHERE(misrhr_tip_field EQ misrhr_tip_fields, count)

   IF (count NE 1) THEN BEGIN
      error_code = 300

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misrhr_tip_field' is invalid:
      IF (debug) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Invalid misrhr_tip_field name.'
      ENDIF
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
