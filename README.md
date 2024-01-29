**DOSBox-X-Print**

This fork includes features that support printing to host printers and PDF files under Windows and macOS. 

The additional files are in the Contrib/windows/resources and Contrib/macos folders in the source code.
See the dosbox-x.conf file in those folders for details of the parallel-port assignments.

Under macOS, this code creates a self-contained app that needs no external files. The conf file is included in the Resources folder.

*Build under macOS*

Use one of the two relevant shell scripts in the root folder of the source. Either

`build-macos-printa-app`

or

`build-macos-print-sdl2-app`

*Build under Windows*

Build in Visual Studio 2019 or later.

