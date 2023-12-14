Class {
	#name : 'IGFunctionParser',
	#superclass : 'FFIFunctionParser',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'parsing' }
IGFunctionParser class >> parse: aString [

	^ IGTypeDeclaration fromArray: (self new 
		setOn: aString;
		parseType)
]

{ #category : 'accessing' }
IGFunctionParser >> parseType [
	" parse type name and optional number of asterisks, following it"
	| referenceType typeName ptrArity |

	typeName := stream next.
	typeName ifNil: [ ^ self error: 'type name expected' ].

	"skip 'const' , which is often used but has no any use for us "
	(#('const' 'class' 'volatile') includes: typeName) 
		ifTrue: [
			typeName := stream next.
			typeName ifNil: [ ^ self error: 'type name expected' ] ].

	ptrArity := 0.
	[ stream atEnd not 
		and: [ stream peek isString 
		and: [ (stream peek beginsWith: '*') or: [ stream peek beginsWith: '&' ] ] ] ] 
	whileTrue: [ | pointerMarker |
		pointerMarker := stream next.
		self assert: ((pointerMarker allButLast allSatisfy: [ :e | e = $* ]) 
			and: [ #($* $&) includes: pointerMarker last ]).
		ptrArity := ptrArity + pointerMarker size ].

	referenceType := stream atEnd not 
		and: [ stream peek isString
		and: [ stream peek = '&' ] ].
		
	^ {
		typeName. 
		ptrArity.			
		referenceType }
]
