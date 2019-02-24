FUNCTION set_misr_specs

   ;Sec-Doc
   ;  PURPOSE: This function returns a structure containing standard
   ;  metadata on the MISR instrument, such as the number, names and
   ;  angles of the 9 cameras; the number, names and positions of the 4
   ;  spectral bands; and the standard sequence of 36 data channels (from
   ;  camera DF to camera DA, and from the Blue band to the NIR band
   ;  within each camera).
   ;
   ;  ALGORITHM: This function requires no input; it returns a structure
   ;  containing metadata on the MISR instrument, as described below.
   ;
   ;  SYNTAX: misr_specs = set_misr_specs()
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]: None.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]: None.
   ;
   ;  RETURNED VALUE TYPE: STRUCTURE.
   ;
   ;  OUTCOME: This function accepts no positional or keyword parameters
   ;  and returns a structure containing the following elements:
   ;
   ;  *   Title = ’MISR Instrument Metadata’.
   ;
   ;  *   NModes = 2.
   ;
   ;  *   ModeNames = [’GM’, ’LM’].
   ;
   ;  *   NCameras = 9.
   ;
   ;  *   CameraNames = [’DF’, ’CF’, ’BF’, ’AF’, ’AN’, ’AA’, ’BA’, ’CA’, ’DA’].
   ;
   ;  *   CameraIDs = [1, 2, 3, 4, 5, 6, 7, 8, 9].
   ;
   ;  *   CameraAngles = [70.3, 60.2, 45.7, 26.2, 0.1, 26.2, 45.7, 60.2, 70.6].
   ;
   ;  *   NBands = 4.
   ;
   ;  *   BandNames = [’Blue’, ’Green’, ’Red’, ’NIR’].
   ;
   ;  *   BandIDs = [0, 1, 2, 3].
   ;
   ;  *   BandPositions = [446.4, 557.5, 671.7, 866.4].
   ;
   ;  *   NChannels = 36.
   ;
   ;  *   ChannelOrder = [0, 1, 2, ..., 33, 34, 35].
   ;
   ;  *   ChannelNames = [’DF_Blue’, ’DF_Green’, ’DF_Red’, ..., ’DA_Green’, ’DA_Red’, ’DA_NIR’].
   ;
   ;  *   NL1B2Grids = 6.
   ;
   ;  *   L1B2GridNames = [’BlueBand’, ’GreenBand’, ’RedBand’, ’NIRBand’, ’BRF Conversion Factors’, ’GeometricParameters’]
   ;
   ;  EXCEPTION CONDITIONS: None.
   ;
   ;  DEPENDENCIES: None.
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The camera IDs are numeric values starting at 1 (for
   ;      DF), not at 0, while the spectral band IDs and the ordered
   ;      sequence of data channels are numeric arrays starting at 0 (for
   ;      Blue and for DF_Blue, respectively).
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> HELP, res
   ;      ** Structure <1ba68608>, 12 tags, length=1000, data length=974, refs=1:
   ;         TITLE           STRING    'MISR Instrument Specifications'
   ;         NCAMERAS        INT              9
   ;         CAMERANAMES     STRING    Array[9]
   ;         CAMERAIDS       INT       Array[9]
   ;         CAMERAANGLES    FLOAT     Array[9]
   ;         NBANDS          INT              4
   ;         BANDNAMES       STRING    Array[4]
   ;         BANDIDS         INT       Array[4]
   ;         BANDPOSITIONS   FLOAT     Array[4]
   ;         NCHANNELS       INT             36
   ;         CHANNELNAMES    STRING    Array[36]
   ;         NL1B2GRIDS      INT              6
   ;         L1B2GRIDNAMES   STRING    Array[6]
   ;      IDL> res = set_misr_specs()
   ;      IDL> PRINT, res.CAMERANAMES
   ;      DF CF BF AF AN AA BA CA DA
   ;      IDL> PRINT, res.BANDPOSITIONS
   ;            446.400      557.500      671.700      866.400
   ;
   ;  REFERENCES:
   ;
   ;  *   Web site: https://www-misr.jpl.nasa.gov/Mission/misrInstrument/,
   ;      accessed on 6 Nov 2017.
   ;
   ;  *   MISR TOOLKIT documentation.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–08: Version 0.8 — Initial release.
   ;
   ;  *   2017–09–03: Version 0.9 — Add CameraIDs to the output structure.
   ;
   ;  *   2017–11–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–05–01: Version 1.1 — Add MISR MODE information.
   ;
   ;  *   2018–05–29: Version 1.2 — Add MISR BANDIDS information.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–02–24: Version 2.01 — Add the ChannelOrder array to the
   ;      output structure misr_specs, and update the documentation.
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

   ;  Information about the available modes:
   nmodes = 2
   modenames = ['GM', 'LM']

   ;  Information about the camera geometry:
   ncameras = 9
   cameranames = ['DF', 'CF', 'BF', 'AF', 'AN', 'AA', 'BA', 'CA', 'DA']
   cameraids = [1, 2, 3, 4, 5, 6, 7, 8, 9]
   cameraangles = [70.3, 60.2, 45.7, 26.2, 0.1, 26.2, 45.7, 60.2, 70.6]

   ;  Information about the spectral bands:
   nbands = 4
   bandnames = ['Blue', 'Green', 'Red', 'NIR']
   bandids = [0, 1, 2, 3]
   bandpositions = [446.4, 557.5, 671.7, 866.4]

   ;  Information about the data channels:
   nchannels = 36
   channelorder = INTARR(nchannels)
   channelnames = STRARR(nchannels)
   k = 0
   FOR i = 0, ncameras - 1 DO BEGIN
      FOR j = 0, nbands - 1 DO BEGIN
         channelorder[k] = k
         channelnames[k] = cameranames[i] + '_' + bandnames[j]
         k = k + 1
      ENDFOR
   ENDFOR

   nl1b2grids = 6
   l1b2gridnames = ['BlueBand', 'GreenBand', 'RedBand', 'NIRBand', $
      'BRF Conversion Factors', 'GeometricParameters']

   ;  Setup the output structure:
   misr_specs = CREATE_STRUCT('Title', 'MISR Instrument Specifications')
   misr_specs = CREATE_STRUCT(misr_specs, 'NModes', nmodes)
   misr_specs = CREATE_STRUCT(misr_specs, 'ModeNames', modenames)
   misr_specs = CREATE_STRUCT(misr_specs, 'NCameras', ncameras)
   misr_specs = CREATE_STRUCT(misr_specs, 'CameraNames', cameranames)
   misr_specs = CREATE_STRUCT(misr_specs, 'CameraIDs', cameraids)
   misr_specs = CREATE_STRUCT(misr_specs, 'CameraAngles', cameraangles)
   misr_specs = CREATE_STRUCT(misr_specs, 'NBands', nbands)
   misr_specs = CREATE_STRUCT(misr_specs, 'BandNames', bandnames)
   misr_specs = CREATE_STRUCT(misr_specs, 'BandIDs', bandids)
   misr_specs = CREATE_STRUCT(misr_specs, 'BandPositions', bandpositions)
   misr_specs = CREATE_STRUCT(misr_specs, 'NChannels', nchannels)
   misr_specs = CREATE_STRUCT(misr_specs, 'ChannelOrder', channelorder)
   misr_specs = CREATE_STRUCT(misr_specs, 'ChannelNames', channelnames)
   misr_specs = CREATE_STRUCT(misr_specs, 'NL1B2Grids', nl1b2grids)
   misr_specs = CREATE_STRUCT(misr_specs, 'L1B2GridNames', l1b2gridnames)

   RETURN, misr_specs

END
