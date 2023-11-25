Class {
	#name : 'IGTypeDeclaration',
	#superclass : 'FFITypeDeclaration',
	#instVars : [
		'reference'
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
		yourself
]

{ #category : 'testing' }
IGTypeDeclaration >> isReference [

	^ reference
]

{ #category : 'accessing' }
IGTypeDeclaration >> reference: aBoolean [

	reference := aBoolean
]
