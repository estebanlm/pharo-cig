Class {
	#name : 'CigTypeDeclaration',
	#superclass : 'FFITypeDeclaration',
	#instVars : [
		'reference',
		'templates',
		'arrayNumber'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'instance creation' }
CigTypeDeclaration class >> fromArray: anArray [

	^ self new fromArray: anArray
]

{ #category : 'accessing' }
CigTypeDeclaration >> arrayNumber [

	^ arrayNumber
]

{ #category : 'private' }
CigTypeDeclaration >> arrayNumber: aNumber [

	arrayNumber := aNumber
]

{ #category : 'initialization' }
CigTypeDeclaration >> fromArray: anArray [

	self
		name: anArray first;
		arity: anArray second;
		reference: anArray third;
		templates: anArray fourth;
		arrayNumber: anArray fifth
]

{ #category : 'accessing' }
CigTypeDeclaration >> fullName [

	^ String streamContents: [ :stream |
		stream << self name.
		self templateName ifNotNil: [ 
			stream << '<' << self templateName << '>' ] ]
]

{ #category : 'testing' }
CigTypeDeclaration >> isArray [

	^ arrayNumber isNotNil
]

{ #category : 'testing' }
CigTypeDeclaration >> isReference [

	^ reference
]

{ #category : 'testing' }
CigTypeDeclaration >> isTemplate [

	^ templates notNil
]

{ #category : 'accessing' }
CigTypeDeclaration >> nameWithArity [

	^ String streamContents: [ :stream |
		stream << self name.
		self templateName ifNotNil: [ 
			stream << '<' << self templateName << '>' ].
		self arity > 0 ifTrue: [ 
			stream << (String new: self arity withAll: $*) ] ]
]

{ #category : 'accessing' }
CigTypeDeclaration >> nameWithSpecialization [
	"we produce a special element if we are specializating a class"

	^ String streamContents: [ :stream |
		stream << self nameWithoutPrefix.
		self templateName ifNotNil: [ 
			stream << self templateName capitalized ] ]
]

{ #category : 'accessing' }
CigTypeDeclaration >> nameWithoutNamespace [
	
	^ (CigType toTypePath: self name) last
]

{ #category : 'accessing' }
CigTypeDeclaration >> nameWithoutPrefix [
	"if name have a struct/union/enum prefix, remove it"

	^ CigType sanitizeTypeName: self name
]

{ #category : 'accessing' }
CigTypeDeclaration >> numTemplateArguments [

	^ self templates size
]

{ #category : 'private' }
CigTypeDeclaration >> reference: aBoolean [

	reference := aBoolean
]

{ #category : 'accessing' }
CigTypeDeclaration >> templateName [

	^ templates ifNotNil: #asCommaString
]

{ #category : 'accessing' }
CigTypeDeclaration >> templates [

	^ templates
]

{ #category : 'private' }
CigTypeDeclaration >> templates: anArray [

	templates := anArray
]
