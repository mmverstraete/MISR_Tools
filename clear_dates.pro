PRO clear_dates, misr_path, misr_block, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This program ranks the set of available MISR-HR RPV product
   ;  files for the specified MISR PATH and BLOCK in increasing order of
   ;  cloudiness and saves the results in an output file.
   ;
   ;  ALGORITHM: This program relies on the function clear_misrhr_dates to
   ;  rank the time series of available MISR-HR RPV product files in
   ;  decreasing order of file size (larger files correspond to clearer
   ;  scenes) and to generate approximate seasonal statistics of
   ;  cloudiness for the selected MISR PATH and BLOCK. The results are
   ;  saved in a file in the standard location.
   ;
   ;  SYNTAX: clear_dates, misr_path, misr_block, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
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
   ;  RETURNED VALUE TYPE: N/A.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, the keyword
   ;      parameter excpt_cond is set to a null string, if the optional
   ;      input keyword parameter DEBUG was set and if the optional output
   ;      keyword parameter EXCPT_COND was provided in the call. This
   ;      program saves a file named
   ;      clear_Pxxx_Bzzz_hostname_[creation_date].txt in the subdirectory
   ;      root_dirs[3] + ’/Pxxx_Bzzz’, where root_dirs[3] is defined by
   ;      the function set_root_dirs.
   ;
   ;  *   If an exception condition has been detected, the optional output
   ;      keyword parameter excpt_cond contains a message about the
   ;      exception condition encountered, if the optional input keyword
   ;      parameter DEBUG is set and if the optional output keyword
   ;      parameter EXCPT_COND is provided. This program prints an error
   ;      message on the console and no output file is saved.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_path is invalid.
   ;
   ;  *   Error 120: The input positional parameter misr_block is invalid.
   ;
   ;  *   Error 200: An exception condition occurred in path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in block2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in
   ;      clear_misrhr_dates.pro.
   ;
   ;  *   Error 400: An exception condition occurred in is_writable.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   clear_misrhr_dates.pro
   ;
   ;  *   is_writable.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_root_dirs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This program is a wrapper for the function
   ;      clear_misrhr_dates.
   ;
   ;  *   NOTE 2: This program does not rely on any standard MISR cloud
   ;      product, and can only report on the approximate cloud cover in
   ;      the selected BLOCK after the L1B2 files have been processed by
   ;      the MISR-HR system.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> clear_dates, 169, 111, /DEBUG, EXCPT_COND = excpt_cond
   ;      Found 296 RPV files for P169 and B111 in directory
   ;      /Volumes/MISR-HR/P169/B111/RPV/
   ;      Output file containing the list of RPV product files
   ;      sorted in decreasing order of size has been saved in
   ;      /Users/mmverstraete/Documents/MISR_HR/Outcomes/P169_B111/
   ;      MISR-HR_clear_Dates_MicMac_2017-07-11_20-32-09.txt
   ;
   ;      IDL> SPAWN, 'head ' + $
   ;      '/Users/mmverstraete/Documents/MISR_HR/Outcomes/P169_B111/
   ;      MISR-HR_clear_Dates_MicMac_2017-07-11_20-32-09.txt'
   ;      Ranked list of RPV files for P169 and B111 in decreasing order
   ;      of size.
   ;      Larger file sizes correspond to clearer scenes.
   ;
   ;      Date of file creation: 2017-07-11 at 20:32:09
   ;      Software used: clear_dates, clear_misrhr_dates.
   ;
   ;      0000 67434891 MISR_HR_RPV_20041105_P169_O025979_B111_V1.04-5.hdf
   ;      0001 67234160 MISR_HR_RPV_20080929_P169_O046716_B111_V1.04-5.hdf
   ;      0002 67213680 MISR_HR_RPV_20061213_P169_O037163_B111_V1.04-5.hdf
   ;      0003 67205487 MISR_HR_RPV_20011012_P169_O009669_B111_V1.04-5.hdf
   ;      ...
   ;
   ;      IDL> SPAWN, 'tail -n 20 ' + $
   ;      '/Users/mmverstraete/Documents/MISR_HR/Outcomes/P169_B111/
   ;      MISR-HR_clear_Dates_MicMac_2017-07-11_20-32-09.txt'
   ;      0292 461167 MISR_HR_RPV_20011028_P169_O009902_B111_V1.04-5.hdf
   ;      0293 461167 MISR_HR_RPV_20040122_P169_O021785_B111_V1.04-5.hdf
   ;      0294 461167 MISR_HR_RPV_20000228_P169_O001048_B111_V1.04-5.hdf
   ;      0295 461166 MISR_HR_RPV_20040207_P169_O022018_B111_V1.04-5.hdf
   ;
   ;      Total size of all available RPV files for P169 and B111 falling
   ;      within the indicated month:
   ;      Jan     628.42 (MB)
   ;      Feb     556.49 (MB)
   ;      Mar     631.25 (MB)
   ;      Apr     762.22 (MB)
   ;      May    1089.48 (MB)
   ;      Jun    1203.86 (MB)
   ;      Jul    1113.30 (MB)
   ;      Aug    1284.08 (MB)
   ;      Sep    1156.53 (MB)
   ;      Oct     715.23 (MB)
   ;      Nov     705.86 (MB)
   ;      Dec     313.74 (MB)
   ;
   ;      Total size of all RPV files for P169 and B111: 10160.5 (MB).
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–04–11: Version 0.8 — Initial release under the name
   ;      best_dates.
   ;
   ;  *   2017–10–01: Version 0.9 — Changed the function name to
   ;      clear_dates.pro.
   ;
   ;  *   2017–11–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–16: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–04–24: Version 1.2 — Update this function to use
   ;      set_root_dirs.pro instead of set_misr_roots.pro.
   ;
   ;  *   2018–05–14: Version 1.3 — Update this function to use the
   ;      revised version of is_writable.pro.
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

   ;  Print an error message and exit from this program if it is called
   ;  with the wrong number of required positional parameters:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: misr_path, misr_block.'
         PRINT, excpt_cond
         RETURN
      ENDIF

   ;  Print an error message if either the 'misr_path' or the 'misr_block'
   ;  input positional parameter is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINT, excpt_cond
         RETURN
      ENDIF
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINT, excpt_cond
         RETURN
      ENDIF
   ENDIF

   ;  Set the string versions of the MISR Path and Block numbers:
   rcp = path2str(misr_path, misr_path_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rcp NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, excpt_cond
      RETURN
   ENDIF

   rcb = block2str(misr_block, misr_block_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rcp NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, excpt_cond
      RETURN
   ENDIF

   ;  Define the standard locations for the MISR and MISR-HR files on this
   ;  computer:
   root_dirs = set_root_dirs()
   pb1 = misr_path_str + PATH_SEP() + misr_block_str + PATH_SEP() + $
      'RPV' + PATH_SEP()
   i_dir = root_dirs[2] + pb1
   pb2 = misr_path_str + '_' + misr_block_str + PATH_SEP()
   o_dir = root_dirs[3] + pb2

   ;  Call the function 'clear_misrhr_dates' to gather the desired information:
   rc = clear_misrhr_dates(i_dir, cdates, $
      DEBUG = debug, EXCPT_COND = excpt_cond)

   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, excpt_cond
      RETURN
   ENDIF

   ;  Identify the current computer:
   SPAWN, 'hostname -s', computer
   computer = computer[0]

   ;  Get the current date and time:
   date = today(FMT = 'ymd')

   ;  Save the results in the output file:
   o_name = 'clear_' + $
      misr_path_str + '_' + $
      misr_block_str + '_' + $
      computer + '_' + date + '.txt'
   o_spec = o_dir + o_name

   ;  Return to the calling routine with an error message if the output
   ;  directory 'o_dir' is not writable, and create it if it does not
   ;  exist:
   rc = is_writable(o_dir, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND ((rc EQ 0) OR (rc EQ -1))) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, excpt_cond
      RETURN
   ENDIF
   IF (rc EQ -2) THEN FILE_MKDIR, o_dir

   ;  Output the results in that output file:
   OPENW, o_unit, o_spec, /GET_LUN
   PRINTF, o_unit, 'Ranked list of RPV files for ' + misr_path_str + $
   ' and ' + misr_block_str + ' in decreasing order of size.'
   PRINTF, o_unit, 'Larger file sizes correspond to clearer scenes.'
   PRINTF, o_unit
   PRINTF, o_unit, 'Date of file creation: ' + today(FMT = 'NICE')
   PRINTF, o_unit, 'Software used: clear_dates, with the following inputs:'
   PRINTF, o_unit, '   misr_path = ' + strstr(misr_path)
   PRINTF, o_unit, '   misr_block = ' + strstr(misr_block)
   PRINTF, o_unit
   FOR i = 0, cdates.NumFiles - 1 DO BEGIN
      PRINTF, o_unit, i, cdates.FileSizes[i], $
         cdates.FileNames[i], FORMAT = '(I04, 3X, I9, 3X, A)'
   ENDFOR
   PRINTF, o_unit

   monthname = [' ', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', $
      'Sep', 'Oct', 'Nov', 'Dec']
   PRINTF, o_unit, 'Total size of all available RPV files for ' + $
      misr_path_str + ' and ' + misr_block_str + $
      ' falling within the indicated month:'
   FOR i = 1, 12 DO BEGIN
      PRINTF, o_unit, monthname[i], cdates.SeasonStats[i], ' (MB)', $
         FORMAT = '(A3, 3X, F8.2, A5)'
   ENDFOR
   PRINTF, o_unit
   PRINTF, o_unit, 'Total size of all RPV files for ' + misr_path_str + $
      ' and ' + misr_block_str + ': ' + strstr(cdates.TotalSize) + ' (MB).'

   FREE_LUN, o_unit
   CLOSE, /ALL

   PRINT
   PRINT, 'The output file containing the list of RPV product files sorted ' + $
      'in decreasing order of size has been saved in'
   PRINT, o_spec
   PRINT

END
