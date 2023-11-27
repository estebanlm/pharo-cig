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
