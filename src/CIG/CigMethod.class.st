Class {
	#name : 'CigMethod',
	#superclass : 'CigClassMember',
	#instVars : [
		'isVirtual',
		'isPureVirtual',
		'isStatic'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigMethod class >> kind [
	
	^ CXCursor_CXXMethod
]

{ #category : 'visiting' }
CigMethod >> accept: aVisitor [

	aVisitor visitMethod: self
]

{ #category : 'accessing' }
CigMethod >> cDeclaration [

	^ self disambiguate: super cDeclaration
]

{ #category : 'accessing' }
CigMethod >> cTemplate [
	
	^ CigCMethodTemplate for: self
]

{ #category : 'initialization' }
CigMethod >> fromCursor: aCursor [

	super fromCursor: aCursor.
	isVirtual := aCursor cxxMethodIsVirtual.
	isStatic := aCursor cxxMethodIsStatic.
	isPureVirtual := isVirtual and: [ aCursor cxxMethodIsPureVirtual ]
]

{ #category : 'testing' }
CigMethod >> isMethod [

	^ true
]

{ #category : 'testing' }
CigMethod >> isPureVirtual [

	^ isPureVirtual
]

{ #category : 'testing' }
CigMethod >> isStatic [

	^ isStatic
]

{ #category : 'testing' }
CigMethod >> isVirtual [

	^ isVirtual
]

{ #category : 'accessing' }
CigMethod >> operator [
	"if method is an overloaded operator, this accessor will answer the operator it is defining"
	
	^ ((self name allButFirst: 8) copyUpTo: $() trimmed
]

{ #category : 'converting' }
CigMethod >> parametersAsList [
	
	^ String streamContents: [ :stream |
			stream 
				<< self parent name 
				<< ' *self'.
			super parametersAsList ifNotEmpty: [ :aString | 
				stream << ', ' << aString ] ]
]

{ #category : 'accessing' }
CigMethod >> phDeclaration [

	^ (String streamContents: [ :stream | 
			stream  << self spelling uncapitalized.
			self buildParameters: self parameters on: stream ])
		trimmed
]

{ #category : 'handling' }
CigMethod >> resolveReturnType [

	^ CigType new
		parent: self;
		name: self returnTypeName;
		typeReference: self typeReference;
		yourself
]
