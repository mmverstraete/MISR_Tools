FUNCTION hr2lr, $
   inarray, $
   innature, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function downsizes the high spatial resolution
   ;  (2048 × 512) input positional parameter inarray by a factor 4 in
   ;  each dimension, to the reduced spatial resolution (512 × 128) output
   ;  array, and returns the latter to the calling routine. The algorithm
   ;  used depends on the value of input positional parameter innature.
   ;
   ;  ALGORITHM: If the input positional parameter inarray contains
   ;  radiance or reflectance data at the full (native) spatial resolution
   ;  of the MISR instrument, this function simulates the averaging taking
   ;  place on-board the Terra platform for the 24 non-red data channels
   ;  of the Global Mode off-nadir cameras. This function can also be used
   ;  to downsize other arrays, such as RDQI or land cover masks. The
   ;  downscaling algorithm analyzes successive, non-overlapping
   ;  subwindows of 4 × 4 pixels in the input array. If this subwindow is
   ;  identified as
   ;  subarray = inarray[ii:ii + 3, jj:jj + 3]
   ;  where ii and jj are the indices in the input high spatial resolution
   ;  array, then the corresponding value in the output low spatial
   ;  resolution array is set as follows, depending on the value of the
   ;  input positional parameter innature:
   ;
   ;  *   If innature = ’RDQI’ and the input array inarray is of type
   ;      BYTE, the algorithm assumes that it contains RDQI data, where
   ;      values range within [0B, 3B]. The RDQI values of the low
   ;      resolution output array are set to the LARGEST RDQI value found
   ;      among the 16 samples of each subwindow:
   ;      outarray[i, j] = MAX(subarray).
   ;
   ;  *   If innature = ’Mask’ and the input array inarray is of type
   ;      BYTE, the algorithm assumes that it contains a land, water and
   ;      cloud mask, where values range within [1B, 254B], and where
   ;      usable values are within [1B, 3B]. The mask values of the low
   ;      resolution output array are set to the MOST FREQUENT usable
   ;      value found among the 16 samples of each subwindow, unless there
   ;      are more obscured or edge values than usable values. If two mask
   ;      categories contain the same largest number of values, the one
   ;      with the greatest value prevails.
   ;
   ;  *   If innature = ’Radrd’ and the input array inarray is of type
   ;      UINT, the algorithm assumes that it contains L1B2 SCALED
   ;      RADIANCE data, with the RDQI attached, where values range within
   ;      [0U, 65535U], and where usable values are within ]0U, 65507U].
   ;      The SCALED RADIANCE values of the low resolution output array
   ;      are set to the MEAN VALUE of the usable (non-zero) SCALED
   ;      RADIANCEs (without the RDQI attached) found among the 16 samples
   ;      of each subwindow:
   ;      outarray[i, j] = MEAN(subarray[good]), where subarray[good]
   ;      stands for the usable values in the subwindow, with the maximum
   ;      RDQI value attached. If all values of the subwindow are
   ;      unusable, the low resolution output array value is set to the
   ;      largest UINT found within that subwindow.
   ;
   ;  *   If innature = ’Rad’ and the input array inarray is of type
   ;      FLOAT, the algorithm assumes that it contains UNSCALED RADIANCE
   ;      data, which can only take on usable values within the range
   ;      ]0.0, 800.0] [Wm^( − 2)sr^( − 1)μm^( − 1)]. The UNSCALED
   ;      RADIANCE values of the low resolution output array are set to
   ;      the MEAN VALUE of the usable (non-zero) UNSCALED RADIANCEs found
   ;      among the 16 samples of each subwindow:
   ;      outarray[i, j] = MEAN(subarray[good]), where subarray[good]
   ;      stands for the usable values in the subwindow. If all values of
   ;      the subwindow are unusable, the low resolution output array
   ;      value is set to 0.0.
   ;
   ;  *   If innature = ’Brf’ and the input array inarray is of type
   ;      FLOAT, the algorithm assumes that it contains L1B2 Bidirectional
   ;      reflectance factor (BRF) data, which can only take on usable
   ;      values within the range ]0.0, 2.0]. The BRF values of the low
   ;      resolution output array are set to the MEAN VALUE of the usable
   ;      (non-zero) BRFs found among the 16 samples of each subwindow:
   ;      outarray[i, j] = MEAN(subarray[good]), where subarray[good]
   ;      stands for the usable values in the subwindow. If all values of
   ;      the subwindow are unusable, the low resolution output array
   ;      value is set to 0.0.
   ;
   ;  SYNTAX: outarray = hr2lr(inarray, innature = innature, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   inarray {UINT or FLOAT} [I]: An array of 2048 × 512 elements,
   ;      presumably containing data from a MISR L1B2 high spatial
   ;      resolution field.
   ;
   ;  *   innature {STRING} [I] (Default value: None): Indicator of the
   ;      nature and expected value range of the input array inarray:
   ;
   ;      -   If innature = ’RDQI’, usable values of the input array
   ;          inarray are expected to range between 0B and 3B; the
   ;          corresponding values of outarray depends on the LARGEST
   ;          VALUE found in each subwindow.
   ;
   ;      -   If innature = ’Mask’, usable values of the input array
   ;          inarray are expected to range between 1B and 3B; the
   ;          corresponding values of outarray depends on the MOST
   ;          FREQUENT VALUE found in each subwindow.
   ;
   ;      -   If innature = ’Radrd’, usable values of the input array
   ;          inarray are expected to range between 0U and 65506U; the
   ;          corresponding values of outarray depends on the AVERAGE
   ;          USABLE VALUE (after removing the RDQI) found in each
   ;          subwindow, with the maximum RDQI value mong the usable
   ;          values.
   ;
   ;      -   If innature = ’Rad’, usable values of the input array
   ;          inarray are expected to range between 0.0 and 800.0; the
   ;          corresponding values of outarray depends on the AVERAGE
   ;          USABLE VALUE found in each subwindow.
   ;
   ;      -   If innature = ’Brf’, usable values of the input array
   ;          inarray are expected to range between 0.0 and 2.0; the
   ;          corresponding values of outarray depends on the AVERAGE
   ;          USABLE VALUE found in each subwindow.
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
   ;  RETURNED VALUE TYPE: A numeric array, dimensioned 512 × 128, if the
   ;  processing was successful, or an INT (error code) otherwise.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns a numeric array of the same type as inarray and
   ;      dimensioned 512 × 128 elements, where the value of each element
   ;      is defined as described above. The output keyword parameter
   ;      excpt_cond is set to a null string, if the optional input
   ;      keyword parameter DEBUG was set and if the optional output
   ;      keyword parameter EXCPT_COND was provided in the call.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter inarray is not an array of type
   ;      BYTE, UINT, or FLOAT.
   ;
   ;  *   Error 120: Argument innature is not a scalar of type STRING.
   ;
   ;  *   Error 130: Argument innature is not recognized: must be RDQI,
   ;      Mask, Rad, Brf or Radrd.
   ;
   ;  *   Error 140: Arguments inarray and innature are incompatible.
   ;
   ;  *   Error 200: Positional parameter inarray is not properly
   ;      dimensioned: must be 2048 × 512.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_array.pro
   ;
   ;  *   is_byte.pro
   ;
   ;  *   is_float.pro
   ;
   ;  *   is_scalar.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   is_uint.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function is specifically designed to handle MISR
   ;      L1B2 scaled and unscaled RADIANCE, as well as BRF data arrays,
   ;      as well as RDQI and land cover masks.
   ;
   ;  *   NOTE 2: Since this function averages up to 16 original values to
   ;      estimate 1 low resolution value, it reduces the information
   ;      content of the original file. Contrast this with the function
   ;      lr2hr.pro, which appears to implement the reverse
   ;      transformation, but only duplicates values. Hence
   ;      lr2hr(hr2lr(hr_array)) is generally not equivalent to hr_array.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> inarray = FLTARR(2048, 512)
   ;      IDL> outarray = hr2lr(inarray, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> HELP, outarray
   ;      OUTARRAY        FLOAT     = Array[512, 128]
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2012–11–22: Version 0.5 — Initial release by Linda Hunt (as
   ;      downsize_fullres).
   ;
   ;  *   2017–07–17: Version 0.9 — Changed the function name to hr2lr,
   ;      removed arguments factor (fixed, in this context) and maxgood
   ;      (not used), added code to handle cases when WHERE returns -1),
   ;      added tests and in-line documentation.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–05–13: Version 1.1 — In-line documentation update.
   ;
   ;  *   2018–05–18: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–12–20: Version 1.6 — Correct a bug in the computation of
   ;      indices that resulted in incorrect values in the last column and
   ;      last line of the lower resolution array, add code to adjust
   ;      processing as a function of the input array data type, and
   ;      update the documentation.
   ;
   ;  *   2019–01–24: Version 1.7 — Update the code to also handle input
   ;      arrays of type BYTE.
   ;
   ;  *   2019–03–01: Version 2.00 — Update the code to also handle input
   ;      arrays of type UINT; systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–08–20: Version 2.1.1 — Update the code to handle land,
   ;      water and cloud BYTE masks differently from RDQI.
   ;
   ;  *   2019–09–27: Version 2.1.2 — Add the input positional parameter
   ;      innature and update the code to explicitly process input arrays
   ;      containing RDQI, MASK, RADRD, RAD or BRF data with specific
   ;      dedicated algorithms. The code segment dedicated to scaled
   ;      radiances without the RDQI attached is deleted because it is
   ;      never used.
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

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: inarray, innature.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'inarray' is not of an array of type BYTE, UINT or FLOAT:
      IF ((is_array(inarray) NE 1) OR $
         (is_byte(inarray) NE 1) AND $
         (is_uint(inarray) NE 1) AND $
         (is_float(inarray) NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument inarray is not an array of type BYTE, UINT, or FLOAT.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'innature' is not a scalar of type STRING:
      IF ((is_scalar(innature) NE 1) OR (is_string(innature) NE 1)) THEN $
         BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument innature is not a scalar of type STRING.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the value of the
   ;  argument 'innature' is not recognized:
      IF ((innature NE 'RDQI') AND (innature NE 'Mask') AND $
         (innature NE 'Radrd') AND (innature NE 'Rad') AND $
         (innature NE 'Brf')) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument innature is not recognized: it must be either ' + $
            'RDQI, Mask, Radrd, Rad or Brf.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the type of
   ;  argument 'inarray' is incompatible with the argument 'innature':
      IF (((innature EQ 'RDQI') AND (is_byte(inarray) NE 1)) OR $
         ((innature EQ 'Mask') AND (is_byte(inarray) NE 1)) OR $
         ((innature EQ 'Radrd') AND (is_uint(inarray) NE 1)) OR $
         ((innature EQ 'Rad') AND (is_float(inarray) NE 1)) OR $
         ((innature EQ 'Brf') AND (is_float(inarray) NE 1))) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Arguments inarray and innature are incompatible.'
      ENDIF
   ENDIF

   sz = SIZE(inarray, /STRUCTURE)
   input_type = sz.type
   xdim = sz.dimensions[0]
   ydim = sz.dimensions[1]

   ;  Return to the calling routine with an error message if the argument
   ;  'inarray' is not properly dimensioned:
   IF (debug AND ((xdim NE 2048) OR (ydim NE 512))) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument inarray is not properly dimensioned: ' + $
         'must be [2048 x 512].'
      RETURN, return_code
   ENDIF

   ;  Set the expected maximum usable value within the input L1B2 array as a
   ;  function of the nature of the array. This 'max_usable' value is set to
   ;  the largest usable value expected to appear in 'inarray', and serves to
   ;  screen out flagged values for obscured, edge or bad data, when needed:
   max_input = MAX(inarray)
   CASE innature OF
      'RDQI': max_usable = 3B
      'Mask': max_usable = 3B
      'Radrd': max_usable = 65506U
      'Rad': max_usable = 800.0
      'Brf': max_usable = 2.0
      ELSE: BREAK
   ENDCASE

   ;  Declare the output array:
   factor = 4
   outarray = MAKE_ARRAY(xdim / factor, ydim / factor, TYPE = input_type)

   ;  Compute the elements of the low spatial resolution (512 x 128) output
   ;  array as averages of 4 x 4 areas in the high spatial resolution
   ;  (2048 x 512) input array:
   FOR i = 0, (xdim / factor) - 1 DO BEGIN
      ii = i * factor
      FOR j = 0, (ydim / factor) - 1 DO BEGIN
         jj = j * factor

   ;  Define a local subarray within the high-resolution input array for the
   ;  purpose of averaging:
         subarray = inarray[ii:ii + 3, jj:jj + 3]

         CASE innature OF

   ;  ========== RDQI ==========
   ;  Process an input BYTE array containing RDQI values in the range [0B, 3B].
   ;  The low spatial resolution value is set to the highest RDQI value within
   ;  the subwindow (Note: This assumes that an RDQI of 3B [binary 11] only
   ;  occurs when the radiance value is also flagged as obscured, edge or bad):
            'RDQI': BEGIN
               outarray[i, j] = MAX(subarray)
            END

   ;  ========== Mask ==========
   ;  Process an input BYTE array containing LWC mask values in the range
   ;  [1B, 254B], where usable values are within [1B, 3B]. Larger values flag
   ;  obscured (253B) and edge (254B) pixels. The low spatial resolution value
   ;  is set to the most prevalent usable value within the subwindow, with
   ;  priority for larger values, unless there are more obscured or edge
   ;  values than usable values:
            'Mask': BEGIN
               idx = WHERE(subarray EQ 1B, n_lnd)
               idx = WHERE(subarray EQ 2B, n_wat)
               idx = WHERE(subarray EQ 3B, n_cld)
               idx = WHERE(subarray EQ 253B, n_obsc)
               idx = WHERE(subarray EQ 254B, n_edge)
               maxval = MAX([n_lnd, n_wat, n_cld])

               IF (n_lnd GE maxval) THEN outarray[i, j] = 1B
               IF (n_wat GE maxval) THEN outarray[i, j] = 2B
               IF (n_cld GE maxval) THEN outarray[i, j] = 3B

               nval = n_lnd + n_wat + n_cld
               maxinval = MAX([n_obsc, n_edge])
               IF ((n_obsc GE maxinval) AND (n_obsc GE nval)) THEN $
                  outarray[i, j] = 253B
               IF ((n_edge GE maxinval) AND (n_edge GE nval)) THEN $
                  outarray[i, j] = 254B
            END

   ;  ========== Radrd ==========
   ;  Process an input UINT array containing scaled radiances with the RDQI
   ;  attached in the range [0U, 65535U], where usable values are within
   ;  ]0B, 65506U]. Larger values flag obscured (65511U), edge (65515) or bad
   ;  (65523) pixels. The low spatial resolution value is set to the average
   ;  usable scaled radiance within that subwindow (with the RDQI removed),
   ;  followed by the largest RDQI value found within that subwindow:
            'Radrd': BEGIN

   ;  Select usable values within the subarray:
               good = WHERE(((subarray GT 0U) AND (subarray LE max_usable)), $
                  n_good)

   ;  If all pixel values in the high-resolution subarray are unusable, set the
   ;  corresponding value in the low-resolution output array to the largest
   ;  unusable value found:
               IF (n_good EQ 0) THEN BEGIN
                  outarray[i, j] = MAX(subarray)
               ENDIF ELSE BEGIN

   ;  Select the usable pixel values from the high-resolution subarray, unpack
   ;  their RDQI, and compute the maximum RDQI in that subset:
                  usable_radrd = subarray[good]
                  usable_rad = ISHFT(usable_radrd, -2)
                  rdqi_lr = MAX(usable_radrd - ISHFT(usable_rad, 2))

   ;  Compute the scaled radiance value of the result in the low-resolution
   ;  output array:
                  temp = UINT(ROUND(MEAN(FLOAT(usable_rad))))
                  outarray[i, j] = ISHFT(temp, 2) + rdqi_lr
               ENDELSE
            END

   ;  ========== Rad ==========
   ;  Process an input FLOAT array containing unscaled radiances in the
   ;  range [0.0, 800.0], where usable values are within ]0.0, 800.0]. The low
   ;  spatial resolution value is set to the average usable unscaled radiance
   ;  within that subwindow:
            'Rad': BEGIN

   ;  Select usable values within the subarray:
               good = WHERE(((subarray GT 0.0) AND (subarray LE max_usable)), $
                  n_good)

   ;  If all pixel values in the high-resolution subarray are unusable, set the
   ;  corresponding value in the low-resolution output array to zero:
               IF (n_good EQ 0) THEN BEGIN
                  outarray[i, j] = 0.0
               ENDIF ELSE BEGIN

   ;  If some pixel values in the high-resolution subarray are usable, set the
   ;  corresponding value in the low-resolution output array to their mean:
                  outarray[i, j] = MEAN(subarray[good])
               ENDELSE
            END

   ;  ========== Brf ==========
   ;  Process an input FLOAT array containing Brf values in the range
   ;  [0.0, 2.0], where usable values are within ]0.0, 2.0]. The low spatial
   ;  resolution value is set to the average usable Brf within that subwindow:
            'Brf': BEGIN

   ;  Select usable values within the subarray:
               good = WHERE(((subarray GT 0.0) AND (subarray LE max_usable)), $
                  n_good)

   ;  If all pixel values in the high-resolution subarray are unusable, set the
   ;  corresponding value in the low-resolution output array to zero:
               IF (n_good EQ 0) THEN BEGIN
                  outarray[i, j] = 0.0
               ENDIF ELSE BEGIN

   ;  If some pixel values in the high-resolution subarray are usable, set the
   ;  corresponding value in the low-resolution output array to their mean:
                  outarray[i, j] = MEAN(subarray[good])
               ENDELSE
            END
         ENDCASE
      ENDFOR
   ENDFOR

   RETURN, outarray

END
