## Installation

```st
Metacello new
	repository: 'github://estebanlm/pharo-cig:main/src';
	baseline: 'CIG';
	load
```

## Requirements

CIG needs to be able to find the clang library.
If it cannot find it automatically, set the location 
in LibClang>>unix64LibraryName, e.g.

```st
LibClang>>unix64LibraryName

	^ FFIUnix64LibraryFinder new 
		userPaths: #('/usr/lib/llvm-18/lib');
		findAnyLibrary: #('libclang.so' 'libclang.so.1')
```

## Example

```st
(lib := CigCLibraryGenerator new)
  "Prefix to be added to the generated classes (structures, enums, etc.)"
  prefix: 'Ray';
  "name of the generated package (by default, is the same as the libraryName, capitalized)"
  packageName: 'Raylib';
  "Library name. If not unixLibraryName, macLibraryName and winLibraryName
   are specified, it will be taken as base name for the existing libraries
   (e.g. in this case raylib.so, raylib.dylib and raylib.dll)" 
  libraryName: 'raylib';
  "headers to import (there can be as many of them as is needed)."
  import: '/home/esteban/dev/vm/raylib/src/raylib.h';
  import: '/home/esteban/dev/vm/raylib/src/rcamera.h';
  "include path (-I of c compiler), to allow libclang to find other
   included headers."
  cIncludePath: '/home/esteban/dev/vm/raylib/src';
  "Since this is a graphical library, instruct the library to run in mainthread
   (otherwise, default is 'same thread' which is the same thread the pharo is
   running"  
  useMainThread.

"generate the library"
lib generate.
```
