FUNCTION set_root_dirs

   ;Sec-Doc
   ;  PURPOSE: This function returns a STRING array containing the root
   ;  directories of the 4 main sets of files used by the MISR-HR
   ;  processing system on the current computer, namely those
   ;  containing (0) the MISR AGP files, (1) the MISR input data
   ;  files, (2) the MISR-HR output products, and (3) the outcomes of the
   ;  MISR-HR post-processing routines. The array elements may contain
   ;  wildcard characters to point to one or more directories.
   ;
   ;  ALGORITHM: This function requires no input and performs no specific
   ;  error detection; it relies on the function get_host_info.pro to
   ;  identify the underlying operating system and retrieve the computer
   ;  name, and then sets the paths to the AGP, input data, output
   ;  products, and outcomes of the post-processing files to predefined
   ;  fixed values. It does not generate exception conditions, however it
   ;  will STOP the processing and return control to the IDL processor if
   ;  the computer name is unrecognized.
   ;
   ;  SYNTAX: root_dirs = set_root_dirs()
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]: None.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]: None.
   ;
   ;  RETURNED VALUE TYPE: STRING array.
   ;
   ;  OUTCOME:
   ;
   ;  *   If the name of the current computer is recognized, this function
   ;      returns a 4-element string array
   ;      [’path0’, ’path1’, ’path2’, ’path3’], where ’path0’ points to
   ;      the root directory for MISR AGP files, ’path1’ points to the
   ;      root directory for MISR input data files, ’path2’ points to the
   ;      root directory for MISR-HR output product files, and ’path3’
   ;      points to the root directory for the outcomes of the
   ;      post-processing of those products.
   ;
   ;  *   If the name of the current computer is not recognized, this
   ;      function stops the processing and returns control to IDL.
   ;
   ;  EXCEPTION CONDITIONS: None.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   get_host_info.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function currently recognizes the computers named
   ;      MicMac, MicMac2, pc18, and 5CG7213978; other computers can be
   ;      added by inserting more options in the OS-specific CASE
   ;      statements.
   ;
   ;  *   NOTE 2: This setup assumes that the subdirectory structures
   ;      below those root directories conform to a preset standard, and
   ;      allows other programs and functions in this system to read from
   ;      and write to folders in those predefined locations.
   ;
   ;  *   NOTE 3: If routines from the MISR TOOLKIT (Version 1.4.5) may be
   ;      used, please note that these require directory addresses to be
   ;      absolute addresses, i.e., from the computer root directory: Do
   ;      not use the Linux shortcut ~ to designate the home directory as
   ;      part of those addresses.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> root_dirs = set_root_dirs()
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
   ;      function get_host_info.pro.
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

   ;  Define and initialize the output string array:
   root_dirs = STRARR(4)
   root_dirs[0] = 'Unrecognized computer.'
   root_dirs[1] = 'Unrecognized computer.'
   root_dirs[2] = 'Unrecognized computer.'
   root_dirs[3] = 'Unrecognized computer.'

   ;  Identify the current operating system and computer name:
   rc = get_host_info(os_name, comp_name)

   ;  Identify Linux computers and set the root_dirs array:
   IF (STRPOS(os_name, 'linux') GE 0) THEN BEGIN
      CASE 1 OF

   ;  Add other Linux computers here:
   ;     (comp_name EQ 'newname'): BEGIN
   ;        root_dirs[0] = 'Folder containing AGP data'
   ;        root_dirs[1] = 'Folder containing MISR data'
   ;        root_dirs[2] = 'Folder containing MISR-HR products'
   ;        root_dirs[3] = 'Folder containing MISR-HR outcomes'

      ENDCASE
   ENDIF

   ;  Identify Mac computers and set the root_dirs array:
	IF (STRPOS(os_name, 'darwin') GE 0) THEN BEGIN
		CASE 1 OF
         (comp_name EQ 'MicMac') OR (comp_name EQ 'micmac'): BEGIN
            root_dirs[0] = '/Users/mmverstraete/Documents/MISR_HR/Input/AGP/'
            root_dirs[1] = '/Volumes/MISR_Data*/'
            root_dirs[2] = '/Volumes/MISR-HR/'
            root_dirs[3] = '/Users/mmverstraete/Documents/MISR_HR/Outcomes/'
         END

         (comp_name EQ 'MicMac2') OR (comp_name EQ 'micmac2'): BEGIN
            root_dirs[0] = '/Users/michel/MISR_HR/Input/AGP/'
            root_dirs[1] = '/Volumes/MISR_Data*/'
            root_dirs[2] = '/Volumes/MISR-HR/'
            root_dirs[3] = '/Users/michel/MISR_HR/Outcomes/'
         END

         (comp_name EQ 'pc18'): BEGIN
            root_dirs[0] = '/Volumes/Input1/AGP/'
            root_dirs[1] = '/Volumes/Input*/'
            root_dirs[2] = '/Volumes/Output*/'
            root_dirs[3] = '/Volumes/Output2/'
         END

   ;  Add other Mac computers here:
   ;     (comp_name EQ 'newname'): BEGIN
   ;        root_dirs[0] = 'Folder containing AGP data'
   ;        root_dirs[1] = 'Folder containing MISR data'
   ;        root_dirs[2] = 'Folder containing MISR-HR products'
   ;        root_dirs[3] = 'Folder containing MISR-HR outcomes'

      ENDCASE
   ENDIF

   ;  Identify Microsoft Windows computers and set the root_dirs array:
   IF (STRPOS(os_name, 'Win') GE 0) THEN BEGIN
		CASE 1 OF
		   (comp_name EQ '5CG7213978'): BEGIN
				root_dirs[0] = 'C:\Mtk-bin-win32\sandbox\data\AGP\'
				root_dirs[1] = 'C:\Mtk-bin-win32\sandbox\data\MISR\'
				root_dirs[2] = 'C:\Mtk-bin-win32\sandbox\data\MISR-HR\TIP\DEF\'
				root_dirs[3] = 'C:\Mtk-bin-win32\sandbox\data\Output\'
			END

   ;  Add other Mac computers here:
   ;     (comp_name EQ 'newname'): BEGIN
   ;        root_dirs[0] = 'Folder containing AGP data'
   ;        root_dirs[1] = 'Folder containing MISR data'
   ;        root_dirs[2] = 'Folder containing MISR-HR products'
   ;        root_dirs[3] = 'Folder containing MISR-HR outcomes'

		ENDCASE
   ENDIF

   ;  Stop the processing and return control to IDL if the computer name has
   ;  not been recognized:
   IF (root_dirs[0] EQ 'Unrecognized computer.') THEN $
      STOP, 'set_root_dirs: Unrecognized computer name.'

   RETURN, root_dirs

END
