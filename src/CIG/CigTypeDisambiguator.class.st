"
In libclang, it happens that some types are not correctly solved, and in that cases instead failing it answers an int. 
After askking on libclang forums, nobody seemed to have an answer so I hacked this disambiguator to do it myself by hand, using the source. 
Because of that, each time I 

E.g. a size_t, std::array, std::[anything, in fact] are not correctly solved

"
Class {
	#name : 'CigTypeDisambiguator',
	#superclass : 'Object',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'instance creation' }
CigTypeDisambiguator class >> new [

	self error: 'Use #uniqueInstance'
]

{ #category : 'instance creation' }
CigTypeDisambiguator class >> uniqueInstance [

	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ]
]

{ #category : 'private - matching' }
CigTypeDisambiguator >> copyStringUntilSeparator: aString [
	| separators result |

	result := aString.
	separators := Character separators.
	(aString includesAny: separators) ifTrue: [  
		| index |
		index := aString detectIndex: [ :char | separators includes: char ].
		result := aString copyFrom: 1 to: index - 1 ].
	
	^ result
]

{ #category : 'accessing' }
CigTypeDisambiguator >> disambiguateIntIn: aName with: aSource [ 

	self matchSizeT: aSource then: [ 
		^ aName copyReplaceAll: 'int' with: 'size_t' ].
	self matchStdElement: aSource then: [ :found |  
		^ aName copyReplaceAll: 'int' with: found ].
	
	^ aName
]

{ #category : 'private - matching' }
CigTypeDisambiguator >> matchSizeT: aSource then: aBlock [

	(aSource beginsWith: 'size_t') 
		ifTrue: [ aBlock value ].
	
]

{ #category : 'private - matching' }
CigTypeDisambiguator >> matchStdElement: aSource then: aBlock [

	(aSource beginsWith: 'std::') 
		ifTrue: [ aBlock value: (self copyStringUntilSeparator: aSource) ]
]
