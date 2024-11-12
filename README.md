## Installation

```st
Metacello new
	repository: 'github://estebanlm/pharo-cig:master/src';
	baseline: 'CIG';
	load
```

## Requirements

CIG needs to be able to find the clang library.
If it cannot find it automatically, set the location 
in LibClang>>unix64LibraryName, e.g.

```st
LibClang>>unix64LibraryName

	^ FFIUnix64LibraryFinder findLibrary: '/usr/lib/llvm-18/lib/libclang.so.1'
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
