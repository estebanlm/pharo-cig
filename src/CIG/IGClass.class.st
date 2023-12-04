Class {
	#name : 'IGClass',
	#superclass : 'IGElement',
	#instVars : [
		'comment'
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

{ #category : 'accessing' }
IGClass >> cDeclaration [

	^ super cDeclaration, '*'
]

{ #category : 'accessing' }
IGClass >> comment [

	^ comment
]

{ #category : 'initialization' }
IGClass >> fromCursor: aCursor [

	super fromCursor: aCursor.
	comment := aCursor rawComment
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
IGClass >> methods [

	^ self elements select: [ :each | each isMethod ]
]

{ #category : 'accessing' }
IGClass >> superclass [

	^ self elements 
		detect: [ :each | each isSuperclass ]
		ifNone: [ nil ]
]
