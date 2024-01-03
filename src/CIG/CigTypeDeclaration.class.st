Class {
	#name : 'CigTypeDeclaration',
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
CigTypeDeclaration class >> fromArray: anArray [

	^ self new
		name: anArray first;
		arity: anArray second;
		reference: anArray third;
		templateName: anArray  fourth;
		yourself
]

{ #category : 'accessing' }
CigTypeDeclaration >> fullName [

	^ String streamContents: [ :stream |
		stream << self name.
		self templateName ifNotNil: [ 
			stream << '<' << self templateName << '>' ] ]
]

{ #category : 'testing' }
CigTypeDeclaration >> isReference [

	^ reference
]

{ #category : 'testing' }
CigTypeDeclaration >> isTemplate [

	^ templateName notNil
]

{ #category : 'accessing' }
CigTypeDeclaration >> nameWithArity [

	^ self name, (self arity > 0 
		ifTrue: [ String new: self arity withAll: $* ]
		ifFalse: [ '' ])
]

{ #category : 'accessing' }
CigTypeDeclaration >> nameWithSpecialization [
	"we produce a special element if we are specializating a class"

	^ String streamContents: [ :stream |
		stream << self name.
		self templateName ifNotNil: [ 
			stream << self templateName capitalized ] ]
]

{ #category : 'accessing' }
CigTypeDeclaration >> reference: aBoolean [

	reference := aBoolean
]

{ #category : 'accessing' }
CigTypeDeclaration >> templateName [

	^ templateName
]

{ #category : 'accessing' }
CigTypeDeclaration >> templateName: aString [

	templateName := aString
]
