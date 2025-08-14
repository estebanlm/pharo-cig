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
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'generating' }
CigCLibraryGenerator >> generate [
	| unit |

	logger info: 'Generate'.
	logger trace: self libraryName.
	
	self validateMinimalRequirements.
	
	unit := self translateUnit.
	logger trace: unit.
	self hasClasses ifTrue: [ self generatePharoClassesWith: unit ].
	self hasBaseline ifTrue: [ self generatePharoBaselineWith: unit ]
]

{ #category : 'private' }
CigCLibraryGenerator >> newTranslatedUnit [

	^ CigCTranslatedUnit new
]
