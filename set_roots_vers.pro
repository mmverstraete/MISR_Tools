FUNCTION set_roots_vers, $
   root_dirs, $
   versions, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function sets
   ;
   ;  *   the STRING array root_dirs to contain the default root
   ;      directories of the 4 main sets of files used by the MISR-HR
   ;      processing system on the current computer, namely
   ;
   ;      -   0: the MISR AGP files,
   ;
   ;      -   1: the MISR input data files,
   ;
   ;      -   2: the MISR-HR output products, and
   ;
   ;      -   3: the outcomes of the MISR-HR post-processing routines.
   ;
   ;      These array elements may contain wildcard characters to point to
   ;      one or more disks or directories.
   ;
   ;  *   the STRING array versions to contain the default version
   ;      indicators of the various MISR data and MISR-HR product files,
   ;      namely
   ;
   ;      -   0: the version identifier of MISR AGP files,
   ;
   ;      -   1: the version identifier of MISR BROWSE files,
   ;
   ;      -   2: the version identifier of MISR L1B2 GRP TERRAIN PROJECTED
   ;          GM files,
   ;
   ;      -   3: the version identifier of MISR L1B2 GRP TERRAIN PROJECTED
   ;          LM files,
   ;
   ;      -   4: the version identifier of MISR GEOMETRIC PARAMETERS
   ;          PRODUCT files,
   ;
   ;      -   5: the version identifier of MISR L1B2 GRP RCCM files,
   ;
   ;      -   6: the version identifier of MISR L2 AEROSOL files,
   ;
   ;      -   7: the version identifier of MISR L2 LAND files,
   ;
   ;      -   8: the version identifier of all MISR-HR product files.
   ;
   ;  ALGORITHM: This function requires no input; it relies on the
   ;  function get_host_info.pro to identify the underlying operating
   ;  system and retrieve the computer name, and then sets the default
   ;  paths to the various MISR data and MISR-HR product files. It also
   ;  sets the default versions of the various MISR data and MISR-HR
   ;  product files.
   ;
   ;  SYNTAX: rc = set_roots_vers(root_dirs, versions, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   root_dirs {STRING array} [O]: The array containing the default
   ;      directory addresses of the folders containing MISR data and
   ;      MISR-HR product files.
   ;
   ;  *   versions {STRING array} [O]: The array containing the default
   ;      version identifiers of the MISR data and MISR-HR product files.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1) or
   ;  skip (0) debugging tests.
   ;
   ;  EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”): Description
   ;  of the exception condition if one has been encountered, or a null
   ;  string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INT.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. The output positional parameter(s)
   ;      root_dirs and versions are defined an initialized.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter(s) root_dirs and
   ;      versions may be inexistent, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 99: The operating system or the computer is unrecognized,
   ;      the default values of directory addresses and version numbers
   ;      are not set.
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   get_host_info.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: If this function does not recognize the operating system
   ;      or the computer, it returns an error code 99 and an error
   ;      message. Processing can proceed, provided the directory
   ;      addresses of all required input and output folders are
   ;      explicitly specified through input keyword parameters.
   ;
   ;  *   NOTE 2: In other routines of this library, whenever input and
   ;      output folders are explicitly specified through input keyword
   ;      parameters, they override the default values set by this
   ;      function.
   ;
   ;  *   NOTE 3: This function currently recognizes the computers named
   ;      MicMac, MicMac2, pc18, and 5CG7213978; other computers can be
   ;      added by inserting more options in the OS-specific CASE
   ;      statements.
   ;
   ;  *   NOTE 4: This setup assumes that the subdirectory structures
   ;      below those root directories conform to a preset standard; it
   ;      allows other programs and functions in this system to read from
   ;      and write to default folders in those predefined locations,
   ;      without having to specify their locations explicitly.
   ;
   ;  *   NOTE 5: Whenever routines from the MISR TOOLKIT are used, (1)
   ;      they require directory addresses to be absolute addresses, i.e.,
   ;      from the computer root directory: Do not use the Linux shortcut
   ;      ~ to designate the home directory as part of those addresses,
   ;      and (2) those addresses cannot contain wildcard characters such
   ;      as ? or *.
   ;
   ;  *   NOTE 6: It is the user’s responsibility to correctly set the
   ;      directory addresses for his or her computer in this function, as
   ;      the latter does not verify that those folders are readable or
   ;      writable, since they can be overridden.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL>  = set_roots_dirs(root_dirs, versions, DEBUG = debug, $
   ;         EXCPT_COND = excpt_cond)
   ;      IDL> FOR i = 0, 3 DO PRINT, 'root_dirs[' + strstr(i) + $
   ;         '] = ' + root_dirs[i]
   ;      root_dirs[0] = /Users/michel/MISR_HR/Input/AGP/
   ;      root_dirs[1] = /Volumes/MISR_Data*/
   ;      root_dirs[2] = /Volumes/MISR-HR/
   ;      root_dirs[3] = /Users/michel/MISR_HR/Outcomes/
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–09: Version 0.9 — Initial release as set_misr_roots.pro.
   ;
   ;  *   2017–11–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–03–25: Version 1.1 — Add computer MicMac2.
   ;
   ;  *   2018–04–08: Version 1.2 — Add an array element to point to AGP
   ;      files, update addresses for pc18 to allow for multiple input and
   ;      output disks, and rename the function to set_root_dirs.pro.
   ;
   ;  *   2018–05–12: Version 1.3 — Update the documentation to note that
   ;      the MISR TOOLKIT requires absolute directory adresses.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–07–02: Version 1.6 — Revamp the logic to correctly detect
   ;      and initialize computers running under the Microsoft Windows
   ;      operating system.
   ;
   ;  *   2018–07–05: Version 1.7 — Update this routine to rely on the
   ;      function
   ;      get_host_info.pro.
   ;
   ;  *   2018–11–26: Version 1.8 — Remove code to stop processing if the
   ;      computer is unrecognized.
   ;
   ;  *   2019–01–07: Version 1.9 — Upgrade the function to set default
   ;      version identifiers as well as default paths, now provided as
   ;      output positional parameters, change the directory address
   ;      root_dirs[0], and rename it set_roots_vers.pro.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–04–11: Version 2.01 — Add pointers to computer rhapsody.
   ;
   ;  *   2019–05–08: Version 2.02 — Update the defaults version number of
   ;      MISR-HR products to V2.00-0.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the assignment
   ;      of numeric return codes), and switch to 3-parts version
   ;      identifiers.
   ;
   ;  *   2020–01–05: Version 2.1.1 — Update the code to exit gracefully
   ;      if the operating system and computer names were properly
   ;      identified but the corresponding values of root_dirs were not
   ;      set.
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
   root_dirs = MAKE_ARRAY(4, /STRING, VALUE = 'Unrecognized computer.')
   versions = MAKE_ARRAY(9, /STRING, VALUE = '')

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' output positional parameter(s): root_dirs, versions.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the default versions of the MISR data and MISR-HR product files for
   ;  all platforms:
   versions[0] = 'F01_24'     ;  AGP
   versions[1] = 'F03_0024'   ;  Browse
   versions[2] = 'F03_0024'   ;  L1B2 GRP Terrain projected GM
   versions[3] = 'F03_0024'   ;  L1B2 GRP Terrain projected LM
   versions[4] = 'F03_0013'   ;  Geometric Parameter
   versions[5] = 'F04_0025'   ;  RCCM
   versions[6] = 'F13_0023'   ;  L2 Aerosol
   versions[7] = 'F08_0023'   ;  L2 Land
   versions[8] = 'V2.00-0'    ;  MISR-HR products

   ;  Identify the current operating system and computer name:
   rc = get_host_info(os_name, comp_name, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 99
      excpt_cond = 'Warning ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond + ', the output positional parameters ' + $
         'root_dirs and versions are not set.'
      RETURN, error_code
   ENDIF

   ;  Identify Linux computers and set the root_dirs array:
   IF (STRPOS(os_name, 'linux') GE 0) THEN BEGIN
      CASE 1 OF

   ;  Add other Linux computers here:
   ;     (comp_name EQ 'newname'): BEGIN
   ;        root_dirs[0] = 'Folder containing MISR AGP data'
   ;        root_dirs[1] = 'Folder containing MISR data'
   ;        root_dirs[2] = 'Folder containing MISR-HR products'
   ;        root_dirs[3] = 'Folder containing MISR-HR outcomes'

         ELSE: BEGIN
            error_code = 99
            excpt_cond = 'Warning ' + strstr(error_code) + ' in ' + $
               rout_name + ': ' + excpt_cond + ', the variable root_dirs ' + $
               'was not set for computer ' + comp_name + '.'
         RETURN, error_code
         END
      ENDCASE
   ENDIF

   ;  Identify Mac computers and set the root_dirs array:
	IF (STRPOS(os_name, 'darwin') GE 0) THEN BEGIN
		CASE 1 OF
         (comp_name EQ 'MicMac') OR (comp_name EQ 'micmac'): BEGIN
            root_dirs[0] = '/Users/mmverstraete/Documents/MISR_HR/Input/'
            root_dirs[1] = '/Volumes/MISR_Data*/'
            root_dirs[2] = '/Volumes/MISR-HR/'
            root_dirs[3] = '/Users/mmverstraete/Documents/MISR_HR/Outcomes/'
         END

         (comp_name EQ 'MicMac2') OR (comp_name EQ 'micmac2'): BEGIN
            root_dirs[0] = '/Users/michel/MISR_HR/Input/'
            root_dirs[1] = '/Volumes/MISR_Data*/'
            root_dirs[2] = '/Volumes/MISR-HR/'
            root_dirs[3] = '/Users/michel/MISR_HR/Outcomes/'
         END

         (comp_name EQ 'pc18'): BEGIN
            root_dirs[0] = '/Volumes/Input1/'
            root_dirs[1] = '/Volumes/Input*/'
            root_dirs[2] = '/Volumes/Output*/'
            root_dirs[3] = '/Volumes/Output2/'
         END

         (comp_name EQ 'rhapsody'): BEGIN
            root_dirs[0] = '/Users/lhunt/Dropbox/MISR_Data/'
            root_dirs[1] = '/Users/lhunt/Dropbox/MISR_Data/'
            root_dirs[2] = '/Users/lhunt/Dropbox/MISR-HR/Products/'
            root_dirs[3] = '/Users/lhunt/Dropbox/MISR-HR/Outcomes/'
         END

   ;  Add another Mac computer here:
   ;     (comp_name EQ 'newname'): BEGIN
   ;        root_dirs[0] = 'Folder containing MISR AGP data'
   ;        root_dirs[1] = 'Folder containing MISR data'
   ;        root_dirs[2] = 'Folder containing MISR-HR products'
   ;        root_dirs[3] = 'Folder containing MISR-HR outcomes'

         ELSE: BEGIN
            error_code = 99
            excpt_cond = 'Warning ' + strstr(error_code) + ' in ' + $
               rout_name + ': ' + excpt_cond + ', the variable root_dirs ' + $
               'was not set for computer ' + comp_name + '.'
         RETURN, error_code
         END

      ENDCASE
   ENDIF

   ;  Identify Microsoft Windows computers and set the root_dirs array:
   IF (STRPOS(os_name, 'Win') GE 0) THEN BEGIN
		CASE 1 OF
		   (comp_name EQ '5CG7213978'): BEGIN
				root_dirs[0] = 'C:\Mtk-bin-win32\sandbox\data\'
				root_dirs[1] = 'C:\Mtk-bin-win32\sandbox\data\MISR\'
				root_dirs[2] = 'C:\Mtk-bin-win32\sandbox\data\MISR-HR\TIP\DEF\'
				root_dirs[3] = 'C:\Mtk-bin-win32\sandbox\data\Output\'
			END

   ;  Add other Microsoft Windows computer here:
   ;     (comp_name EQ 'newname'): BEGIN
   ;        root_dirs[0] = 'Folder containing MISR AGP data'
   ;        root_dirs[1] = 'Folder containing MISR data'
   ;        root_dirs[2] = 'Folder containing MISR-HR products'
   ;        root_dirs[3] = 'Folder containing MISR-HR outcomes'

         ELSE: BEGIN
            error_code = 99
            excpt_cond = 'Warning ' + strstr(error_code) + ' in ' + $
               rout_name + ': ' + excpt_cond + ', the variable root_dirs ' + $
               'was not set for computer ' + comp_name + '.'
         RETURN, error_code
         END

		ENDCASE
   ENDIF

   RETURN, return_code

END
