Class {
	#name : 'IGMethod',
	#superclass : 'IGClassMember',
	#instVars : [
		'isPublic'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGMethod class >> kind [
	
	^ CXCursor_CXXMethod
]

{ #category : 'visiting' }
IGMethod >> accept: aVisitor [

	aVisitor visitMethod: self
]

{ #category : 'converting' }
IGMethod >> asFunctionDeclarationWithPrefix: prefix delimiter: delim [
	| parsed |

	^ String streamContents: [ :stream |
		parsed := self parseReturnType.
		parsed isReference 
			ifTrue: [ stream << parsed name << ' *' ]
			ifFalse: [ 
				stream << self returnTypeName.
				self returnTypeName last isAlphaNumeric ifTrue: [ 
					stream space ] ].
		
		stream 
			<< prefix << delim
			<< self spelling 
			<< '(' << self parametersAsList << ')' ]
]

{ #category : 'converting' }
IGMethod >> asFunctionSourceWithPrefix: prefix delimiter: delim [
	
	^ '{declaration} \{
	{return}{cast}(({classCast})self)->{func}({arguments});
\}' 
	format: { 
		#declaration -> (self asFunctionDeclarationWithPrefix: prefix delimiter: delim).
		#func -> self spelling.
		#arguments -> self argumentsAsList.
		#cast -> self castReturnString.
		#classCast -> self castClassString.
		#return -> (self isReturnTypeVoid 
			ifTrue: [ '' ]
			ifFalse: [ 'return ' ]) }
		asDictionary
]

{ #category : 'private' }
IGMethod >> castClassString [

	^ self parent name, ' *'
]

{ #category : 'private' }
IGMethod >> castReturnString [
	| return |

	return := self parseReturnType.
	return isReference ifFalse: [ ^ '' ].
	^ '({1}*)&' format: { return name }
]

{ #category : 'initialization' }
IGMethod >> fromCursor: aCursor [

	super fromCursor: aCursor.
	isPublic := aCursor cxxAccessSpecifier = 1
]

{ #category : 'testing' }
IGMethod >> isOperator [

	^ (self name beginsWith: 'operator') 
		and: [ (self name allButFirst: 8) isAllAlphaNumerics ]
]

{ #category : 'testing' }
IGMethod >> isPublic [

	^ isPublic
]

{ #category : 'converting' }
IGMethod >> parametersAsList [
	
	^ String streamContents: [ :stream |
			stream 
				<< self parent name 
				<< ' *self'.
			super parametersAsList ifNotEmpty: [ :aString | 
				stream << ', ' << aString ] ]
]

{ #category : 'private' }
IGMethod >> parseReturnType [
	
	^ IGFunctionParser parse: self returnTypeName
]
