FUNCTION orbit2date, $
   misr_orbit, $
   DATAPOOL = datapool, $
   JULIAN = julian, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns the date of acquisition of the
   ;  specified MISR ORBIT, either as a STRING or as a LONG Julian day
   ;  number.
   ;
   ;  ALGORITHM: This function relies on MISR TOOLKIT routine
   ;  MTK_ORBIT_TO_TIMERANGE to determine the date on which the specified
   ;  MISR ORBIT was acquired.
   ;
   ;  SYNTAX: res = orbit2date(misr_orbit, DATAPOOL = datapool, $
   ;  JULIAN = julian, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   DATAPOOL = datapool {STRING} [I] ()Default value: 0): Flag to
   ;      request (1) or decline (0) returning the output as a STRING
   ;      formatted as yyy.mm.dd instead of the default STRING formatted
   ;      as yyyy-mm-dd.
   ;
   ;  *   JULIAN = julian {INT} [I] (Default value: 0): Flag to request
   ;      (1) or decline (0) returning the output as a LONG number
   ;      representing the Julian day number instead of the default STRING
   ;      formatted as yyyy-mm-dd.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: STRING OR LONG.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected and the optional
   ;      keyword parameter JULIAN is not invoked, this function returns a
   ;      STRING containing the date when the selected MISR ORBIT was
   ;      acquired, formatted as YYYY-MM-DD. If the optional keyword
   ;      parameter JULIAN is invoked, this function returns the Julian
   ;      day number corresponding to the date of acquisition of that
   ;      ORBIT as a LONG integer. In both cases, the output keyword
   ;      parameter excpt_cond is set to a null string, if the optional
   ;      input keyword parameter DEBUG was set and if the optional output
   ;      keyword parameter EXCPT_COND was provided in the call.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a null STRING, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter misr_orbit is not a scalar.
   ;
   ;  *   Error 120: Positional parameter misr_orbit is invalid.
   ;
   ;  *   Error 200: An exception condition was encountered in MTK routine
   ;      MTK_ORBIT_TO_TIMERANGE.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   is_scalar.pro
   ;
   ;  *   strcat.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Argument misr_orbit cannot be smaller than 995L (the
   ;      first ORBIT for which MISR acquired data, on February 24, 2000)
   ;      or larger than 200,000L (to be acquired on July 25, 2037).
   ;
   ;  *   NOTE 2: This function is unusual in that the value returned may
   ;      be a STRING or a LONG integer number, depending on the setting
   ;      of the optional input keyword parameter JULIAN.
   ;
   ;  *   NOTE 3: If the optional input key word parameters DATAPOOL and
   ;      JULIAN are both set, the former overrides the latter.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> res = orbit2date(68050)
   ;      IDL> PRINT, res
   ;      2012-10-03
   ;
   ;      IDL> res = orbit2date(68050, /JULIAN)
   ;      IDL> PRINT, res
   ;           2456204
   ;
   ;      IDL> res = orbit2date(200000, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'res = >' + res + '<, excpt_cond = >' + excpt_cond + '<'
   ;      res = ><, excpt_cond = >Error 120 in ORBIT2DATE:
   ;      Error 300 in CHK_MISR_ORBIT:
   ;      Invalid misr_orbit number: must be within [995L, 112000L].<
   ;
   ;  REFERENCES:
   ;
   ;  *   Web site: https://www-misr.jpl.nasa.gov/, select Gallery and
   ;      search for First Light, accessed on 5 Nov 2017.
   ;
   ;  *   MISR TOOLKIT documentation.
   ;
   ;  VERSIONING:
   ;
   ;  *   2009–11–11: Version 0.5 — Initial release by Linda Hunt (as
   ;      orbit_to_date).
   ;
   ;  *   2017–07–05: Version 0.9 — Changed function name to orbit2date,
   ;      updated the in-line documentation and added argument checking
   ;      logic.
   ;
   ;  *   2017–11–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–16: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–09–21: Version 1.6 — Add the optional input keyword
   ;      parameter JULIAN to return the date as a REAL Julian day number
   ;      instead of a STRING formatted as YYYY-MM-DD.
   ;
   ;  *   2018–12-12: Version 1.7 — Add the optional input keyword
   ;      parameter DATAPOOL to return the date as a STRING formatted as
   ;      YYYY.MM.DD instead of YYYY-MM-DD.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
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

   ;  Initialize the error code:
   return_code = ''

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(datapool)) THEN datapool = 1 ELSE datapool = 0
   IF (KEYWORD_SET(julian)) THEN julian = 1 ELSE julian = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: misr_orbit.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misr_orbit' is not a scalar:
      IF (is_scalar(misr_orbit) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': Input argument misr_band must be a scalar.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'misr_orbit' is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Get the date and time information using the MISR Toolkit:
   status = MTK_ORBIT_TO_TIMERANGE(misr_orbit, start_time, end_time)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in MISR Toolkit ' + $
         'MTK_ORBIT_TO_TIMERANGE: status = ' + strstr(status)
      RETURN, return_code
   ENDIF

   ;  Extract the date of the Orbit:
   date = STRMID(start_time, 0, 10)

   ;  If either of the optional input keyword parameters DATAPOOL or JULIAN is
   ;  set, extract the elements of date and reformat the result as needed:
   IF (datapool OR julian) THEN BEGIN
      yr = STRMID(date, 0, 4)
      mo = STRMID(date, 5, 2)
      dy = STRMID(date, 8, 2)
      IF (datapool) THEN BEGIN
         date = strcat([yr, mo, dy], '.')
         RETURN, date
      ENDIF
      IF (julian) THEN BEGIN
         jul_date = JULDAY(FIX(mo), FIX(dy), FIX(yr))
         RETURN, jul_date
      ENDIF
   ENDIF

   RETURN, date

END
