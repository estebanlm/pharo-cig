Class {
	#name : 'CigStructure',
	#superclass : 'CigElement',
	#traits : 'CigTClass',
	#classTraits : 'CigTClass classTrait',
	#instVars : [
		'comment',
		'isPublic'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigStructure class >> kind [
	
	^ CXCursor_StructDecl
]

{ #category : 'accessing' }
CigStructure class >> typeReferenceName [
	"prefix included in IGTypeReference"
	
	^ 'struct'
]

{ #category : 'visiting' }
CigStructure >> accept: aVisitor [

	aVisitor visitStructure: self
]

{ #category : 'testing' }
CigStructure >> acceptDataStructures [

	^ true
]

{ #category : 'accessing' }
CigStructure >> cDeclaration [
	"since a struct in c++ can act as a class, we need to answer its kind as a structure 
	 of as a class, depending the case"
	| decl |
	
	decl := super cDeclaration.
	^ self isClass
		ifTrue: [ decl, '*' ]
		ifFalse: [ decl ]
]

{ #category : 'accessing' }
CigStructure >> cDisposeTemplate [
	
	^ CigCDisposeMethodTemplate for: self
]

{ #category : 'accessing' }
CigStructure >> cTemplate [
	
	^ CigCStructTemplate for: self
]

{ #category : 'testing' }
CigStructure >> canBeAddedTo: anElement [

	^ anElement acceptDataStructures
]

{ #category : 'testing' }
CigStructure >> canBeExported [

	"skip if not public (it can be nested in a class)"
	self isPublic ifFalse: [ ^ false ].
	"skip if is annonymous (for now at least)"
	(self isAnonymous and: [ self isNested not]) ifTrue: [ ^ false ].
	"skip if is template specialization"
	self isTemplateSpecialization ifTrue: [ ^ false ].
	"if it does not have anyfield (but is not a class), it can't be exported"
	(self isClass not and: [ self fields isEmpty ]) ifTrue: [ ^ false ].

	^ true
]

{ #category : 'testing' }
CigStructure >> canBeFieldOfStructure [
	
	^ true
]

{ #category : 'accessing' }
CigStructure >> classMembers [

	^ self elements select: [ :each | each isClassMember ]
]

{ #category : 'accessing' }
CigStructure >> comment [

	^ comment
]

{ #category : 'accessing' }
CigStructure >> fieldAnonymousReferences [
	"I need a special accessor for this because this kind of structures/unions 
	 that are anonymous are not declared elsewhere, so I need to be able to 
	 declare them later (since uFFI does not allows nested structures, I need 
	 to flatten them in Pharo)."
	
	^ self fields select: [ :each | each isStructure and: [ each isAnonymous ] ]
]

{ #category : 'accessing' }
CigStructure >> fieldNamed: aString [ 
	
	^ self fields detect: [ :each | each name = aString ]
]

{ #category : 'accessing' }
CigStructure >> fields [
	
	^ self elements select: [ :each | each isStructMember ]
]

{ #category : 'initialization' }
CigStructure >> fromCursor: aCursor [

	super fromCursor: aCursor.
	comment := aCursor rawComment.
	isPublic := aCursor isPublic
]

{ #category : 'testing' }
CigStructure >> hasComment [
	
	^ self comment isEmptyOrNil not
]

{ #category : 'testing' }
CigStructure >> isAbstract [

	^ self methods anySatisfy: [ :each | each isPureVirtual ]
]

{ #category : 'testing' }
CigStructure >> isAnonymous [
	
	^ self name includesSubstring: '(anonymous'
]

{ #category : 'testing' }
CigStructure >> isClass [

	^ self classMembers notEmpty 
		or: [ self isOpaque
		or: [ self fields anySatisfy: [ :each | each canBeFieldOfStructure not ] ] ]
]

{ #category : 'testing' }
CigStructure >> isNested [
	
	^ self parent isStructure
]

{ #category : 'testing' }
CigStructure >> isOpaque [

	^ elements isNil
]

{ #category : 'testing' }
CigStructure >> isPublic [

	^ self parent isPublic: self
]

{ #category : 'testing' }
CigStructure >> isStructure [

	^ true
]

{ #category : 'testing' }
CigStructure >> isTemplateSpecialization [

	^ '.*<.*>.*' asRegex matches: self name
]

{ #category : 'accessing' }
CigStructure >> phTemplate [
	
	^ CigPharoStructureTemplate for: self
]

{ #category : 'accessing' }
CigStructure >> resolveType [

	^ CigType new 
		parent: self;
		name: self name;
		typeReference: ((CigTypeReference newName: 'class ', self cppDeclaration)
			parent: self;
			yourself);
		yourself
]

{ #category : 'accessing' }
CigStructure >> superclass [

	^ self elements 
		detect: [ :each | each isSuperclass ]
		ifNone: [ nil ]
]
