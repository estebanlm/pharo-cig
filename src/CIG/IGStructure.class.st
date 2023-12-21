Class {
	#name : 'IGStructure',
	#superclass : 'IGElement',
	#traits : 'IGTClass',
	#classTraits : 'IGTClass classTrait',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGStructure class >> kind [
	
	^ CXCursor_StructDecl
]

{ #category : 'visiting' }
IGStructure >> accept: aVisitor [

	aVisitor visitStructure: self
]

{ #category : 'testing' }
IGStructure >> acceptNestedClasses [

	^ true
]

{ #category : 'accessing' }
IGStructure >> cDeclaration [
	"since a struct in c++ can act as a class, we need to answer its kind as a structure 
	 of as a class, depending the case"
	| decl |
	
	decl := super cDeclaration.
	^ self isClass 
		ifTrue: [ decl, '*' ]
		ifFalse: [ decl ]
]

{ #category : 'accessing' }
IGStructure >> cDisposeTemplate [
	
	^ IGCDisposeMethodTemplate for: self
]

{ #category : 'accessing' }
IGStructure >> cTemplate [
	
	^ IGCStructTemplate for: self
]

{ #category : 'accessing' }
IGStructure >> classMembers [

	^ self elements select: [ :each | each isClassMember ]
]

{ #category : 'accessing' }
IGStructure >> fields [
	
	^ self elements select: [ :each | each isField or: [ each isVariable ] ]
]

{ #category : 'testing' }
IGStructure >> isAbstract [

	^ self methods anySatisfy: [ :each | each isPureVirtual ]
]

{ #category : 'testing' }
IGStructure >> isClass [

	^ self classMembers notEmpty or: [ self isOpaque ]
]

{ #category : 'testing' }
IGStructure >> isOpaque [

	^ elements isNil
]

{ #category : 'testing' }
IGStructure >> isStructure [

	^ true
]

{ #category : 'testing' }
IGStructure >> isTemplateSpecialization [

	^ '.*<.*>.*' asRegex matches: self name
]

{ #category : 'accessing' }
IGStructure >> resolveType [

	^ IGType new 
		parent: self;
		name: self name;
		typeReference: ((IGTypeReference newName: 'class ', self name)
			parent: self;
			yourself);
		yourself
]
