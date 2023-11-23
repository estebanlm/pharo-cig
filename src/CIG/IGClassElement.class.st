Class {
	#name : 'IGClassElement',
	#superclass : 'IGElement',
	#instVars : [
		'returnTypeName',
		'spelling'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGClassElement class >> kind [
	
	^ nil
]

{ #category : 'initialization' }
IGClassElement >> fromCursor: aCursor [

	super fromCursor: aCursor.
	returnTypeName := aCursor type resultType spelling.
	spelling := aCursor spelling	
]

{ #category : 'accessing' }
IGClassElement >> returnTypeName [

	^ returnTypeName
]

{ #category : 'accessing' }
IGClassElement >> spelling [

	^ spelling
]
