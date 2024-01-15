Class {
	#name : 'CigAccessSpecifier',
	#superclass : 'CigElement',
	#classTraits : '{} + TraitedClass',
	#instVars : [
		'accessSpecifier'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigAccessSpecifier class >> kind [
	
	^ CXCursor_CXXAccessSpecifier
]

{ #category : 'visiting' }
CigAccessSpecifier >> accept: aVisitor [

]

{ #category : 'initialization' }
CigAccessSpecifier >> fromCursor: aCursor [

	super fromCursor: aCursor.
	accessSpecifier := aCursor cxxAccessSpecifier.
	"assigning an UUID to make it unique"
	name := UUID new asString
]

{ #category : 'testing' }
CigAccessSpecifier >> isAccessSpecifier [

	^ true
]

{ #category : 'testing' }
CigAccessSpecifier >> isPrivate [

	^ accessSpecifier = 3
]

{ #category : 'testing' }
CigAccessSpecifier >> isProtected [

	^ accessSpecifier = 2
]

{ #category : 'testing' }
CigAccessSpecifier >> isPublic [

	^ accessSpecifier = 1
]
