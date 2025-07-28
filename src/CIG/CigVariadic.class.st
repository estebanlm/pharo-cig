Class {
	#name : 'CigVariadic',
	#superclass : 'CigElement',
	#instVars : [
		'selector',
		'declaration',
		'parsedFunction'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigVariadic class >> kind [

	^ nil
]

{ #category : 'instance creation' }
CigVariadic class >> newDeclaration: aString selector: aSelector [

	^ self new
		declaration: aString;
		selector: aSelector;
		yourself
]

{ #category : 'visiting' }
CigVariadic >> accept: aVisitor [

	aVisitor visitVariadic: self
]

{ #category : 'accessing' }
CigVariadic >> cDeclaration [

	^ self declaration
]

{ #category : 'accessing' }
CigVariadic >> declaration [

	^ declaration
]

{ #category : 'accessing' }
CigVariadic >> declaration: aString [

	declaration := aString.
	self parseDeclaration
]

{ #category : 'testing' }
CigVariadic >> isReturnTypeVoid [
	| returnType |

	returnType := self parsedFunction returnType.
	^ returnType name = #void
		and: [ returnType arity = 0 ]
]

{ #category : 'accessing' }
CigVariadic >> location [

	^ 'generated'
]

{ #category : 'private' }
CigVariadic >> parseDeclaration [

	parsedFunction := CigFunctionParser parseNamedFunction: self declaration.
	name := String streamContents: [ :stream | 
		stream << parsedFunction functionName. 
		stream << '('.
		parsedFunction arguments 
			do: [ :each |
				stream << each type name.
				stream space.
				each type arity timesRepeat: [ stream << '*' ].
				stream << each name ]
			separatedBy: [ stream << ', ' ].
		stream << ')' ]
]

{ #category : 'accessing' }
CigVariadic >> parsedFunction [

	^ parsedFunction
]

{ #category : 'accessing' }
CigVariadic >> phTemplate [
	
	^ CigPharoVariadicTemplate for: self
]

{ #category : 'accessing' }
CigVariadic >> selector [

	^ selector
]

{ #category : 'accessing' }
CigVariadic >> selector: aSelector [

	selector := aSelector
]
