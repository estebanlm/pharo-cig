Class {
	#name : 'CigUnknown',
	#superclass : 'CigElement',
	#instVars : [
		'kindSpelling'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigUnknown class >> kind [

	^ nil
]

{ #category : 'accessing' }
CigUnknown class >> typeReferenceName [

	^ nil
]

{ #category : 'visiting' }
CigUnknown >> accept: aVisitor [

	aVisitor visitUnknown: self
]

{ #category : 'initialization' }
CigUnknown >> fromCursor: aCursor [

	super fromCursor: aCursor.
	kindSpelling := aCursor kindSpelling
]

{ #category : 'testing' }
CigUnknown >> isUnknown [

	^ true
]
