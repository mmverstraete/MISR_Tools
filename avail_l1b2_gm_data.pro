FUNCTION avail_l1b2_gm_data, path_pattern, misr_l1b2_gm_data, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function reports on the availability of MISR L1B2 data
   ;  files in the subdirectories matching the pattern path_pattern.
   ;
   ;  ALGORITHM: This function searches the path(s) matching the pattern
   ;  path_pattern for MISR L1B2 files. It stores information on their
   ;  names, sizes and range of temporal coverage in the output structure
   ;  misr_l1b2_gm_data.
   ;
   ;  SYNTAX:
   ;  rc = avail_l1b2_gm_data(path_pattern, misr_l1b2_gm_data, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   path_pattern {STRING} [I]: A path pattern presumed to contain
   ;      MISR L1B2 data files.
   ;
   ;  *   misr_l1b2_gm_data {STRUCTURE} [O]: A structure containing the
   ;      names of the subdirectories of path_pattern containing MISR L1B2
   ;      files, the total size of files in those directories, and the
   ;      range of dates covered by these data.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INTEGER.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function saves
   ;      the desired information in the structure misr_l1b2_gm_data and
   ;      returns 0; the output keyword parameter excpt_cond is set to a
   ;      null string.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered. The output argument misr_l1b2_gm_data is set to a
   ;      null STRING.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter path_pattern is not of type
   ;      STRING.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      get_dirs_sizes.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   get_dirs_sizes.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function currently reports on the first and last
   ;      MISR L1B2 files found in each of the subdirectories matching
   ;      path_pattern. It does not verify the availability of all 9 L1B2
   ;      files per ORBIT, or of the associated L2 Land Surface and the
   ;      Geometric Parameters files, which are also required by the
   ;      MISR-HR processing system.
   ;
   ;  *   NOTE 2: For generic purposes, and in particular to save this
   ;      information in a local file, use the program avail_l1b2_gm.pro
   ;      instead of this function.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> path_pattern = '/Volumes/MISR_Data*/P*'
   ;      IDL> rc = avail_l1b2_gm_data(path_pattern, misr_l1b2_gm_data, $
   ;         EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ', rc, ' and excpt_cond = >' + excpt_cond + '<'
   ;      rc =        0 and excpt_cond = ><
   ;      IDL> help, /STRUCTURE, misr_l1b2_gm_data
   ;      ** Structure <1db69a08>, 7 tags, length=296, data length=292, refs=1:
   ;         TITLE           STRING    'MISR L1B2 data availability'
   ;         NUMDIRS         LONG                 4
   ;         DIRNAMES        STRING    Array[4]
   ;         DIRSIZES        STRING    Array[4]
   ;         NUMFILES        LONG      Array[4]
   ;         INIDATE         STRING    Array[4]
   ;         FINDATE         STRING    Array[4]
   ;      IDL> PRINT, misr_l1b2_gm_data.DIRNAMES
   ;      /Volumes/MISR_Data4/P196/
   ;      /Volumes/MISR_Data4/P197/
   ;      /Volumes/MISR_Data4/P198/
   ;      /Volumes/MISR_Data4/P199/
   ;      IDL> PRINT, misr_l1b2_gm_data.DIRSIZES
   ;      466G 475G 480G 479G
   ;      IDL> PRINT, misr_l1b2_gm_data.INIDATE
   ;      2000-02-25 2000-03-03 2000-03-10 2000-03-01
   ;      IDL> PRINT, misr_l1b2_gm_data.FINDATE
   ;      2017-02-23 2017-02-14 2017-02-21 2017-02-28
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–24: Version 0.9 — Initial release.
   ;
   ;  *   2017–11–30: Version 1.0 — Initial public release.
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
   ;  Initialize the default return code and the default exception condition
   ;  message:
   return_code = 0
   excpt_cond = ''

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
   n_reqs = 2
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameters: path_pattern, misr_l1b2_gm_data.'
      misr_l1b2_gm_data = ''
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'path_pattern' is not of type STRING:
   IF (is_string(path_pattern) NE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument path_pattern is not of type STRING.'
      misr_l1b2_gm_data = ''
      RETURN, error_code
   ENDIF

   ;  Get the list of directories containing MISR data and their sizes:
   rc = get_dirs_sizes(path_pattern, n_dirs, dirs_names, dirs_sizes, $
      EXCPT_COND = excpt_cond)
   IF (rc NE 0) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond + '
      misr_l1b2_gm_data = ''
      RETURN, error_code
   ENDIF

   ;  Define the arrays that will contain some of the results:
   n_files = LONARR(n_dirs)
   date_1 = STRARR(n_dirs)
   date_2 = STRARR(n_dirs)

   FOR j = 0, n_dirs - 1 DO BEGIN

   ;  Document the dates of the first and last available L1B2 acquisitions
   ;  in each directory:
      files_patt = dirs_names[j] + 'MISR_AM1_GRP_TERRAIN_GM_*'
      files = FILE_SEARCH(files_patt, COUNT = nf)
      n_files[j] = nf

      fst = files[0]
      parts = STRSPLIT(fst, '_', COUNT = nparts, /EXTRACT)
      mis_orbit_str1 = parts[7]
      misr_orbit_1 = LONG(STRMID(mis_orbit_str1, 1))
      date_1[j] = orbit2date(misr_orbit_1, EXCPT_COND = excpt_cond)

      lst = files[n_files[j] - 1]
      parts = STRSPLIT(lst, '_', COUNT = nparts, /EXTRACT)
      mis_orbit_str2 = parts[7]
      misr_orbit_2 = LONG(STRMID(mis_orbit_str2, 1))
      date_2[j] = orbit2date(misr_orbit_2, EXCPT_COND = excpt_cond)
   ENDFOR

   ;  Define the structure 'misr_l1b2_gm_data' to hold the results:
   misr_l1b2_gm_data = CREATE_STRUCT('Title', 'MISR L1B2 data availability')
   misr_l1b2_gm_data = CREATE_STRUCT(misr_l1b2_gm_data, 'NumDirs', n_dirs)
   misr_l1b2_gm_data = CREATE_STRUCT(misr_l1b2_gm_data, 'DirNames', dirs_names)
   misr_l1b2_gm_data = CREATE_STRUCT(misr_l1b2_gm_data, 'DirSizes', dirs_sizes)
   misr_l1b2_gm_data = CREATE_STRUCT(misr_l1b2_gm_data, 'NumFiles', n_files)
   misr_l1b2_gm_data = CREATE_STRUCT(misr_l1b2_gm_data, 'IniDate', date_1)
   misr_l1b2_gm_data = CREATE_STRUCT(misr_l1b2_gm_data, 'FinDate', date_2)

   RETURN, return_code

END
