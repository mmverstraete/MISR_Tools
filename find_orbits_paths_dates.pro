FUNCTION find_orbits_paths_dates, misr_path_1, misr_path_2, $
   date_1, date_2, misr_orbits, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function creates a list of the MISR ORBITs belonging
   ;  to the MISR PATHs in the range misr_path_1 to misr_path_2 and
   ;  between the dates date_1 and date_2.
   ;
   ;  ALGORITHM: This function relies on the MISR TOOLKIT function
   ;  MTK_PATH_TIMERANGE_TO_ORBITLIST to deliver the required information.
   ;
   ;  SYNTAX: rc = find_orbits_paths_dates (misr_path_1, misr_path_2, $
   ;  date_1, date_2, misr_orbits, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path_1 {INTEGER} [I] (Default value: None): The first MISR
   ;      PATH to be considered.
   ;
   ;  *   misr_path_2 {INTEGER} [I] (Default value: None): The last MISR
   ;      PATH to be considered.
   ;
   ;  *   date_1 {STRING} [I/O] (Default value: None): The first date to
   ;      be considered, formatted as YYYY-MM-DD, where YYYY, MM and DD
   ;      are the year, month and day numbers. Upon successful return,
   ;      this date is formatted as YYYY-MM-DDT00:00:00Z.
   ;
   ;  *   date_2 {STRING} [I/O] (Default value: None): The last date to be
   ;      considered, formatted as YYYY-MM-DD, where YYYY, MM and DD are
   ;      the year, month and day numbers. Upon successful return, this
   ;      date is formatted as YYYY-MM-DDT23:59:59Z.
   ;
   ;  *   misr_orbits {STRUCTURE} [O]: A structure containing the MISR
   ;      ORBITs belonging to each PATH within the range
   ;      [misr_path_1, misr_path_2] and acquired in the time period
   ;      [date_1, date_2].
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
   ;      provided in the call. The output positional parameter
   ;      misr_orbits is a stucture containing a list of the MISR ORBITS
   ;      belonging to the PATHS in the range misr_path_1 to misr_path_2
   ;      and between the dates date_1 and date_2.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter misr_orbits is a
   ;      stucture that may be empty, incomplete or useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter misr_path_1 is invalid.
   ;
   ;  *   Error 120: Positional parameter misr_path_2 is invalid.
   ;
   ;  *   Error 130: Positional parameter date_1 is invalid.
   ;
   ;  *   Error 140: Positional parameter date_2 is invalid.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_date_ymd.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function returns information on the ORBITs that are
   ;      theoretically available within the specified PATHs and between
   ;      the given dates. Data for those ORBITs may not be available at
   ;      all if there was a technical problem on the platform, or may not
   ;      be available locally if they have not been explicitly downloaded
   ;      from the NASA Langley DAAC.
   ;
   ;  *   NOTE 2: The input argument misr_path_1 is deemed smaller than
   ;      misr_path_2; however, if this is not the case, the values of the
   ;      two PATHS are interchanged.
   ;
   ;  *   NOTE 3: Similarly, the input arguments date_1 and date_2 are
   ;      expected to be given in chronological order; however, if this is
   ;      not the case, the values of the two dates are interchanged.
   ;
   ;  *   NOTE 4: Note the format change for the positional parameters
   ;      date_1 and date_2, required by the MISR TOOLKIT.
   ;
   ;  *   NOTE 5: This function assumes that the MISR input files are
   ;      systematically available for full ORBITS, i.e., include all
   ;      available BLOCKS. It does not report on the eventual
   ;      availability of subsetted data files.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path_1 = 168
   ;      IDL> misr_path_2 = 169
   ;      IDL> date_1 = '2010-01-01'
   ;      IDL> date_2 = '2010-01-31'
   ;      IDL> rc = find_orbits_paths_dates(misr_path_1, misr_path_2, $
   ;         date_1, date_2, misr_orbits, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ', rc, ' and excpt_cond = >' + excpt_cond + '<'
   ;      rc =        0 and excpt_cond = ><
   ;      IDL> HELP, misr_orbits
   ;      ** Structure <1abeedc8>, 8 tags, length=40, data length=38, refs=1:
   ;         TITLE           STRING    'MISR_Orbits'
   ;         N_MISR_PATHS    INT              2
   ;         MISR_PATH_168   INT            168
   ;         MISR_PATH_168_ORBIT_0
   ;                         LONG             53604
   ;         MISR_PATH_168_ORBIT_1
   ;                         LONG             53837
   ;         MISR_PATH_169   INT            169
   ;         MISR_PATH_169_ORBIT_0
   ;                         LONG             53473
   ;         MISR_PATH_169_ORBIT_1
   ;                         LONG             53706
   ;      IDL> PRINT, misr_orbits
   ;      { MISR_Orbits 2 168 53604 53837 169 53473 53706}
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–09–07: Version 0.9 — Initial release.
   ;
   ;  *   2017–11–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–16: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–08–21: Version 1.6 — Documentation update.
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

   ;  Initialize the output positional parameter(s):
   misr_orbits = {}

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 5
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: misr_path_1, misr_path_2, ' + $
            'date_1, date_2, misr_orbits.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if misr_path_1 or
   ;  misr_path_2 is invalid:
      rc1 = chk_misr_path(misr_path_1, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc1 NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      rc2 = chk_misr_path(misr_path_2, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc2 NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Verify that 'misr_path_2' is larger than or equal to 'misr_path_1', and
   ;  if not, exchange the two:
   IF (misr_path_1 GT misr_path_2) THEN BEGIN
      temp = misr_path_1
      misr_path_1 = misr_path_2
      misr_path_2 = temp
   ENDIF

   ;  Define the numeric output date elements of the two string input dates:
   rc1 = chk_date_ymd(date_1, year_1, month_1, day_1, $
      DEBUG = debug, EXCPT_COND = excpt_cond1)
   rc2 = chk_date_ymd(date_2, year_2, month_2, day_2, $
      DEBUG = debug, EXCPT_COND = excpt_cond2)

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if date_1 or date_2
   ;  is invalid:
      IF (rc1 NE 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond1
         RETURN, error_code
      ENDIF
      IF (rc2 NE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond2
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Verify that 'date_2' is later than or equal to 'date_1', and if not,
   ;  exchange the two:
   d_1 = JULDAY(month_1, day_1, year_1)
   d_2 = JULDAY(month_2, day_2, year_2)
   IF (d_1 GT d_2) THEN BEGIN
      temp = date_1
      date_1 = date_2
      date_2 = temp
   ENDIF

   ;  Update the dates to match the formating requirements of the MISR Toolkit:
   date_1 = date_1 + 'T00:00:00Z'
   date_2 = date_2 + 'T23:59:59Z'

   ;  Compute the number of MISR Paths involved:
   n_misr_paths = misr_path_2 - misr_path_1 + 1

   ;  Create the output structure:
   misr_orbits = CREATE_STRUCT('Title', 'MISR_Orbits')
   misr_orbits = CREATE_STRUCT(misr_orbits, 'n_misr_paths', n_misr_paths)

   ;  List the MISR Orbits that follow the selected Paths between the selected
   ;  dates:
   temp = ''
   FOR mp = misr_path_1, misr_path_2 DO BEGIN
      status = MTK_PATH_TIMERANGE_TO_ORBITLIST(mp, date_1, date_2, $
         n_orbits, orbits_list)
      misr_orbits = CREATE_STRUCT(misr_orbits, 'misr_path_' + strstr(mp), mp)
      FOR i = 0, n_orbits - 1 DO BEGIN
         misr_orbits = CREATE_STRUCT(misr_orbits, 'misr_path_' + strstr(mp) + $
            '_orbit_' + strstr(i), orbits_list[i])
      ENDFOR
   ENDFOR

   RETURN, return_code

END
