Class {
	#name : 'CigSpecialElement',
	#superclass : 'CigElement',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'accessing' }
CigSpecialElement class >> allElements [

	^ self allSubclasses collect: [ :each | each new ]
]

{ #category : 'accessing' }
CigSpecialElement class >> elementName [
	
^ self subclassResponsibility
]

{ #category : 'accessing' }
CigSpecialElement class >> kind [
	
	^ nil
]

{ #category : 'instance creation' }
CigSpecialElement class >> newParent: anElement [

	^ self new 
		parent: anElement;
		yourself
]

{ #category : 'visiting' }
CigSpecialElement >> accept: aVisitor [

]

{ #category : 'initialization' }
CigSpecialElement >> initialize [

	super initialize.
	self name: self class elementName
]
