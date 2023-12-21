Class {
	#name : 'IGParameterType',
	#superclass : 'IGType',
	#instVars : [
		'definesFunction'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'instance creation' }
IGParameterType class >> fromParameter: aParameter [

	^ self new fromParameter: aParameter
]

{ #category : 'accessing' }
IGParameterType >> definesFunction [

	^ definesFunction
]

{ #category : 'accessing' }
IGParameterType >> definesFunction: aBoolean [

	definesFunction := aBoolean
]

{ #category : 'initialization' }
IGParameterType >> fromParameter: aParameter [

	self
		parent: aParameter;
		name: aParameter typeName;
		definesFunction: aParameter definesFunction;
		typeReference: (self typeReferenceFrom: aParameter)
]

{ #category : 'private' }
IGParameterType >> typeReferenceFrom: aParameter [

	aParameter typeReference ifNotNil: [ :ref | ^ ref ]. 
	
	aParameter isTemplateSpecialization ifTrue: [ 
		^ (IGTypeReference newName: 'class ', aParameter typeName)
			parent: aParameter;
			yourself ].
	
	aParameter recordKind = IGClass kind ifTrue: [ 
		^ (IGTypeReference newName: 'class ', aParameter typeName)
			parent: aParameter;
			yourself ].

	aParameter recordKind = IGStructure kind ifTrue: [ 
		^ (IGTypeReference newName: 'struct ', aParameter typeName)
			parent: aParameter;
			yourself ].

	^ nil
]
