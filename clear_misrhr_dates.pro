FUNCTION clear_misrhr_dates, rpv_path, cdates, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function ranks the available MISR-HR RPV product files
   ;  contained within the directory rpv_path in increasing order of
   ;  cloudiness and reports on the long-term seasonal variability of
   ;  cloudiness for that location.
   ;
   ;  ALGORITHM: This function uses the size of MISR-HR RPV product files
   ;  in the specified folder as a proxy for scene cloudiness [given the
   ;  compression mechanism inherent to HDF files, a smaller file implies
   ;  a larger cloud cover and a reduced availability of RPV (and
   ;  downstream TIP) products], ranks those files in decreasing order of
   ;  file size, computes statistics on the long-term seasonal variability
   ;  of cloudiness for that location, and returns the output structure
   ;  cdates containing ordered lists of file sizes and file names.
   ;
   ;  SYNTAX: rc = clear_misrhr_dates(rpv_path, cdates, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   rpv_path {STRING} [I]: The directory name of the folder
   ;      containing the available MISR-HR RPV products for the selected
   ;      PATH and BLOCK.
   ;
   ;  *   cdates {STRUCTURE} [O]: The structure containing the ordered
   ;      list of MISR-HR RPV file names, together with their rank and
   ;      file size.
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
   ;      returns 0, saves the ordered list of files in the output
   ;      structure cdates, and the output keyword parameter excpt_cond is
   ;      set to a null string, if the optional input keyword parameter
   ;      DEBUG is set and if the optional output keyword parameter
   ;      EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The variable cdates is set to a null STRING.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter rpv_path is not found or
   ;      unreadable.
   ;
   ;  *   Error 200: An exception condition occurred in
   ;      force_path_sep.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   day_of_year.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   is_readable.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: For generic purposes, use the program clear_dates.pro
   ;      instead of this function.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rpv_path = '/Volumes/MISR-HR/P169/B111/RPV'
   ;      IDL> rc = clear_misrhr_dates(rpv_path, cdates, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc
   ;             0
   ;      IDL> HELP, cdates
   ;      ** Structure <1c0a5b58>, 6 tags, length=7184, data length=7180, refs=1:
   ;         TITLE           STRING    'Clearest MISR-HR scenes'
   ;         NUMFILES        LONG               296
   ;         FILESIZES       LONG64    Array[296]
   ;         FILENAMES       STRING    Array[296]
   ;         SEASONSTATS     FLOAT     Array[13]
   ;         TOTALSIZE       FLOAT           10160.5
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–04–11: Version 0.8 — Initial release under the name
   ;      best_misrhr_dates.
   ;
   ;  *   2017–10–01: Version 0.9 — Renamed the function
   ;      clear_misrhr_dates.pro.
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

   ;  Initialize the output positional parameters to invalid values:
   cdates = {}

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: rpv_path, cdates.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  directory rpv_path does not exist or is unreadable:
      IF (is_readable(rpv_path) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input directory rpv_path not found or unreadable.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Ensure that the input directory 'rpv_path' is terminared by the file path
   ;  segment separator character for the current operating system:
   opath = force_path_sep(rpv_path, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND excpt_cond NE '') THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Derive the Path and Block numbers from that directory name:
   parts = STRSPLIT(rpv_path, '/', /EXTRACT)
   misr_path_str = parts[2]
   misr_block_str = parts[3]

   ;  Compile a list of files for this RPV directory:
   filespec = rpv_path + 'MISR_HR_RPV_*_' + misr_path_str + '_*_' + $
      misr_block_str + '_*.hdf'
   rpv_files = FILE_SEARCH(filespec, COUNT = count)

   ;  Generate arrays to contain the sizes, names, Julian dates and day of the
   ;  year of acquisition of these files:
   size_rpv_files = LON64ARR(count)
   name_rpv_files = STRARR(count)
   jdate_rpv_files = DBLARR(count)
   doy_rpv_files = INTARR(count)

   ;  Record the information in these arrays (this logic does not assume that
   ;  RPV product files are necessarily ranked by date), and compute the total
   ;  size of this set of files:
   tot_size = ULONG64(0)
   FOR i = 0, count - 1 DO BEGIN
      fi = FILE_INFO(rpv_files[i])
      size_rpv_files[i] = fi.SIZE
      tot_size = tot_size + ULONG64(size_rpv_files[i])
      name_rpv_files[i] = FILE_BASENAME(rpv_files[i])
      parts = STRSPLIT(name_rpv_files[i], '_', /EXTRACT)
      date = parts[3]
      yr_str = STRMID(date, 0, 4)
      mo_str = STRMID(date, 4, 2)
      dy_str = STRMID(date, 6, 2)
      yr = FIX(yr_str)
      mo = FIX(mo_str)
      dy = FIX(dy_str)
      jdate_rpv_files[i] = JULDAY(mo, dy, yr)
      doy_rpv_files[i] = day_of_year(mo, dy, YEAR = yr, $
         EXCPT_COND = excpt_cond)
   ENDFOR

   ;  Identify the first and last year of data acquisition:
   fst_jdate = MIN(jdate_rpv_files)
   CALDAT, fst_jdate, mo, dy, yr
   fst_yr = yr
   lst_jdate = MAX(jdate_rpv_files)
   CALDAT, lst_jdate, mo, dy, yr
   lst_yr = yr

   ;  Sort the file sizes and names in decreasing order:
   idx = REVERSE(SORT(size_rpv_files))
   sorted_size_rpv_files = size_rpv_files[idx]
   sorted_name_rpv_files = name_rpv_files[idx]

   ;  Compute the cumulated file size of all available RPV products by month,
   ;  expressed in MB, to show the clearest periods of observation (ignoring
   ;  possible data acquisitions in leap years):
   siz_per_mo = FLTARR(13)
   FOR i = 0, count - 1 DO BEGIN
      IF ((doy_rpv_files[i] GE 1) AND (doy_rpv_files[i] LE 31)) THEN BEGIN
         siz_per_mo[1] = siz_per_mo[1] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
      IF ((doy_rpv_files[i] GE 32) AND (doy_rpv_files[i] LE 59)) THEN BEGIN
         siz_per_mo[2] = siz_per_mo[2] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
      IF ((doy_rpv_files[i] GE 60) AND (doy_rpv_files[i] LE 90)) THEN BEGIN
         siz_per_mo[3] = siz_per_mo[3] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
      IF ((doy_rpv_files[i] GE 91) AND (doy_rpv_files[i] LE 120)) THEN BEGIN
         siz_per_mo[4] = siz_per_mo[4] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
      IF ((doy_rpv_files[i] GE 121) AND (doy_rpv_files[i] LE 151)) THEN BEGIN
         siz_per_mo[5] = siz_per_mo[5] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
      IF ((doy_rpv_files[i] GE 152) AND (doy_rpv_files[i] LE 181)) THEN BEGIN
         siz_per_mo[6] = siz_per_mo[6] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
      IF ((doy_rpv_files[i] GE 182) AND (doy_rpv_files[i] LE 212)) THEN BEGIN
         siz_per_mo[7] = siz_per_mo[7] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
      IF ((doy_rpv_files[i] GE 213) AND (doy_rpv_files[i] LE 243)) THEN BEGIN
         siz_per_mo[8] = siz_per_mo[8] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
      IF ((doy_rpv_files[i] GE 244) AND (doy_rpv_files[i] LE 273)) THEN BEGIN
         siz_per_mo[9] = siz_per_mo[9] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
      IF ((doy_rpv_files[i] GE 274) AND (doy_rpv_files[i] LE 304)) THEN BEGIN
         siz_per_mo[10] = siz_per_mo[10] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
      IF ((doy_rpv_files[i] GE 305) AND (doy_rpv_files[i] LE 334)) THEN BEGIN
         siz_per_mo[11] = siz_per_mo[11] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
      IF ((doy_rpv_files[i] GE 335) AND (doy_rpv_files[i] LE 366)) THEN BEGIN
         siz_per_mo[12] = siz_per_mo[12] + FLOAT(size_rpv_files[i]) / 1000000.0
      ENDIF
   ENDFOR
   tot_mb = TOTAL(siz_per_mo)

   ;  Define the structure 'cdates' to hold the results:
   cdates = CREATE_STRUCT('Title', 'Clearest MISR-HR scenes')
   cdates = CREATE_STRUCT(cdates, 'NumFiles', count)
   cdates = CREATE_STRUCT(cdates, 'FileSizes', sorted_size_rpv_files)
   cdates = CREATE_STRUCT(cdates, 'FileNames', sorted_name_rpv_files)
   cdates = CREATE_STRUCT(cdates, 'SeasonStats', siz_per_mo)
   cdates = CREATE_STRUCT(cdates, 'TotalSize', tot_mb)

   RETURN, return_code

END
