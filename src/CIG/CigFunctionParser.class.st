Class {
	#name : 'CigFunctionParser',
	#superclass : 'FFIFunctionParser',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'parsing' }
CigFunctionParser class >> parse: aString [

	^ CigTypeDeclaration fromArray: (self new 
		setOn: aString;
		parseType)
]

{ #category : 'accessing' }
CigFunctionParser >> parseType [
	" parse type name and optional number of asterisks, following it"
	| templateTypeName referenceMarker typeName ptrArity |

	typeName := stream next.
	typeName ifNil: [ ^ self error: 'type name expected' ].

	"skip 'const' , which is often used but has no any use for us "
	(#('const' 'class' 'volatile') includes: typeName) 
		ifTrue: [
			typeName := stream next.
			typeName ifNil: [ ^ self error: 'type name expected' ] ].

	"parsing struct types"
	(#('struct') includes: typeName) 
		ifTrue: [ 
			| prefix |
			prefix := typeName.
			typeName := stream next.
			typeName ifNil: [ ^ self error: 'type name expected' ].
			typeName := prefix, ' ', typeName ].

	"extract template"
	(stream atEnd not and: [ stream peek = #< ]) ifTrue: [ 
		templateTypeName := ''.
		stream next.
		[ stream peek = #> ] whileFalse: [ 
			templateTypeName := templateTypeName, stream next ].
		stream next ].
	
	referenceMarker := false.
	ptrArity := 0.
	[ stream atEnd not 
		and: [ stream peek isString 
		and: [ (stream peek beginsWith: '*') or: [ stream peek beginsWith: '&' ] ] ] ] 
	whileTrue: [ | pointerMarker |
		pointerMarker := stream next.
		self assert: ((pointerMarker allButLast allSatisfy: [ :e | e = $* ]) 
			and: [ #($* $&) includes: pointerMarker last ]).
		referenceMarker := referenceMarker or: [ pointerMarker last = $& ].
		ptrArity := ptrArity + pointerMarker size ].
		
	^ {
		typeName. 
		ptrArity.			
		referenceMarker.
		templateTypeName }
]

{ #category : 'accessing' }
CigFunctionParser >> setOn: aString [
	"add a space to > to ensure is parsed as a different symbol"

	^ super setOn: (aString 
		copyReplaceAll: '>' 
		with: '> ')
]
