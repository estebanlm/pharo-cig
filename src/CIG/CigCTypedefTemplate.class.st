Class {
	#name : 'CigCTypedefTemplate',
	#superclass : 'CigCTemplate',
	#instVars : [
		'type'
	],
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCTypedefTemplate >> encloseFFIType: aString [ 	
	| shouldEnclose |
	
	"if this is a parsed array, answer it as is (it will be reparsed later as an FFIArray)"
	(aString includes: $[) ifTrue: [ ^ aString ].
	
	shouldEnclose := aString includesAnyOf: '*&'. 
	^ String streamContents: [ :stream |
		stream << '#'.
		shouldEnclose ifTrue: [ stream nextPut: $' ].
		stream << aString.
		shouldEnclose ifTrue: [ stream nextPut: $' ] ]
]

{ #category : 'generating' }
CigCTypedefTemplate >> generate [

	^ 'typedef {cType} {definition};' 
	format: { 
		#cType -> self typeName.
		#definition -> self element cDeclaration.
	} asDictionary
]

{ #category : 'generating' }
CigCTypedefTemplate >> generateCType [
	
	^ self typeTemplate generateCType
]

{ #category : 'generating' }
CigCTypedefTemplate >> generateFFIType [
	| ffiType typeName |

	typeName := self typeName.

	"it may point to an element defined here"
	(self lookupType: typeName) 
		ifNotNil: [ :anElement | ^ anElement phDeclaration ].

	"or it may point to a *pointer* to an element defined here"	
	(typeName includesAnyOf: '*&') ifTrue: [
		| stripName | 
		stripName := (typeName reject: [ :each | '*&' includes: each ]) trimmed.
		(self lookupType: stripName) ifNotNil: [ :anElement | 
			^ self encloseFFIType: (typeName copyReplaceAll: stripName with: anElement cDeclaration) ] ].
		
	"otherwise resolve it as a C type"
	ffiType := CigType resolveFFIType: typeName.
	^ self encloseFFIType: ffiType
]

{ #category : 'private' }
CigCTypedefTemplate >> lookupType: aString [
	"search starting in the parent because I do not care about this lavel 
	 (I am a typedef, I know there is no other elements here).
	 Sanitize because I can be typedefing a union/struct/enum"

	^ self element parent scopeLookup: (CigType sanitizeTypeName: aString)
]

{ #category : 'private' }
CigCTypedefTemplate >> resolveTypeName: aString [

	^ (self lookupType: aString)
		ifNotNil: [ :anElement | anElement cppDeclaration ]
		ifNil: [ aString ]
]

{ #category : 'private' }
CigCTypedefTemplate >> resolveTypeNameSpecialization: aString [ 
	| declarations |

	declarations := self element specializationTypes 
		collect: [ :each | 
			(self element parent scopeLookup: each) 
				ifNotNil: [ :anElement | anElement cppDeclaration ]
				ifNil: [ each ] ].

	^ String streamContents: [ :stream |
		stream << (self resolveTypeName: aString).
		stream << '<'.
		stream << declarations asCommaString.
		stream << '>' ]
]

{ #category : 'accessing' }
CigCTypedefTemplate >> type [

	^ type ifNil: [ type := self element resolveType ]
]

{ #category : 'accessing' }
CigCTypedefTemplate >> typeName [
	| typeName |

	typeName := self element underlyingTypeName.
	self element definesFunction 
		ifTrue: [ ^ 'void*' ].
	self element definesArray 
		ifTrue: [
			^ (CigFunctionParser parse: typeName) name asString, 
				(typeName allButFirst: (typeName indexOf: $[) - 1) ].
	self element isTemplateSpecialization
		ifTrue: [ 
			^ self resolveTypeNameSpecialization: (typeName copyUpTo: $<) ].
		
	^ self resolveTypeName: typeName
]

{ #category : 'accessing' }
CigCTypedefTemplate >> typeTemplate [

	^ CigCParameterTemplate 
		forType: self type 
		ofElement: self element
]
