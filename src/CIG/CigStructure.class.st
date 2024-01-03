Class {
	#name : 'CigStructure',
	#superclass : 'CigElement',
	#traits : 'CigTClass',
	#classTraits : 'CigTClass classTrait',
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
CigStructure >> acceptNestedClasses [

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

{ #category : 'accessing' }
CigStructure >> classMembers [

	^ self elements select: [ :each | each isClassMember ]
]

{ #category : 'accessing' }
CigStructure >> fields [
	
	^ self elements select: [ :each | each isStructMember ]
]

{ #category : 'testing' }
CigStructure >> isAbstract [

	^ self methods anySatisfy: [ :each | each isPureVirtual ]
]

{ #category : 'testing' }
CigStructure >> isAnonymous [
	
	^ self name beginsWith: '(anonymous'
]

{ #category : 'testing' }
CigStructure >> isClass [

	^ self classMembers notEmpty or: [ self isOpaque ]
]

{ #category : 'testing' }
CigStructure >> isOpaque [

	^ elements isNil
]

{ #category : 'testing' }
CigStructure >> isStructMember [

	^ true
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
		typeReference: ((CigTypeReference newName: 'class ', self name)
			parent: self;
			yourself);
		yourself
]
