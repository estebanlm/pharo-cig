Class {
	#name : 'CigClass',
	#superclass : 'CigElement',
	#traits : 'CigTClass',
	#classTraits : 'CigTClass classTrait',
	#instVars : [
		'comment',
		'isDeclaration',
		'isPublic'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigClass class >> kind [

	^ CXCursor_ClassDecl
]

{ #category : 'accessing' }
CigClass class >> typeReferenceName [
	"prefix included in IGTypeReference"
	
	^ 'class'
]

{ #category : 'visiting' }
CigClass >> accept: aVisitor [

	aVisitor visitClass: self
]

{ #category : 'testing' }
CigClass >> acceptNestedClasses [

	^ true
]

{ #category : 'accessing' }
CigClass >> cDeclaration [

	^ super cDeclaration, '*'
]

{ #category : 'accessing' }
CigClass >> cDisposeTemplate [
	
	^ CigCDisposeMethodTemplate for: self
]

{ #category : 'accessing' }
CigClass >> cTemplate [

	^ CigCClassTemplate for: self
]

{ #category : 'testing' }
CigClass >> canBeAddedTo: anElement [

	^ anElement acceptNestedClasses and: [ self isDeclaration not ]
]

{ #category : 'accessing' }
CigClass >> classMembers [

	^ self elements select: [ :each | each isClassMember ]
]

{ #category : 'accessing' }
CigClass >> comment [

	^ comment
]

{ #category : 'initialization' }
CigClass >> fromCursor: aCursor [

	super fromCursor: aCursor.
	comment := aCursor rawComment.
	isDeclaration := (aCursor source includesAll: '{}') not.
	isPublic := aCursor isPublic
]

{ #category : 'testing' }
CigClass >> hasComment [
	
	^ self comment isEmptyOrNil not
]

{ #category : 'testing' }
CigClass >> isAbstract [

	^ self methods anySatisfy: [ :each | each isPureVirtual ]
]

{ #category : 'testing' }
CigClass >> isClass [

	^ true
]

{ #category : 'testing' }
CigClass >> isDeclaration [

	^ isDeclaration
]

{ #category : 'testing' }
CigClass >> isPublic [

	^ isPublic
]

{ #category : 'testing' }
CigClass >> isPublic: anElement [

	^ (self closestAccessSpecifierOf: anElement)
		ifNotNil: [ :accessElement | accessElement isPublic ]
		ifNil: [ true ]
]

{ #category : 'accessing' }
CigClass >> resolveType [

	^ CigType new 
		parent: self;
		name: self name;
		typeReference: ((CigTypeReference newName: 'class ', self cppDeclaration)
			parent: self;
			yourself);
		yourself
]

{ #category : 'accessing' }
CigClass >> superclass [

	^ self elements 
		detect: [ :each | each isSuperclass ]
		ifNone: [ nil ]
]
