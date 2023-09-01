# QBoxConvert

convert QBox data encode in HDF5 files into openEXR files for unity.

# OpenEXR

install the header files with libopenexr-dev. In this package the headers
are installed at /usr/include/OpenEXR/ so either the compilation command
should include `-I/usr/include/OpenEXR` or in contrast to the examples
available at "https://openexr.com/en/latest" the include statements for
openEXR should start with "OpenEXR/" for example
`#include <OpenEXR/ImfRgbaFile.h>`. Link with the OpenEXR libraries using
`-lIlmImf` and with the supporting utilities `-lImath`, `-lHalf`, `-lIex`
and `-lIlmThread`.
