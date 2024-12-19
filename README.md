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
  prefix: 'Ray';
  libraryName: 'raylib';
  import: '/home/esteban/dev/vm/raylib/src/raylib.h';
  import: '/home/esteban/dev/vm/raylib/src/rcamera.h';
  cIncludePath: '/home/esteban/dev/vm/raylib/src';
  useMainThread.

lib generate.
```
