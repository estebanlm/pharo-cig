Class {
	#name : 'IGCGenerator',
	#superclass : 'Object',
	#instVars : [
		'root',
		'visitor'
	],
	#category : 'CIG-Generate-C',
	#package : 'CIG',
	#tag : 'Generate-C'
}

{ #category : 'instance creation' }
IGCGenerator class >> on: aVisitor [

	^ self new 
		visitor: aVisitor;
		yourself
]

{ #category : 'private' }
IGCGenerator >> argumentCastToCPP: aParameter [

	^ String streamContents: [ :stream |
		| type |
		aParameter isReference ifTrue: [ stream << '*' ].
		type := aParameter resolveType.
		type hasTypeReference
			ifTrue: [ stream << '(' << type cppDeclaration << ')' ].
		stream << aParameter name ]
]

{ #category : 'private' }
IGCGenerator >> argumentsListToCPP: aNode [

	^ (aNode parameters collect: [ :each | self argumentCastToCPP: each ]) asCommaString
]

{ #category : 'private' }
IGCGenerator >> cCastToReturn: aType [
		
	aType ifNil: [ ^ '' ].

	^ String streamContents: [ :stream |
		aType hasTypeReference 
			ifTrue: [ stream << '(' << aType cDeclaration << ')' ].
		aType isReference		
			ifTrue: [ stream << '&' ] ]
]

{ #category : 'private' }
IGCGenerator >> cDeclarationOf: aType [

	aType ifNil: [ ^ 'void' ].
	
	self flag: #HACK. "This needs to be refactored to get it right"
	^ (aType name beginsWith: 'const ')
		ifTrue: [ 'const ', aType cDeclaration ]
		ifFalse: [ aType cDeclaration ]
]

{ #category : 'private' }
IGCGenerator >> findClassNamed: aString ifFound: foundBlock ifAbsent: absentBlock [

	self root ifNil: [ ^ absentBlock value ].
	^ (self root findDeepElementMatching: [ :each | 
		(each isClass or: [ each isNamespace ]) and: [ each name = aString ] ])
		ifNotNil: [ :aNode | foundBlock value: aNode ]
		ifNil: [ absentBlock value ]
]

{ #category : 'generating' }
IGCGenerator >> generateEnum: anEnum [ 

	self flag: #TODO. "C files do not contain enum declarations (they will be taken 
	from the hpp definition)"
	self outStream << 'enum ' << anEnum cDeclaration << ' {
'.

	anEnum elements 
		do: [ :each | self outStream << '    ' << each name << ' = ' << each value asString ]
		separatedBy: [ self outStream << ',' << String cr ].
	self outStream << String cr << '};' << String cr.
]

{ #category : 'generating' }
IGCGenerator >> generateFunction: aFunction [
	| body |
	
	self root: aFunction root.

	body := '{type} {funcName}({parameters}) \{
	{return}{returnCast}{func}({arguments}\);
\}' format: { 
		#type -> (self cDeclarationOf: aFunction resolveReturnType).
		#funcName -> aFunction cDeclaration.
		#parameters -> (self parametersList: aFunction).
		#func -> aFunction cppDeclaration.
		#arguments -> (self argumentsListToCPP: aFunction).
		#returnCast -> (self cCastToReturn: aFunction resolveReturnType).
		#return -> (aFunction isReturnTypeVoid 
			ifTrue: [ '' ]
			ifFalse: [ 'return ' ]) }
		asDictionary	.
			
	self outStream << body << String cr
]

{ #category : 'generating' }
IGCGenerator >> generateStructure: aStructure [

	self outStream << 'struct ' << aStructure cDeclaration << ' {' << String cr.
	aStructure elements do: [ :each |
		self outStream 
			<< String tab
			<< each typeName << ' ' << each name << ';' 
			<< String cr ].
	self outStream << '};' << String cr.
]

{ #category : 'accessing' }
IGCGenerator >> outStream [
	
	^ visitor outStream
]

{ #category : 'private' }
IGCGenerator >> parameterDecl: aParameter [

	^ String streamContents: [ :stream |
		stream << (self cDeclarationOf: aParameter resolveType) << ' ' << aParameter name ]
]

{ #category : 'private' }
IGCGenerator >> parametersList: aNode [

	^ (aNode parameters collect: [ :each | self parameterDecl: each ]) asCommaString
]

{ #category : 'accessing' }
IGCGenerator >> root [

	^ root
]

{ #category : 'accessing' }
IGCGenerator >> root: aNode [

	root := aNode
]

{ #category : 'accessing' }
IGCGenerator >> visitor: aVisitor [

	visitor := aVisitor
]
