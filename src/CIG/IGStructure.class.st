Class {
	#name : 'IGStructure',
	#superclass : 'IGElement',
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

	^ self classMembers notEmpty
]

{ #category : 'testing' }
IGStructure >> isTemplateSpecialization [

	^ '.*<.*>.*' asRegex matches: self name
]

{ #category : 'accessing' }
IGStructure >> methods [

	^ self elements select: [ :each | each isMethod ]
]
