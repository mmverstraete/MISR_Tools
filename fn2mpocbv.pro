FUNCTION fn2mpocbv, $
   filespec, $
   misr_mode_id, $
   misr_path_id, $
   misr_orbit_id, $
   misr_camera_id, $
   misr_block_id, $
   misr_version_id, $
   misrhr_version_id, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function extracts metadata on the MISR or MISR-HR
   ;  MODE, PATH, ORBIT, CAMERA, BLOCK and VERSION identifiers from the
   ;  file specification FILESPEC.
   ;
   ;  ALGORITHM: This function is designed to work with standard MISR and
   ;  MISR-HR filenames, such as the L1B2 Radiance, RCCM, RPV or TIP
   ;  products (but may work with other filenames, or even arbitrary text
   ;  strings), as long as they include string patterns of the following
   ;  types:
   ;
   ;  *   <mM>, where m is either G or L, designating the misr_mode_id,
   ;
   ;  *   <Pxxx>, where xxx is a 3-digit string, designating the
   ;      misr_path_id,
   ;
   ;  *   <Oyyyyyy>, where yyyyyy is a 6-digit string, designating the
   ;      misr_orbit_id,
   ;
   ;  *   <cc>, where cc is a 2-character string, designating the
   ;      misr_camera_id,
   ;
   ;  *   <Bzzz>, where zzz is a 3-digit string, designating the
   ;      misr_block_id,
   ;
   ;  *   <Fnn_nnnn>, where nn and nnnn are 2- and 4-digit strings,
   ;      respectively, designating the misr_version_id,
   ;
   ;  *   <Vmm.mm-mm>, where mm are numeric strings, designating the
   ;      misrhr_version_id,
   ;
   ;  and where the symbols < and > stand for either the underscore (_),
   ;  the dash (-) or the full stop (.) separator. If any one of these
   ;  string patterns is missing in FILESPEC, the corresponding output
   ;  identifer is set to a null string.
   ;
   ;  SYNTAX: rc = fn2mpocbv(filespec, misr_mode_id, misr_path_id, $
   ;  misr_orbit_id, misr_camera_id, misr_block_id, $
   ;  misr_version_id, misrhr_version_id, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   filespec {STRING} [I]: An arbitrary character string, typically
   ;      the filename of a MISR data file or MISR-HR product file.
   ;
   ;  *   misr_mode_id {STRING} [O]: The MODE identifer.
   ;
   ;  *   misr_path_id {INTEGER} [O]: The MISR PATH identifer.
   ;
   ;  *   misr_orbit_id {LONG} [O]: The MISR ORBIT identifer.
   ;
   ;  *   misr_camera_id {STRING} [O]: The MISR CAMERA identifer.
   ;
   ;  *   misr_block_id {STRING} [O]: The MISR BLOCK identifer.
   ;
   ;  *   misr_version_id STRING [O]: The MISR VERSION identifer.
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
   ;      provided in the call. The output arguments misr_mode_id,
   ;      misr_path_id, misr_orbit_id,
   ;      misr_camera_id, misr_block_id, misr_version_id and
   ;      misrhr_version_id contain the desired information.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output arguments misr_mode_id, misr_path_id,
   ;      misr_orbit_id, misr_camera_id, misr_block_id, misr_version_id
   ;      and misrhr_version_id may be undefined, incomplete or useless.
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
   ;      misr_path_id, etc., to avoid interfering with values possibly
   ;      already set in the calling routine.
   ;
   ;  *   NOTE 2: If the input positional parameter filespec contains
   ;      multiple instances of these string patterns, the last one
   ;      encountered, when scanning filespec from left to right, sets the
   ;      definitive value of the output parameter.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> filespec = '/Volumes/MISR_Data3⁩/P168⁩/L1_GM⁩/
   ;         MISR_AM1_GRP_TERRAIN_GM_P168_O005839_DA_F03_0024.hdf'
   ;      IDL> rc = fn2mpocbv(filespec, misr_mode_id, $
   ;         misr_path_id, misr_orbit_id, misr_camera_id, $
   ;         misr_block_id, misr_version_id, misrhr_version_id, $
   ;         DEBUG = debug, EXCPT_COND = excpt_cond)
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
   ;      IDL> PRINT, 'misr_version_id = >' + misr_version_id + '<'
   ;      misr_version_id = >F03_0024<
   ;      IDL> PRINT, 'misrhr_version_id = >' + misrhr_version_id + '<'
   ;      misrhr_version_id = ><
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

   ;  Initialize the output positional parameter(s):
   misr_mode_id = ''
   misr_path_id = ''
   misr_orbit_id = ''
   misr_camera_id = ''
   misr_block_id = ''
   misr_version_id = ''
   misrhr_version_id = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 8
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): filespec, misr_mode_id, ' + $
            'misr_path_id, misr_orbit_id, misr_camera_id, ' + $
            'misr_block_id, misr_version_id, misrhr_version_id.'
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

   ;  Split the basename of the input positional parameter 'filespec' using the
   ;  underscore, dash and full stop characters as separators:
   parts = STRSPLIT(FILE_BASENAME(filespec), '_-.', COUNT = count, /EXTRACT)

   ;  Inspect each components and extract possible MISR metadata information:
   FOR i = 0, count - 1 DO BEGIN
      p = STRUPCASE(parts[i])
      IF ((STRLEN(p) EQ 2) AND $
         ((first_char(p) EQ 'G') OR (first_char(p) EQ 'L')) AND $
         (last_char(p) EQ 'M')) THEN BEGIN
         misr_mode_id = p
         CONTINUE
      ENDIF
      IF ((STRLEN(p) EQ 4) AND $
         (first_char(p) EQ 'P') AND $
         (is_numstring(STRMID(p, 1)) EQ 1)) THEN BEGIN
         misr_path_id = p
         CONTINUE
      ENDIF
      IF ((STRLEN(p) EQ 7) AND $
         (first_char(p) EQ 'O') AND $
         (is_numstring(STRMID(p, 1)) EQ 1)) THEN BEGIN
         misr_orbit_id = p
         CONTINUE
      ENDIF
      IF ((STRLEN(p) EQ 2) AND $
         ((first_char(p) EQ 'A') OR (first_char(p) EQ 'B') OR $
            (first_char(p) EQ 'C') OR (first_char(p) EQ 'D')) AND $
         ((last_char(p) EQ 'A') OR (last_char(p) EQ 'F'))) THEN BEGIN
         misr_camera_id = p
         CONTINUE
      ENDIF
      IF ((STRLEN(p) EQ 4) AND $
         (first_char(p) EQ 'B') AND $
         (is_numstring(STRMID(p, 1)) EQ 1)) THEN BEGIN
         misr_block_id = p
         CONTINUE
      ENDIF
      IF ((STRLEN(p) EQ 3) AND $
         (first_char(p) EQ 'F')) THEN BEGIN
         IF ((is_numstring(STRMID(p, 1)) EQ 1) AND $
            (i EQ (count - 3)) AND $
            (STRLEN(parts[i + 1]) EQ 4) AND $
            (is_numstring(parts[i + 1]) EQ 1)) THEN BEGIN
            misr_version_id = p + '_' + parts[i + 1]
            CONTINUE
         ENDIF
      ENDIF
      IF ((STRLEN(p) EQ 2) AND $
         (first_char(p) EQ 'V')) THEN BEGIN
         IF ((is_numstring(STRMID(p, 1)) EQ 1) AND $
            (i EQ (count - 4)) AND $
            (is_numstring(parts[i + 1]) EQ 1) AND $
            (is_numstring(parts[i + 2]) EQ 1)) THEN BEGIN
            misrhr_version_id = p + '.' + parts[i + 1] + '-' + parts[i + 2]
            CONTINUE
         ENDIF
      ENDIF
   ENDFOR

   RETURN, return_code

END
