Class {
	#name : 'IGNamespace',
	#superclass : 'IGElement',
	#instVars : [
		'elements'
	],
	#category : 'LibClang-IG',
	#package : 'LibClang-IG'
}

{ #category : 'instance creation' }
IGNamespace class >> fromCursor: aCursor [

	^ self new fromCursor: aCursor
]

{ #category : 'visiting' }
IGNamespace >> accept: aVisitor [

	aVisitor visitNamespace: self
]

{ #category : 'accessing' }
IGNamespace >> addElement: anElement [

	anElement parent: self.
	elements add: anElement
]

{ #category : 'accessing' }
IGNamespace >> addEnum: anEnum [ 
	
	self addElement: anEnum
]

{ #category : 'accessing' }
IGNamespace >> elements [

	^ elements
]

{ #category : 'accessing' }
IGNamespace >> findElementMatching: aBlock [
		
	(super findElementMatching: aBlock) ifNotNil: [ ^ self ].
	self elements do: [ :each | 
		(each findElementMatching: aBlock) 
			ifNotNil: [ :found | ^ found ] ].
	^ nil
]

{ #category : 'accessing' }
IGNamespace >> findElementMatchingCursor: aParent [

	(super findElementMatchingCursor: aParent) ifNotNil: [ ^ self ].
	self elements do: [ :each | 
		(each findElementMatchingCursor: aParent) 
			ifNotNil: [ :found | ^ found ] ].
	^ nil
]

{ #category : 'initialization' }
IGNamespace >> initialize [

	super initialize.
	elements := OrderedCollection new
]

{ #category : 'testing' }
IGNamespace >> matchesCursor: aCursor [

	^ aCursor isNamespace and: [ aCursor displayName = name ]
]
