Class {
	#name : 'IGClassMember',
	#superclass : 'IGElement',
	#traits : 'IGTFunction',
	#classTraits : 'IGTFunction classTrait',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGClassMember class >> kind [
	
	^ nil
]

{ #category : 'private' }
IGClassMember >> disambiguate: aString [
	| methods |
	
	methods := self parent elements 
		select: [ :each | (each kind = self kind) and: [ each basename = self basename  ] ].
	
	"this is the regular case"
	methods size = 1 
		ifTrue: [ ^ aString ].
	
	"I need to dissambiguate"
	^ String streamContents: [ :stream |
		stream << aString << '_' <<  (methods indexOf: self) asString ]
]

{ #category : 'initialization' }
IGClassMember >> fromCursor: aCursor [

	super fromCursor: aCursor.
	self fillFunctionWith: aCursor
]

{ #category : 'accessing' }
IGClassMember >> pathName [

	^ self spelling
]

{ #category : 'accessing' }
IGClassMember >> returnTypeName [

	^ returnTypeName
]

{ #category : 'accessing' }
IGClassMember >> spelling [

	^ spelling
]
