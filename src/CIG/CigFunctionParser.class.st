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

{ #category : 'parsing' }
CigFunctionParser class >> parseNamedFunction: anArray [

	^ self new parseNamedFunction: anArray
]

{ #category : 'accessing' }
CigFunctionParser >> parseType [
	" parse type name and optional number of asterisks, following it"
	| templates templateTypeName referenceMarker typeName pointerArity arrayNumber |

	typeName := stream next.
	typeName ifNil: [ ^ self error: 'type name expected' ].

	"skip 'const' , which is often used but has no any use for us "
	[ #('const' 'class' 'volatile' '_Complex') includes: typeName ]
	whileTrue: [
		typeName := stream next.
		typeName ifNil: [ ^ self error: 'type name expected' ] ].

	"parsing struct, union and enum types"
	(#('struct' 'union' 'enum') includes: typeName) 
		ifTrue: [ 
			| prefix |
			prefix := typeName.
			typeName := stream next.
			typeName ifNil: [ ^ self error: 'type name expected' ].
			typeName := prefix, ' ', typeName ].
		
	(typeName = 'unsigned') ifTrue: [ 
		stream atEnd 
			ifTrue: [ typeName = #uint ]
			ifFalse: [ typeName := ('u', stream next) asSymbol ] ].

	"extract template"
	(stream atEnd not and: [ (stream peek = #<) or: [ stream peek = #<! ] ]) ifTrue: [ 
		| enclosing |
		enclosing := 0.
		templates := #().
		templateTypeName := ''.
		stream next.
		[ (stream peek = #>) and: [ enclosing = 0 ] ] whileFalse: [
			stream peek = #< ifTrue: [ enclosing := enclosing + 1 ].
			stream peek = #> ifTrue: [ enclosing := enclosing - 1 ].
			(stream peek = #, and: [ enclosing = 0 ])
				ifTrue: [ 
					templates := templates copyWith: templateTypeName.
					templateTypeName := ''.
					stream next ] 
				ifFalse: [ 
					templateTypeName := templateTypeName, stream next asString ] ].
		templates := templates copyWith: templateTypeName.
		stream next ].
	
	"check for pointer (and reference)"
	referenceMarker := false.
	pointerArity := 0.
	[ stream atEnd not 
		and: [ stream peek isString 
		and: [ 
			(stream peek beginsWith: '*') 
			or: [ stream peek beginsWith: '&' ] ] ] ] 
	whileTrue: [ | pointerMarker |
		pointerMarker := stream next.
		self assert: ((pointerMarker allButLast allSatisfy: [ :ch | ch = $* ]) 
			and: [ #($* $&) includes: pointerMarker last ]).
		referenceMarker := referenceMarker or: [ pointerMarker last = $& ].
		pointerArity := pointerArity + pointerMarker size ].

	"check for array"
	(stream atEnd not 
		and: [ stream peek isString 
		and: [ stream peek beginsWith: '[' ] ]) 
	ifTrue: [ 
		stream next. "array start"
		arrayNumber := (stream peek isString and: [ stream peek beginsWith: ']' ])
			ifTrue: [ 0 ]
			ifFalse: [ stream next ].
		self assert: (stream next beginsWith: ']') ].

	^ {
		typeName. 
		pointerArity.		
		referenceMarker.
		templates.
		arrayNumber }
]

{ #category : 'accessing' }
CigFunctionParser >> setOn: aString [
	"add a space to > to ensure is parsed as a different symbol"

	^ super setOn: (aString 
		copyReplaceAll: '>' 
		with: ' > ')
]
