Class {
	#name : 'IGMethod',
	#superclass : 'IGClassMember',
	#instVars : [
		'isPublic',
		'isVirtual',
		'isPureVirtual'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGMethod class >> kind [
	
	^ CXCursor_CXXMethod
]

{ #category : 'visiting' }
IGMethod >> accept: aVisitor [

	aVisitor visitMethod: self
]

{ #category : 'initialization' }
IGMethod >> fromCursor: aCursor [

	super fromCursor: aCursor.
	isPublic := aCursor cxxAccessSpecifier = 1.
	isVirtual := aCursor cxxMethodIsVirtual.
	isPureVirtual := isVirtual and: [ aCursor cxxMethodIsPureVirtual ]
]

{ #category : 'testing' }
IGMethod >> isMethod [

	^ true
]

{ #category : 'testing' }
IGMethod >> isOperator [

	^ (self name beginsWith: 'operator') 
		and: [ (self name allButFirst: 8) isAllAlphaNumerics ]
]

{ #category : 'testing' }
IGMethod >> isPublic [

	^ isPublic
]

{ #category : 'testing' }
IGMethod >> isPureVirtual [

	^ isPureVirtual
]

{ #category : 'testing' }
IGMethod >> isVirtual [

	^ isVirtual
]

{ #category : 'converting' }
IGMethod >> parametersAsList [
	
	^ String streamContents: [ :stream |
			stream 
				<< self parent name 
				<< ' *self'.
			super parametersAsList ifNotEmpty: [ :aString | 
				stream << ', ' << aString ] ]
]

{ #category : 'accessing' }
IGMethod >> phDeclaration [

	^ (String streamContents: [ :stream | 
			stream  << self spelling uncapitalized.
			self buildParameters: self parameters on: stream ])
		trimmed
]

{ #category : 'handling' }
IGMethod >> resolveReturnType [

	self isReturnTypeVoid ifTrue: [ ^ nil ].
	
	^ IGType new
		parent: self;
		name: self returnTypeName;
		reference: self typeReference;
		yourself
]

{ #category : 'accessing' }
IGMethod >> typeReference [
	"if isLValueReference = true, there will be a type reference"

	^ self elements 
		detect: [ :each | each isTypeReference ]
		ifNone: [ nil ]
]
