FUNCTION set_misr_roots

   ;Sec-Doc
   ;  PURPOSE: This function sets the root directories of the 3 main sets
   ;  of files used by the MISR-HR processing system on the current
   ;  machine, namely those containing (1) the MISR input data files, (2)
   ;  the MISR-HR output products, and (3) the outcomes of the MISR-HR
   ;  post-processing routines.
   ;
   ;  ALGORITHM: This function requires no input, performs no error
   ;  detection and generates no exception conditions. It spawns a child
   ;  process to execute a command to identify the current computer
   ;  platform and then sets the paths to the input data, output products,
   ;  and outcomes of the post-processing files to predefined fixed
   ;  values. This function currently recognizes MicMac and pc18, it can
   ;  be modified to work in other contexts by adding more options in the
   ;  CASE statement. This setup assumes that the subdirectory structures
   ;  below those root directories conforms to a preset standard, and
   ;  allows other programs and functions in this system to read from and
   ;  write to folders in predefined locations, without requiring the user
   ;  to specify the directory addresses.
   ;
   ;  SYNTAX: res = set_misr_roots()
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]: None.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]: None.
   ;
   ;  RETURNED VALUE TYPE: STRING array.
   ;
   ;  OUTCOME:
   ;
   ;  *   If the hostname of the current computer is recognized by the
   ;      function, it returns a string array [’path1’, ’path2’, ’path3’],
   ;      where ’path1’ points to the root directory for MISR input data
   ;      files, ’path2’ points to the root directory for MISR-HR output
   ;      product files, and ’path3’ points to the root directory for the
   ;      outcomes of the post-processing of those products.
   ;
   ;  *   If the hostname of the current computer is not recognized by the
   ;      function, it returns an array of three strings containing
   ;      ’Unrecognized computer’.
   ;
   ;  EXCEPTION CONDITIONS: None.
   ;
   ;  DEPENDENCIES: None.
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      [On MicMac:]
   ;      IDL> misr_roots = set_misr_roots()
   ;      IDL> PRINT, misr_roots
   ;      /Volumes/MISR_Data*/
   ;      /Volumes/MISR-HR/
   ;      /Users/mmverstraete/Documents/MISR_HR/Outcomes/
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–09: Version 0.9 — Initial release.
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
   ;  Define the output string array:
   misr_roots = STRARR(3)

   ;  Identify the current computer:
   SPAWN, 'hostname -s', computer

   ;  Set the 3 paths for the recognized computer platforms:
   CASE 1 OF
      (computer EQ 'MicMac') OR (computer EQ 'micmac'): BEGIN
         misr_roots[0] = '/Volumes/MISR_Data*/'
         misr_roots[1] = '/Volumes/MISR-HR/'
         misr_roots[2] = '/Users/mmverstraete/Documents/MISR_HR/Outcomes/'
      END

      (computer EQ 'pc18'): BEGIN
         misr_roots[0] = '/Volumes/Input1/'
         misr_roots[1] = '/Volumes/Output1/'
         misr_roots[2] = '/Volumes/Output2/'
      END

      ELSE: BEGIN
         misr_roots[0] = 'Unrecognized computer'
         misr_roots[1] = 'Unrecognized computer'
         misr_roots[2] = 'Unrecognized computer'
      END
   ENDCASE

   RETURN, misr_roots

END
