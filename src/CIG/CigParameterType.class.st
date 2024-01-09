Class {
	#name : 'CigParameterType',
	#superclass : 'CigType',
	#instVars : [
		'definesFunction'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'instance creation' }
CigParameterType class >> fromParameter: aParameter [

	^ self new fromParameter: aParameter
]

{ #category : 'accessing' }
CigParameterType >> definesFunction [

	^ definesFunction
]

{ #category : 'accessing' }
CigParameterType >> definesFunction: aBoolean [

	definesFunction := aBoolean
]

{ #category : 'initialization' }
CigParameterType >> fromParameter: aParameter [

	self
		parent: aParameter;
		name: aParameter typeName;
		definesFunction: aParameter definesFunction;
		typeReference: (self typeReferenceFrom: aParameter)
]

{ #category : 'private' }
CigParameterType >> typeReferenceFrom: aParameter [

	aParameter typeReferences ifNotEmpty: [ :references | 
		"which one is good?"
		| parsedName |
		parsedName := (CigFunctionParser parse: aParameter typeName) name.
		references 
			detect: [ :each | each typeName endsWith: parsedName ]
			ifFound: [ :each | ^ each ] ].

	aParameter isTemplateSpecialization ifTrue: [ 
		^ (CigTypeReference newName: 'class ', aParameter typeName)
			parent: aParameter;
			yourself ].
	
	aParameter recordKind = CigClass kind ifTrue: [ 
		^ (CigTypeReference newName: 'class ', aParameter typeName)
			parent: aParameter;
			yourself ].

	aParameter recordKind = CigStructure kind ifTrue: [ 
		^ (CigTypeReference newName: 'struct ', aParameter typeName)
			parent: aParameter;
			yourself ].

	aParameter underlyingTypeKind = CigTypedef typeKind ifTrue: [ 
		^ (CigTypeReference newName: 'typedef ', aParameter underlyingTypeName)
			parent: aParameter;
			yourself ].

	^ nil
]
