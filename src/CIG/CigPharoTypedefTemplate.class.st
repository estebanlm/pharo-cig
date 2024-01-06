"
Template for `CigField`, to properly generate its declarations.
"
Class {
	#name : 'CigPharoTypedefTemplate',
	#superclass : 'CigPharoTemplate',
	#classTraits : '{} + TraitedClass',
	#category : 'CIG-Pharo-Template',
	#package : 'CIG',
	#tag : 'Pharo-Template'
}

{ #category : 'instance creation' }
CigPharoTypedefTemplate class >> for: anElement [

	^ self allSubclasses 
		detect: [ :each | each handlesElement: anElement ]
		ifFound: [ :aClass | aClass forElement: anElement ]
		ifNone: [ CigPharoTypedefTemplate forElement: anElement ]
]

{ #category : 'private' }
CigPharoTypedefTemplate class >> handlesElement: anElement [

	^ false
]

{ #category : 'generating' }
CigPharoTypedefTemplate >> generate [

	^ String streamContents: [ :stream | | typeName |
			typeName := self element cTemplate generateCType.
			self
				resolveFFIType: typeName
				ifFound: [ :aType | stream << '#' << aType typeName ]
				ifAbsent: [ stream << typeName ] ]
]

{ #category : 'private' }
CigPharoTypedefTemplate >> resolveFFIType: aString ifFound: foundBlock ifAbsent: absentBlock [

	^ [ 
		foundBlock value: (FFIExternalType resolveType: aString) ]
	on: Error 
	do: [ :e | absentBlock value ]
]