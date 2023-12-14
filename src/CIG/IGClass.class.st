Class {
	#name : 'IGClass',
	#superclass : 'IGElement',
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
IGClass >> methods [

	^ self elements select: [ :each | each isMethod ]
]

{ #category : 'accessing' }
IGClass >> superclass [

	^ self elements 
		detect: [ :each | each isSuperclass ]
		ifNone: [ nil ]
]
