Class {
	#name : 'IGCGenerator',
	#superclass : 'Object',
	#instVars : [
		'root',
		'visitor'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
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
				stream << (translation cToCPP: aParameter name from: aParameter)  ]
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
IGCGenerator >> basicFunctionCallOf: aFunction [

	^ '{func}({arguments})'
		format: {
			#func -> aFunction cppDeclaration.
			#arguments -> (self argumentsListToCPP: aFunction).
		}
		asDictionary
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
IGCGenerator >> defaultCastOf: aMethod call: aString [
	| cast |
	
	cast := self cCastToReturn: aMethod resolveReturnType.
	^ '{return}{returnCast}{call}' 
		format: { 
			#call -> (cast 
				ifNotEmpty: [ '(', aString, ')' ]
				ifEmpty: [ aString ]).
			#returnCast -> cast.
			#return -> (aMethod isReturnTypeVoid 
				ifTrue: [ '' ]
				ifFalse: [ 'return ' ]) }
		asDictionary
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

{ #category : 'private' }
IGCGenerator >> functionCall: aFunction [
	| template |
	
	template := self basicFunctionCallOf: aFunction.
	
	aFunction isReturnTypeVoid ifFalse: [ 
		aFunction resolveReturnType
			ifTranslated: [ :translation | ^ translation cppToC: template from: aFunction  ] ].
			
	^ self defaultCastOf: aFunction call: template
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
	{functionCall};
\}' format: { 
		#type -> (self cDeclarationOf: aFunction resolveReturnType).
		#funcName -> aFunction cDeclaration.
		#parameters -> (self parametersList: aFunction).
		#functionCall -> (self functionCall: aFunction) }
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
	| paramList | 

	paramList := (aNode parameters collect: [ :each | self parameterDecl: each ]) asCommaString.
	^ aNode isVariadic 
		ifTrue: [ paramList, ', ...' ]
		ifFalse: [ paramList ]
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
IGCGenerator >> visitor [

	^ visitor
]

{ #category : 'accessing' }
IGCGenerator >> visitor: aVisitor [

	visitor := aVisitor
]
