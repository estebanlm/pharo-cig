Class {
	#name : 'IGClass',
	#superclass : 'IGElement',
	#traits : 'IGTClass',
	#classTraits : 'IGTClass classTrait',
	#instVars : [
		'comment',
		'isDeclaration'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGClass class >> kind [

	^ CXCursor_ClassDecl
]

{ #category : 'visiting' }
IGClass >> accept: aVisitor [

	aVisitor visitClass: self
]

{ #category : 'testing' }
IGClass >> acceptNestedClasses [

	^ true
]

{ #category : 'accessing' }
IGClass >> cDeclaration [

	^ super cDeclaration, '*'
]

{ #category : 'accessing' }
IGClass >> cDisposeTemplate [
	
	^ IGCDisposeMethodTemplate for: self
]

{ #category : 'accessing' }
IGClass >> cTemplate [

	^ IGCClassTemplate for: self
]

{ #category : 'testing' }
IGClass >> canBeAddedTo: anElement [

	^ anElement acceptNestedClasses and: [ self isDeclaration not ]
]

{ #category : 'accessing' }
IGClass >> classMembers [

	^ self elements select: [ :each | each isClassMember ]
]

{ #category : 'accessing' }
IGClass >> comment [

	^ comment
]

{ #category : 'initialization' }
IGClass >> fromCursor: aCursor [

	super fromCursor: aCursor.
	comment := aCursor rawComment.
	isDeclaration := (aCursor source includesAll: '{}') not
]

{ #category : 'testing' }
IGClass >> isAbstract [

	^ self methods anySatisfy: [ :each | each isPureVirtual ]
]

{ #category : 'testing' }
IGClass >> isClass [

	^ true
]

{ #category : 'testing' }
IGClass >> isDeclaration [

	^ isDeclaration
]

{ #category : 'accessing' }
IGClass >> resolveType [

	^ IGType new 
		parent: self;
		name: self name;
		typeReference: ((IGTypeReference newName: 'class ', self name)
			parent: self;
			yourself);
		yourself
]

{ #category : 'accessing' }
IGClass >> superclass [

	^ self elements 
		detect: [ :each | each isSuperclass ]
		ifNone: [ nil ]
]
