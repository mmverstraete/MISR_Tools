FUNCTION set_root_dirs

   ;Sec-Doc
   ;  PURPOSE: This function returns a STRING array containing the root
   ;  directories of the 4 main sets of files used by the MISR-HR
   ;  processing system on the current machine, namely those
   ;  containing (0) the MISR AGP files, (1) the MISR input data
   ;  files, (2) the MISR-HR output products, and (3) the outcomes of the
   ;  MISR-HR post-processing routines. The array elements may contain
   ;  wildcard characters to point to one or more directories.
   ;
   ;  ALGORITHM: This function requires no input, performs no error
   ;  detection and generates no exception conditions. It spawns a child
   ;  process to identify the current computer platform and then sets the
   ;  paths to the AGP, input data, output products, and outcomes of the
   ;  post-processing files to predefined fixed values. This function
   ;  currently recognizes MicMac, MicMac2 and pc18, it can be modified to
   ;  work in other contexts by adding more options in the CASE statement.
   ;  This setup assumes that the subdirectory structures below those root
   ;  directories conforms to a preset standard, and allows other programs
   ;  and functions in this system to read from and write to folders in
   ;  predefined locations, without requiring the user to specify the root
   ;  directory addresses.
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
   ;  *   If the hostname of the current computer is recognized by this
   ;      function, this function returns a string array
   ;      [’path0’, ’path1’, ’path2’, ’path3’], where ’path0’ points to
   ;      the root directory for MISR AGP files, ’path1’ points to the
   ;      root directory for MISR input data files, ’path2’ points to the
   ;      root directory for MISR-HR output product files, and ’path3’
   ;      points to the root directory for the outcomes of the
   ;      post-processing of those products.
   ;
   ;  *   If the hostname of the current computer is not recognized by
   ;      this function, this function returns an array of 4 strings, each
   ;      containing ’Unrecognized computer’.
   ;
   ;  EXCEPTION CONDITIONS: None.
   ;
   ;  DEPENDENCIES: None.
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The MISR TOOLKIT Version 1.4.5 requires these directory
   ;      addresses to be absolute addresses, i.e., from the root
   ;      directory: Do not use the Linux shortcut ~ to designate the home
   ;      directory as part of those addresses.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> root_dirs = set_root_dirs()
   ;      IDL> FOR i = 0, 3 DO PRINT, 'root_dirs[' + strstr(i) + $
   ;         '] = ' + root_dirs[i]
   ;      root_dirs[0] = ~/MISR_HR/Input/AGP/
   ;      root_dirs[1] = /Volumes/MISR_Data*/
   ;      root_dirs[2] = /Volumes/MISRHR_Products/
   ;      root_dirs[3] = /Volumes/MISRHR_Outcomes/
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
   root_dirs[0] = 'Unrecognized OS or computer.'
   root_dirs[1] = 'Unrecognized OS or computer.'
   root_dirs[2] = 'Unrecognized OS or computer.'
   root_dirs[3] = 'Unrecognized OS or computer.'

   ;  Identify the current operating system:
	osname = strstr(!VERSION.OS)

   ;  Identify Linux computers and set the root_dirs array:
   IF (STRPOS(osname, 'linux') GE 0) THEN BEGIN
		SPAWN, 'hostname -s', computer
		computer = computer[0]
      CASE 1 OF

   ;  Add other Linux computers here:
   ;     (computer EQ 'newname'): BEGIN
   ;        root_dirs[0] = 'Folder containing AGP data'
   ;        root_dirs[1] = 'Folder containing MISR data'
   ;        root_dirs[2] = 'Folder containing MISR-HR products'
   ;        root_dirs[3] = 'Folder containing MISR-HR outcomes'

      ENDCASE
   ENDIF

   ;  Identify Mac computers and set the root_dirs array:
	IF (STRPOS(osname, 'darwin') GE 0) THEN BEGIN
		SPAWN, 'hostname -s', computer
		computer = computer[0]
		CASE 1 OF
         (computer EQ 'MicMac') OR (computer EQ 'micmac'): BEGIN
            root_dirs[0] = '/Users/mmverstraete/Documents/MISR_HR/Input/AGP/'
            root_dirs[1] = '/Volumes/MISR_Data*/'
            root_dirs[2] = '/Volumes/MISR-HR/'
            root_dirs[3] = '/Users/mmverstraete/Documents/MISR_HR/Outcomes/'
         END

         (computer EQ 'MicMac2') OR (computer EQ 'micmac2'): BEGIN
            root_dirs[0] = '/Users/michel/MISR_HR/Input/AGP/'
            root_dirs[1] = '/Volumes/MISR_Data*/'
            root_dirs[2] = '/Volumes/MISR-HR/'
            root_dirs[3] = '/Users/michel/MISR_HR/Outcomes/'
         END

         (computer EQ 'pc18'): BEGIN
            root_dirs[0] = '/Volumes/Input1/AGP/'
            root_dirs[1] = '/Volumes/Input*/'
            root_dirs[2] = '/Volumes/Output*/'
            root_dirs[3] = '/Volumes/Output2/'
         END

   ;  Add other Mac computers here:
   ;     (computer EQ 'newname'): BEGIN
   ;        root_dirs[0] = 'Folder containing AGP data'
   ;        root_dirs[1] = 'Folder containing MISR data'
   ;        root_dirs[2] = 'Folder containing MISR-HR products'
   ;        root_dirs[3] = 'Folder containing MISR-HR outcomes'

      ENDCASE
   ENDIF

   ;  Identify Microsoft Windows computers and set the root_dirs array:
   IF (STRPOS(osname, 'Win') GE 0) THEN BEGIN
      computer = strstr(GETENV('COMPUTERNAME'))
		CASE 1 OF
		   (computer EQ '5CG7213978'): BEGIN
				root_dirs[0] = 'C:\Mtk-bin-win32\sandbox\data\AGP\'
				root_dirs[1] = 'C:\Mtk-bin-win32\sandbox\data\MISR\'
				root_dirs[2] = 'C:\Mtk-bin-win32\sandbox\data\MISR-HR\TIP\DEF\'
				root_dirs[3] = 'C:\Mtk-bin-win32\sandbox\data\Output\'
			END

   ;  Add other Mac computers here:
   ;     (computer EQ 'newname'): BEGIN
   ;        root_dirs[0] = 'Folder containing AGP data'
   ;        root_dirs[1] = 'Folder containing MISR data'
   ;        root_dirs[2] = 'Folder containing MISR-HR products'
   ;        root_dirs[3] = 'Folder containing MISR-HR outcomes'

		ENDCASE
   ENDIF

   RETURN, root_dirs

END
