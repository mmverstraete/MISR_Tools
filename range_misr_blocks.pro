FUNCTION range_misr_blocks, $
   l1b2_fspec, $
   start_block, $
   end_block, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function reports on the range of MISR BLOCKS
   ;  containing actual data (instead of fill data) in a L1B2 Global or
   ;  Local Mode file.
   ;
   ;  ALGORITHM: This function retrieves the first and last MISR BLOCKs
   ;  containing useful data from the input positional parameter Global or
   ;  Local Mode file l1b2_fspec, and sets the values of the output
   ;  positional parameters start_block and end_block accordingly.
   ;
   ;  SYNTAX: rc = range_misr_blocks(l1b2_fspec, start_block, end_block, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   l1b2_fspec {STRING} [I]: The specification (path and name) of
   ;      the L1B2 Global or Local Mode file to inspect.
   ;
   ;  *   start_block {INT} [O]: The nothernmost BLOCK number containing
   ;      actual data.
   ;
   ;  *   end_block {INT} [O]: The southernmost BLOCK number containing
   ;      actual data.
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
   ;      provided in the call. The output positional parameters
   ;      start_block and
   ;      end_block contain the values of the starting and ending BLOCK
   ;      numbers, respectively.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters start_block and
   ;      end_block are set to 0.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter l1b2_fspec is not found or
   ;      not readable.
   ;
   ;  *   Error 600: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILEATTR_GET while recovering start_block.
   ;
   ;  *   Error 610: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILEATTR_GET while recovering end_block.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> l1b2_fspec = '/Volumes/MISR_Data3/P168/L1_GM/' + $
   ;         'MISR_AM1_GRP_TERRAIN_GM_P168_O068050_CF_F03_0024.hdf'
   ;      IDL> rc = range_misr_blocks(l1b2_fspec, start_block, end_block, $
   ;         DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ', excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;      IDL> PRINT, 'start_block = ' + strstr(start_block)
   ;      start_block = 19
   ;      IDL> PRINT, 'end_block = ' + strstr(end_block)
   ;      end_block = 162
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–12–13: Version 0.9 — Initial release.
   ;
   ;  *   2017–12–20: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–16: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–05–04: Version 2.01 — Update the code to report the
   ;      specific error message of MTK routines.
   ;
   ;  *   2019–05–17: Version 2.02 — Code simplification (FILE_TEST).
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the assignment
   ;      of numeric return codes), and switch to 3-parts version
   ;      identifiers.
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
   start_block = 0
   end_block = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 3
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): l1b2_fspec, start_block, end_block.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  file 'l1b2_fspec' does not exist or is unreadable:
      res = FILE_TEST(l1b2_fspec, /READ, /REGULAR)
      IF (res EQ 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The input file ' + l1b2_fspec + $
            ' is not found, not a regular file or not readable.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Use he MISR Toolkit routine to identify the first and last Blocks:
   status = MTK_FILEATTR_GET(l1b2_fspec, 'Start_block', start_block)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 600
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_FILEATTR_GET: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF

   status = MTK_FILEATTR_GET(l1b2_fspec, 'End block', end_block)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 610
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_FILEATTR_GET: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
