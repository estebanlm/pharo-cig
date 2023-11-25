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
	| parsedType |

	parsedType := super parseType.
			
	parsedType := parsedType copyWith: (stream atEnd not 
		and: [ stream peek isString
		and: [ stream peek = '&' ] ]).	

	^ parsedType
]
