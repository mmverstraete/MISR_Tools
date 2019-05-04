FUNCTION pixel_corners, $
   misr_path, $
   misr_resolution, $
   misr_block, $
   misr_line, $
   misr_sample, $
   corners, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function computes the geographical coordinates
   ;  (latitude and longitude) of each of the 4 corners of an individual
   ;  MISR or MISR-HR pixel.
   ;
   ;  ALGORITHM: This function relies on the MISR TOOLKIT to compute these
   ;  coordinates.
   ;
   ;  SYNTAX: rc = pixel_corners(misr_path, misr_resolution, $
   ;  misr_block, misr_line, misr_sample, corners, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path {INT} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_resolution {INT} [I]: The selected MISR or MISR-HR spatial
   ;      resolution: either 275 or 1100 m.
   ;
   ;  *   misr_block {INT} [I]: The selected MISR BLOCK number.
   ;
   ;  *   misr_line {INT} [I]: The selected MISR line number within the
   ;      BLOCK.
   ;
   ;  *   misr_sample {INT} [I]: The selected MISR sample number within
   ;      the line.
   ;
   ;  *   corners {STRUCTURE} [O]: The structure containing the latitude
   ;      and longitude coordinates of the 4 corners of the specified
   ;      pixel.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   VERBOSE = verbose {INT} [I] (Default value: 0): Flag to enable
   ;      (> 0) or skip (0) reporting progress on the console: 1 only
   ;      reports exiting the routine; 2 reports entering and exiting the
   ;      routine, as well as key milestones; 3 reports entering and
   ;      exiting the routine, and provides detailed information on the
   ;      intermediary results.
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
   ;      provided in the call. The output structure corners contains the
   ;      desured results.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output structure corners may be undefined,
   ;      incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_path is invalid.
   ;
   ;  *   Error 120: The input positional parameter misr_resolution must
   ;      be either 275 or 1100.
   ;
   ;  *   Error 130: The input positional parameter misr_block is invalid.
   ;
   ;  *   Error 150: The input positional parameter misr_sample is
   ;      invalid.
   ;
   ;  *   Error 600: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_BLS_TO_LATLON while computing the coordinates of the
   ;      nort-west corner.
   ;
   ;  *   Error 610: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_BLS_TO_LATLON while computing the coordinates of the
   ;      nort-east corner.
   ;
   ;  *   Error 620: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_BLS_TO_LATLON while computing the coordinates of the
   ;      south-west corner.
   ;
   ;  *   Error 630: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_BLS_TO_LATLON while computing the coordinates of the
   ;      south-east corner.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path = 168
   ;      IDL> misr_resolution = 1100
   ;      IDL> misr_block = 112
   ;      IDL> misr_line = 100
   ;      IDL> misr_sample = 240
   ;      IDL> debug = 1
   ;      IDL> rc = pixel_corners(misr_path, misr_resolution, misr_block, $
   ;         misr_line, misr_sample, corners, VERBOSE = verbose, $
   ;         DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'The NW corner is at lat = ', corners.nwc_lat, $
   ;         ' and lon = ', corners.nwc_lon
   ;      The NW corner is at lat = -27.317877 and lon = 31.189198
   ;      IDL> PRINT, 'The SE corner is at lat = ', corners.sec_lat, $
   ;         ' and lon = ', corners.sec_lon
   ;      The SE corner is at lat = -27.328760 and lon = 31.199127
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2019–04–07: Version 1.0 — Initial release.
   ;
   ;  *   2019–04–08: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–05–04: Version 2.01 — Update the code to report the
   ;      specific error message of MTK routines.
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
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (verbose GT 1) THEN PRINT, 'Entering ' + rout_name + '.'

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 6
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_path, misr_resolution, ' + $
            'misr_block, misr_line, misr_sample, corners.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_path' is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_resolution' is invalid:
      IF ((misr_resolution NE 275) AND (misr_resolution NE 1100)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter misr_resolution must be ' + $
            'either 275 or 1100.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_line' is invalid or inconsistent with the
   ;  input positional parameter 'misr_resolution':
      IF ((misr_line LT 0) OR $
         ((misr_resolution EQ 275) AND (misr_line GT 512)) OR $
         ((misr_resolution EQ 1100) AND (misr_line GT 128))) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter misr_line is invalid or ' + $
            'inconsistent with the specified misr_resolution.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_sample' is invalid or inconsistent with the
   ;  input positional parameter 'misr_resolution':
      IF ((misr_sample LT 0) OR $
         ((misr_resolution EQ 275) AND (misr_sample GT 2048)) OR $
         ((misr_resolution EQ 1100) AND (misr_sample GT 512))) THEN BEGIN
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter misr_sample is invalid or ' + $
            'inconsistent with the specified misr_resolution.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Create the output structure:
   tag = 'Title'
   val = 'Coordinates of pixel corners'
   corners = CREATE_STRUCT(tag, val)

   ;  Compute the latitude and longitude coordinates of the nort-west corner:
   nwc_line = FLOAT(misr_line) - 0.5
   nwc_sample = FLOAT(misr_sample) - 0.5
   status = MTK_BLS_TO_LATLON(misr_path, misr_resolution, misr_block, $
      nwc_line, nwc_sample, nwc_lat, nwc_lon)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 600
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_BLS_TO_LATLON: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF
   corners = CREATE_STRUCT(corners, 'nwc_lat', nwc_lat)
   corners = CREATE_STRUCT(corners, 'nwc_lon', nwc_lon)

   ;  Compute the latitude and longitude coordinates of the nort-east corner:
   nec_line = FLOAT(misr_line) - 0.5
   nec_sample = FLOAT(misr_sample) + 0.5
   status = MTK_BLS_TO_LATLON(misr_path, misr_resolution, misr_block, $
      nec_line, nec_sample, nec_lat, nec_lon)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 610
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_BLS_TO_LATLON: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF
   corners = CREATE_STRUCT(corners, 'nec_lat', nec_lat)
   corners = CREATE_STRUCT(corners, 'nec_lon', nec_lon)

   ;  Compute the latitude and longitude coordinates of the south-west corner:
   swc_line = FLOAT(misr_line) + 0.5
   swc_sample = FLOAT(misr_sample) - 0.5
   status = MTK_BLS_TO_LATLON(misr_path, misr_resolution, misr_block, $
      swc_line, swc_sample, swc_lat, swc_lon)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 620
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_BLS_TO_LATLON: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF
   corners = CREATE_STRUCT(corners, 'swc_lat', swc_lat)
   corners = CREATE_STRUCT(corners, 'swc_lon', swc_lon)

   ;  Compute the latitude and longitude coordinates of the south-east corner:
   sec_line = FLOAT(misr_line) + 0.5
   sec_sample = FLOAT(misr_sample) + 0.5
   status = MTK_BLS_TO_LATLON(misr_path, misr_resolution, misr_block, $
      sec_line, sec_sample, sec_lat, sec_lon)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 630
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_BLS_TO_LATLON: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF
   corners = CREATE_STRUCT(corners, 'sec_lat', sec_lat)
   corners = CREATE_STRUCT(corners, 'sec_lon', sec_lon)

   RETURN, 0

end
