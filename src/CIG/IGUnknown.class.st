Class {
	#name : 'IGUnknown',
	#superclass : 'IGElement',
	#instVars : [
		'kindSpelling'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGUnknown class >> kind [

	^ nil
]

{ #category : 'accessing' }
IGUnknown class >> typeReferenceName [

	^ nil
]

{ #category : 'visiting' }
IGUnknown >> accept: aVisitor [

	aVisitor visitUnknown: self
]

{ #category : 'initialization' }
IGUnknown >> fromCursor: aCursor [

	super fromCursor: aCursor.
	kindSpelling := aCursor kindSpelling
]

{ #category : 'testing' }
IGUnknown >> isUnknown [

	^ true
]
