FUNCTION nearest_pixel, $
   misr_path, $
   lat_sit, $
   lon_sit, $
   resolution, $
   misr_block, $
   misr_line, $
   misr_sample, $
   lat_pix, $
   lon_pix, $
   distance, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function computes the latitude and longitude of the
   ;  center of the MISR or MISR-HR pixel closest to the latitude and
   ;  longitude of a site of interest, within the specified misr_path.
   ;
   ;  ALGORITHM: This function (1) relies on the MISR TOOLKIT functions to
   ;  convert the latitude and longitude of a site of interest, provided
   ;  as the input positional parameters lat_sit and lon_sit (in decimal
   ;  degrees) into fractional line and sample coordinates of a MISR pixel
   ;  (resolution of 1100) or of a MISR-HR pixel (resolution of 275), (2)
   ;  rounds these off, and (3) relies again on the MISR TOOLKIT functions
   ;  to compute the latitude and longitude of the center of that pixel.
   ;  It also reports the distance (on a horizontal plane) between the
   ;  site of interest and the center of this closest pixel, using the
   ;  haversine formula and a mean Earth radius of 6,371 km.
   ;
   ;  SYNTAX: rc = nearest_pixel(misr_path, lat_sit, lon_sit, $
   ;  resolution, misr_block, misr_line, misr_sample, $
   ;  lat_pix, lon_pix, distance, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   lat_sit {DOUBLE} [I]: The latitude of the site of interest, in
   ;      decimal degrees.
   ;
   ;  *   lon_sit {DOUBLE} [I]: The longitude of the site of interest, in
   ;      decimal degrees.
   ;
   ;  *   resolution {INT} [I]: The spatial resolution of the remote
   ;      sensing data product: either 1100 (for the Global Mode non-red
   ;      spectral channels of the off-nadir MISR cameras) or 275 (for the
   ;      Global Mode red spectral channels of the off-nadir MISR cameras,
   ;      or the 4 spectral bands of the nadir camera, or for any data
   ;      channel in Local Mode, or for any MISR-HR data product).
   ;
   ;  *   misr_block {INTEGER} [O]: The MISR BLOCK number in which the
   ;      site of interest resides.
   ;
   ;  *   misr_line {INTEGER} [O]: The line number of the pixel in the
   ;      BLOCK.
   ;
   ;  *   misr_sample {INTEGER} [O]: The sample number of the pixel in the
   ;      line.
   ;
   ;  *   lat_pix {DOUBLE} [O]: The latitude of the center of the pixel
   ;      closest to the site of interest, in decimal degrees, within the
   ;      range [-90.0, 90.0].
   ;
   ;  *   lon_pix {DOUBLE} [O]: The longitude of the center of the pixel
   ;      closest to the site of interest, in decimal degrees, within the
   ;      range [-180.0, 180.0].
   ;
   ;  *   distance {DOUBLE} [O]: The distance between the site of interest
   ;      and the center of the closest pixel.
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
   ;      provided in the call. The coordinates of the center of the
   ;      closest pixel, as well as the distance between that location and
   ;      the site of interest are provided in output positional
   ;      parameters.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The coordinates of the center of the closest pixel, as
   ;      well as the distance between that location and the site of
   ;      interest may be undefined, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_path is invalid.
   ;
   ;  *   Error 120: The input positional parameter lat_sit is is not of
   ;      type FLOAT or DOUBLE.
   ;
   ;  *   Error 122: The input positional parameter lat_sit is invalid.
   ;
   ;  *   Error 130: The input positional parameter lon_sit is is not of
   ;      type FLOAT or DOUBLE.
   ;
   ;  *   Error 132: The input positional parameter lon_sit is invalid.
   ;
   ;  *   Error 140: The input positional parameter resolution is is not
   ;      of type INT.
   ;
   ;  *   Error 142: The input positional parameter resolution is is
   ;      invalid.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      haversine.pro.
   ;
   ;  *   Error 600: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_LATLON_TO_BLS.
   ;
   ;  *   Error 610: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_BLS_TO_LATLON.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   haversine.pro
   ;
   ;  *   is_double.pro
   ;
   ;  *   is_float.pro
   ;
   ;  *   is_integer.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path = 168
   ;      IDL> lat_sit = -27.34439555
   ;      IDL> lon_sit = 30.13553714
   ;      IDL> lat_sit = -27.34439555D
   ;      IDL> lon_sit = 30.13553714D
   ;      IDL> resolution = 275
   ;      IDL> rc = nearest_pixel(misr_path, lat_sit, lon_sit, resolution, $
   ;         misr_block, lat_pix, lon_pix, distance)
   ;      IDL> PRINT, 'distance = ' + strstr(distance)
   ;      distance = 132.22869
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2019–04–06: Version 1.0 — Initial release.
   ;
   ;  *   2019–04–06: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–04–12: Version 2.01 — Add the misr_line and misr_sample
   ;      output positional parameters.
   ;
   ;  *   2019–05–04: Version 2.02 — Update the code to report the
   ;      specific error message of MTK routines.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the assignment
   ;      of numeric return codes), and switch to 3-parts version
   ;      identifiers.
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
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 10
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_path, lat_sit, lon_sit, ' + $
            'resolution, misr_block, misr_line, misr_sample, lat_pix, ' + $
            'lon_pix, distance.'
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
   ;  positional parameter 'lat_sit' is not of type FLOAT or DOUBLE:
      res1 = is_float(lat_sit)
      res2 = is_double(lat_sit)
      IF ((res1 NE 1) AND (res2 NE 1)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lat_sit is not a FLOAT or a ' + $
            'DOUBLE variable.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lat_sit' is invalid:
      IF ((lat_sit LT -90.0) OR (lat_sit GT 90.0)) THEN BEGIN
         error_code = 122
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lat_sit is invalid.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lon_sit' is not of type FLOAT or DOUBLE:
      res1 = is_float(lon_sit)
      res2 = is_double(lon_sit)
      IF ((res1 NE 1) AND (res2 NE 1)) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lon_sit is not a FLOAT or a ' + $
            'DOUBLE variable.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lon_sit' is invalid:
      IF ((lon_sit LT -180.0) OR (lon_sit GT 180.0)) THEN BEGIN
         error_code = 132
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lon_sit is invalid.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'resolution' is not an integer:
      res = is_integer(resolution)
      IF (res NE 1) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter resolution is not an INTEGER ' + $
            'variable.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'resolution' is invalid:
      IF ((resolution NE 275) AND (resolution NE 1100)) THEN BEGIN
         error_code = 142
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter resolution is not set to ' + $
            'either 275 or 1100.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Ensure that the latitude and longitude are set in DOUBLE precision:
   lat_sit = DOUBLE(lat_sit)
   lon_sit = DOUBLE(lon_sit)

   ;  Compute the fractional line and sample coordinates of the site of
   ;  interest in the specified MISR Path:
   status = MTK_LATLON_TO_BLS(misr_path, resolution, lat_sit, lon_sit, $
      misr_block, misr_line, misr_sample)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 600
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_LATLON_TO_BLS: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF

   ;  Round these MISR line and sample numbers to identify the center of the
   ;  closest MISR or MISR-HR pixel:
   misr_line = ROUND(misr_line)
   misr_sample = ROUND(misr_sample)

   ;  Compute the latitude and longitude of this pixel center:
   status = MTK_BLS_TO_LATLON(misr_path, resolution, misr_block, $
      misr_line, misr_sample, lat, lon)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 610
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_BLS_TO_LATLON: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF

   lat_pix = DOUBLE(lat)
   lon_pix = DOUBLE(lon)

   ;  Compute the haversine distance between the site of interest and the
   ;  pixel center:
   rc = haversine(lat_sit, lon_sit, lat_pix, lon_pix, $
      distance, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
