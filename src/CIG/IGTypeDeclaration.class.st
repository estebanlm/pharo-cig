Class {
	#name : 'IGTypeDeclaration',
	#superclass : 'FFITypeDeclaration',
	#instVars : [
		'reference',
		'templateName'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'instance creation' }
IGTypeDeclaration class >> fromArray: anArray [

	^ self new
		name: anArray first;
		arity: anArray second;
		reference: anArray third;
		templateName: anArray  fourth;
		yourself
]

{ #category : 'testing' }
IGTypeDeclaration >> isReference [

	^ reference
]

{ #category : 'testing' }
IGTypeDeclaration >> isTemplate [

	^ templateName notNil
]

{ #category : 'accessing' }
IGTypeDeclaration >> nameWithArity [

	^ self name, (self arity > 0 
		ifTrue: [ String new: self arity withAll: $* ]
		ifFalse: [ '' ])
]

{ #category : 'accessing' }
IGTypeDeclaration >> reference: aBoolean [

	reference := aBoolean
]

{ #category : 'accessing' }
IGTypeDeclaration >> templateName [

	^ templateName
]

{ #category : 'accessing' }
IGTypeDeclaration >> templateName: aString [

	templateName := aString
]
