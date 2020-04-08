FUNCTION fn2mpocbv, $
   filespec, $
   misr_cat_id, $
   misr_mode_id, $
   misr_path_id, $
   misr_orbit_id, $
   misr_camera_id, $
   misr_block_id, $
   misr_product_id, $
   misr_version_id, $
   misrhr_product_id, $
   misrhr_version_id, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function extracts metadata on the contents of a MISR
   ;  or MISR-HR file, based on its specification FILESPEC.
   ;
   ;  ALGORITHM: This function first determines the category of the input
   ;  positional parameters filespec, and then extracts the relevant
   ;  metadata items for that file. Output positional parameters that are
   ;  not relevant or not found in the file name are returned as empty
   ;  strings.
   ;
   ;  SYNTAX: rc = fn2mpocbv(filespec, misr_cat_id, misr_mode_id, $
   ;  misr_path_id, misr_orbit_id, misr_camera_id, $
   ;  misr_block_id, misr_product_id, misr_version_id, $
   ;  misrhr_product_id, misrhr_version_id, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   filespec {STRING} [I]: An arbitrary character string, typically
   ;      the filename of a MISR data file or MISR-HR product file.
   ;
   ;  *   misr_cat_id {STRING} [O]: The category of the file: {MISR |
   ;      MISR-HR | OTHER}.
   ;
   ;  *   misr_mode_id {STRING} [O]: The MODE identifer: {GM | LM}.
   ;
   ;  *   misr_path_id {INTEGER} [O]: The MISR PATH identifer.
   ;
   ;  *   misr_orbit_id {LONG} [O]: The MISR ORBIT identifer.
   ;
   ;  *   misr_camera_id {STRING} [O]: The MISR CAMERA identifer.
   ;
   ;  *   misr_block_id {STRING} [O]: The MISR BLOCK identifer.
   ;
   ;  *   misr_product_id {STRING} [O]: The MISR PRODUCT: {BR | L1B2 |
   ;      RCCM | GMP | L2AERO | L2LAND}.
   ;
   ;  *   misr_version_id STRING [O]: The MISR VERSION identifer.
   ;
   ;  *   misrhr_product_id {STRING} [O]: The MISR-HR PRODUCT: {L1B3 | BRF
   ;      | RPV | TIP}.
   ;
   ;  *   misrhr_version_id STRING [O]: The MISR-HR VERSION identifer.
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
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. The output positional parameters contain
   ;      the desired information.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters may be invalid.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter filespec is not of type
   ;      STRING.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: It is highly recommended to call this function with
   ;      specific output positional parameter names such as misr_mode_id,
   ;      misr_path_id, etc. (rather than misr_mode, misr_path, etc.), to
   ;      avoid interfering with values possibly already set in the
   ;      calling routine.
   ;
   ;  *   NOTE 2: If the input positional parameter filespec contains
   ;      multiple instances of recognizable string patterns (which should
   ;      not occur for proper file names), the first one encountered,
   ;      when scanning filespec from left to right, sets the definitive
   ;      value of the output parameter.
   ;
   ;  *   NOTE 3: This function does not check the existence or the
   ;      readability of the presumed input positional parameter filespec,
   ;      so that file does not need to be accessible or even match an
   ;      actual file: See the last example below.
   ;
   ;  *   NOTE 4: Output positional parameters that are irrelevant for the
   ;      specified filespec are assigned an empty string. For instance,
   ;      the MISR MODE is undefined for MISR-HR product files, and,
   ;      conversely, the misrhr_version_id is undefined for MISR data
   ;      files.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> filespec = 'MISR_AM1_GRP_TERRAIN_GM_P168_O005839_DA_F03_0024.hdf'
   ;      IDL> rc = fn2mpocbv(filespec, misr_cat_id, misr_mode_id, misr_path_id, $
   ;      IDL>    misr_orbit_id, misr_camera_id, misr_block_id, misr_product_id, $
   ;      IDL>    misr_version_id, misrhr_product_id, misrhr_version_id, $
   ;      IDL>    DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'misr_cat_id = ' + misr_cat_id
   ;      misr_cat_id = MISR
   ;      IDL> PRINT, 'misr_mode_id = >' + misr_mode_id + '<'
   ;      misr_mode_id = >GM<
   ;      IDL> PRINT, 'misr_path_id = >' + misr_path_id + '<'
   ;      misr_path_id = >P168<
   ;      IDL> PRINT, 'misr_orbit_id = >' + misr_orbit_id + '<'
   ;      misr_orbit_id = >O005839<
   ;      IDL> PRINT, 'misr_camera_id = >' + misr_camera_id + '<'
   ;      misr_camera_id = >DA<
   ;      IDL> PRINT, 'misr_block_id = >' + misr_block_id + '<'
   ;      misr_block_id = ><
   ;      IDL> PRINT, 'misr_product_id = >' + misr_product_id + '<'
   ;      misr_product_id = >L1B2<
   ;      IDL> PRINT, 'misr_version_id = >' + misr_version_id + '<'
   ;      misr_version_id = >F03_0024<
   ;      IDL> PRINT, 'misrhr_product_id = >' + misrhr_product_id + '<'
   ;      misrhr_product_id = ><
   ;      IDL> PRINT, 'misrhr_version_id = >' + misrhr_version_id + '<'
   ;      misrhr_version_id = ><
   ;
   ;      IDL> filespec = 'MISR_HR_TIP_20180310_P168_O096942_B112_V2.00-0_GRN.hdf'
   ;      IDL> rc = fn2mpocbv(filespec, misr_cat_id, misr_mode_id, misr_path_id, $
   ;      IDL>    misr_orbit_id, misr_camera_id, misr_block_id, misr_product_id, $
   ;      IDL>    misr_version_id, misrhr_product_id, misrhr_version_id, $
   ;      IDL>    DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'misr_cat_id = ' + misr_cat_id
   ;      misr_cat_id = MISR-HR
   ;      IDL> PRINT, 'misr_mode_id = >' + misr_mode_id + '<'
   ;      misr_mode_id = ><
   ;      IDL> PRINT, 'misr_path_id = >' + misr_path_id + '<'
   ;      misr_path_id = >P168<
   ;      IDL> PRINT, 'misr_orbit_id = >' + misr_orbit_id + '<'
   ;      misr_orbit_id = >O096942<
   ;      IDL> PRINT, 'misr_camera_id = >' + misr_camera_id + '<'
   ;      misr_camera_id = ><
   ;      IDL> PRINT, 'misr_block_id = >' + misr_block_id + '<'
   ;      misr_block_id = >B112<
   ;      IDL> PRINT, 'misr_product_id = >' + misr_product_id + '<'
   ;      misr_product_id = ><
   ;      IDL> PRINT, 'misr_version_id = >' + misr_version_id + '<'
   ;      misr_version_id = ><
   ;      IDL> PRINT, 'misrhr_product_id = >' + misrhr_product_id + '<'
   ;      misrhr_product_id = >TIP<
   ;      IDL> PRINT, 'misrhr_version_id = >' + misrhr_version_id + '<'
   ;      misrhr_version_id = >V2.00-0<
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–09–03: Version 0.9 — Initial release under the name
   ;      fn2pocv_l1b2_gm.pro.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–05–07: Version 1.1 — Add the misr_mode output positional
   ;      parameter, merge this function with its twin fn2pocv_l1b2_lm.pro
   ;      and change the name to
   ;      fn2mpocv_l1b2.pro.
   ;
   ;  *   2018–05–18: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–07–13: Version 1.6 — Modify the code to ensure that the
   ;      output variable misr_camera is a scalar string and update the
   ;      documentation.
   ;
   ;  *   2019–02–26: Version 1.7 — Generalize the applicability of this
   ;      function by extracting the MISR MODE, PATH, ORBIT, CAMERA, BLOCK
   ;      and VERSION identifiers on the basis of string patterns rather
   ;      than relying on MISR Toolkit, change its name from
   ;      fn2mpocv_l1b2.pro tofn2mpocbv.pro and move this function to the
   ;      MISR_TOOLS repository.
   ;
   ;  *   2019–03–01: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the assignment
   ;      of numeric return codes), and switch to 3-parts version
   ;      identifiers.
   ;
   ;  *   2019–11–06: Version 2.1.1 — Major rewrite of the function to add
   ;      the output positional parameters misr_cat_id, misr_product_id
   ;      and misrhr_product_id, recognize more MISR and MISR-HR products,
   ;      and update the documentation.
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

   ;  Initialize the output positional parameter(s):
   misr_cat_id = ''
   misr_mode_id = ''
   misr_path_id = ''
   misr_orbit_id = ''
   misr_camera_id = ''
   misr_block_id = ''
   misr_product_id = ''
   misr_version_id = ''
   misrhr_product_id = ''
   misrhr_version_id = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 11
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): filespec, misr_cat_id, ' + $
            'misr_mode_id, misr_path_id, misr_orbit_id, misr_camera_id, ' + $
            'misr_block_id, misr_product_id, misr_version_id, ' + $
            'misrhr_product_id, misrhr_version_id.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'filespec' is not of type STRING:
      IF (is_string(filespec) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter filespec is not of type STRING.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Distinguish the file category. WARNING: The sequence of IF statements
   ;  is important because MISR-HR L1B3 files will first be identified as
   ;  being of category 'MISR' before being reassigned to 'MISR-HR' since
   ;  those filenames include both identifiers:
   cat_misr = STRPOS(filespec, 'MISR')
   cat_misrhr = STRPOS(filespec, 'MISRHR')
   cat_misr_hr = STRPOS(filespec, 'MISR_HR')

   IF (cat_misr GE 0) THEN misr_cat_id = 'MISR'
   IF (cat_misrhr GE 0) THEN misr_cat_id = 'MISR-HR'
   IF (cat_misr_hr GE 0) THEN misr_cat_id = 'MISR-HR'
   IF (misr_cat_id EQ '') THEN misr_cat_id = 'Other'

   ;  Extract the Mode and/or Product from MISR files:
   IF (misr_cat_id EQ 'MISR') THEN BEGIN

      pos = STRPOS(filespec, '_BR_GM_')
      IF (pos GT 0) THEN BEGIN
         misr_mode_id = 'GM'
         misr_product_id = 'BR'
      ENDIF

      pos = STRPOS(filespec, '_GRP_TERRAIN_GM_')
      IF (pos GT 0) THEN BEGIN
         misr_mode_id = 'GM'
         misr_product_id = 'L1B2'
      ENDIF

      pos = STRPOS(filespec, '_GRP_ELLIPSOID_GM_')
      IF (pos GT 0) THEN BEGIN
         misr_mode_id = 'GM'
         misr_product_id = 'L1B2'
      ENDIF

      pos = STRPOS(filespec, '_GRP_TERRAIN_LM_')
      IF (pos GT 0) THEN BEGIN
         misr_mode_id = 'LM'
         misr_product_id = 'L1B2'
      ENDIF

      pos = STRPOS(filespec, '_GRP_ELLIPSOID_LM_')
      IF (pos GT 0) THEN BEGIN
         misr_mode_id = 'LM'
         misr_product_id = 'L1B2'
      ENDIF

      pos = STRPOS(filespec, '_GRP_RCCM_GM_')
      IF (pos GT 0) THEN BEGIN
         misr_mode_id = 'GM'
         misr_product_id = 'RCCM'
      ENDIF

      pos = STRPOS(filespec, '_GP_GMP_')
      IF (pos GT 0) THEN misr_product_id = 'GMP'

      pos = STRPOS(filespec, '_AS_AEROSOL_')
      IF (pos GT 0) THEN misr_product_id = 'L2AERO'

      pos = STRPOS(filespec, '_AS_LAND_')
      IF (pos GT 0) THEN misr_product_id = 'L2LAND'
   ENDIF

   ;  Extract the Product from MISR-HR files (note that L1B3 files are the
   ;  only ones that contain the identifier '_GRP_TERRAIN_GM_' while being
   ;  assigned to the category 'MISR-HR'):
   IF (misr_cat_id EQ 'MISR-HR') THEN BEGIN

      pos = STRPOS(filespec, '_GRP_TERRAIN_GM_')
      IF (pos GT 0) THEN BEGIN
         misrhr_product_id = 'L1B3'
         misr_mode_id = ''
      ENDIF

      pos = STRPOS(filespec, '_BRF_')
      IF (pos GT 0) THEN misrhr_product_id = 'BRF'

      pos = STRPOS(filespec, '_RPV_')
      IF (pos GT 0) THEN misrhr_product_id = 'RPV'

      pos = STRPOS(filespec, '_TIP_')
      IF (pos GT 0) THEN misrhr_product_id = 'TIP'
   ENDIF

   ;  Extract the Path, Orbit, Camera and Block:
   str = STREGEX(filespec, 'P[0-9]{3}', /EXTRACT)
   IF (str NE '') THEN misr_path_id = str

   str = STREGEX(filespec, 'O[0-9]{6}', /EXTRACT)
   IF (str NE '') THEN misr_orbit_id = str

   str = STREGEX(filespec, '_[ABCD][AFN]_', /EXTRACT)
   IF (str NE '') THEN misr_camera_id = STRMID(str, 1, 2)

   str = STREGEX(filespec, 'B[0-9]{3}', /EXTRACT)
   IF (str NE '') THEN misr_block_id = str

   ;  Extract the version numbers:
   IF (misr_cat_id EQ 'MISR') THEN BEGIN
      str = STREGEX(filespec, 'F[0-9]{2}_[0-9]{4}', /EXTRACT)
      misr_version_id = str
   ENDIF

   IF (misr_cat_id EQ 'MISR-HR') THEN BEGIN
      str = STREGEX(filespec, 'V[0-9]{1,2}\.[0-9]{2}-[0-9]{1,2}', /EXTRACT)
      misrhr_version_id = str
   ENDIF

   RETURN, return_code

END
