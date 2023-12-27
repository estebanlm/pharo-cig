Class {
	#name : 'IGSpecialElement',
	#superclass : 'IGElement',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'accessing' }
IGSpecialElement class >> allElements [

	^ self allSubclasses collect: [ :each | each new ]
]

{ #category : 'accessing' }
IGSpecialElement class >> elementName [
	
^ self subclassResponsibility
]

{ #category : 'accessing' }
IGSpecialElement class >> kind [
	
	^ nil
]

{ #category : 'instance creation' }
IGSpecialElement class >> newParent: anElement [

	^ self new 
		parent: anElement;
		yourself
]

{ #category : 'visiting' }
IGSpecialElement >> accept: aVisitor [

]

{ #category : 'initialization' }
IGSpecialElement >> initialize [

	super initialize.
	self name: self class elementName
]
