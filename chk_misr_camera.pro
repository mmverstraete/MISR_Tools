FUNCTION chk_misr_camera, misr_camera, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function checks the validity of the positional
   ;  parameter misr_camera.
   ;
   ;  ALGORITHM: This function indicates whether the value of the input
   ;  positional parameter misr_camera is one of
   ;  [’DF’, ’CF’, ’BF’, ’AF’, ’AN’, ’AA’, ’BA’, ’CA’, ’DA’].
   ;
   ;  SYNTAX: rc = chk_misr_camera(misr_camera, $
   ;  DEBUG = debug, EXCPT_COND = excp_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_camera {STRING} [I/O]: The selected MISR CAMERA name.
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
   ;      provided in the call. The input positional parameter misr_camera
   ;      is valid.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The input positional parameter misr_camera is invalid.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misr_camera is not of type
   ;      STRING.
   ;
   ;  *   Error 120: Input positional parameter misr_camera is not a
   ;      scalar.
   ;
   ;  *   Error 300: Input positional parameter misr_camera is invalid:
   ;      must be one of
   ;      [’DF’, ’CF’, ’BF’, ’AF’, ’AN’, ’AA’, ’BA’, ’CA’, ’DA’].
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_string.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The input positional parameter misr_camera is properly
   ;      capitalized on output.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_camera = 'aa'
   ;      IDL> rc = chk_misr_camera(misr_camera, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ' and excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0 and excpt_cond = ><
   ;      IDL> PRINT, 'misr_camera = ' + misr_camera
   ;      misr_camera = AA
   ;
   ;      IDL> misr_camera = 'xy'
   ;      IDL> rc = chk_misr_camera(misr_camera, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ' and excpt_cond = >' + excpt_cond + '<'
   ;      rc = 300 and excpt_cond = >Error 300 in CHK_MISR_CAMERA:
   ;      Invalid misr_camera name: must be one of
   ;      ['DF', 'CF', 'BF', 'AF', 'AN', 'AA', 'BA', 'CA', 'DA'].<
   ;      IDL> PRINT, 'misr_camera = ' + misr_camera
   ;      misr_camera = XY
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
            ' positional parameter(s): misr_camera.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misr_camera' is not of STRING type:
      IF (is_string(misr_camera) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': Input argument misr_camera must be of STRING type.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misr_camera' is not a scalar:
      IF (is_scalar(misr_camera) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': Input argument misr_camera must be a scalar.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Get the MISR camera names:
   res = set_misr_specs()
   misr_cameras = res.CameraNames
   misr_camera = STRUPCASE(misr_camera)

   ;  Check that the argument misr_camera is valid:
   idx = WHERE(misr_camera EQ misr_cameras, count)

   IF (count NE 1) THEN BEGIN
      error_code = 300

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misr_camera' is invalid:
      IF (debug) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Invalid misr_camera name: must be one of ' + $
            "['DF', 'CF', 'BF', 'AF', 'AN', 'AA', 'BA', 'CA', 'DA']."
      ENDIF
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
