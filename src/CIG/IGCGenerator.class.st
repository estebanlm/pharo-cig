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
		type := aParameter resolveType.
		type 
			ifTranslated: [ :translation | 
				stream << (translation cToCPP: aParameter name)  ]
			ifNot: [  
				aParameter isReference ifTrue: [ stream << '*' ].
				type hasTypeReference
					ifTrue: [ stream << '(' << type cppDeclaration << ')' ].
				stream << aParameter name ] ]
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

{ #category : 'accessing' }
IGCGenerator >> cStream [
	
	^ visitor cStream
]

{ #category : 'private' }
IGCGenerator >> enumNameFor: anEnum [ 

	^ visitor enumNameFor: anEnum
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

	self hStream << 'enum ' << (self enumNameFor: anEnum) << ' {' << String cr.

	anEnum elements 
		do: [ :each | self hStream << '    ' << each name << ' = ' << each value asString ]
		separatedBy: [ self hStream << ',' << String cr ].
	self hStream << String cr << '};' << String cr.
]

{ #category : 'generating' }
IGCGenerator >> generateFunction: aFunction [
	| header body |
	
	self root: aFunction root.

	header := '{type} {funcName}({parameters});'
		format: { 
			#type -> (self cDeclarationOf: aFunction resolveReturnType).
			#funcName -> aFunction cDeclaration.
			#parameters -> (self parametersList: aFunction)  }
		asDictionary	.
	
	self hStream << header << String cr.
	
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
			
	self cStream << body << String cr
]

{ #category : 'generating' }
IGCGenerator >> generateStructure: aStructure [

	self hStream << 'struct ' << aStructure cDeclaration << ' {' << String cr.
	aStructure fields do: [ :each |
		self hStream
			<< String tab
			<< each resolveType cDeclaration << ' ' << each name << ';' 
			<< String cr ].
	self hStream << '};' << String cr.
]

{ #category : 'accessing' }
IGCGenerator >> hStream [
	
	^ visitor hStream
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
