"
Special elements are used to include into the node tree elements that wont be parsed but are nevertheless needed for a correct translation.
An example of this is the std:: namespace, the standard library of C++ from which we just take what we need (and just to translate it).
"
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
	^ nil
]

{ #category : 'initialization' }
CigSpecialElement >> initialize [

	super initialize.
	self name: self class elementName
]
