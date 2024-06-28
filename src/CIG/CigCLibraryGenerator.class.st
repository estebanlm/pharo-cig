"
Generate classes for C libraries.
The C libraries are directly accessible to Pharo through uFFI, but its mapping can be cumbersome, this class can generate a package mapping all structures/enums/functions exported by the librarie, making it directly usable inside pharo.

## Example

```smalltalk

(libgit2 := CigCLibraryGenerator new)
	prefix: 'lg';
	file: '/home/esteban/dev/vm/libgit2/include/git2.h';
	cLib: 'libgit2'.
libgit2 generate
```

"
Class {
	#name : 'CigCLibraryGenerator',
	#superclass : 'CigLibraryGenerator',
	#instVars : [
		'libraryName'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'generating' }
CigCLibraryGenerator >> generate [
	| unit |

	('Initiate generation of {1}' format: { self bindingsName }) asBeaconSignal emit.
	'Collecting nodes' asBeaconSignal emit.

	unit := self translateUnit.

	self hasClasses ifTrue: [ self generatePharoClassesWith: unit ]
]

{ #category : 'accessing' }
CigCLibraryGenerator >> libraryName [

	^ libraryName ifNil: [ 'lib', self bindingsName ]
]

{ #category : 'accessing' }
CigCLibraryGenerator >> libraryName: aName [

	libraryName := aName
]

{ #category : 'private' }
CigCLibraryGenerator >> newTranslatedUnit [

	^ CigCTranslatedUnit new
]
