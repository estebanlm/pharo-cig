"
This template handles structure parameters (e.g. struct mystruct arg).
template for returning structs is different because we need to copy from original struct to result struct (which is not the same).
"
Class {
	#name : 'CigCParameterStructTypeTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterStructTypeTemplate class >> handlesType: type [

	^ type isStructure 
		and: [ type isClass not
		and: [ type isPointer not ] ]
]

{ #category : 'generating' }
CigCParameterStructTypeTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << 'auto _tmp = ' << aString << ';'; cr.
		stream << self generateCType  << ' _result;'; cr.
		stream << 'memcpy(&_result, &_tmp, sizeof(' << self generateCType << '));'; cr.
		stream << 'return _result' ]
]

{ #category : 'generating' }
CigCParameterStructTypeTemplate >> generateArgument [
	| name |
	
	self type hasElement ifFalse: [ ^ self element name ]. 
	name := self type parseType name.
	^ String streamContents: [ :stream | 
		self type isReference 
			ifTrue: [ stream << '*' ].
		stream << '('.
		"a type struct may or may not come with implicit name"
		(name beginsWith: 'struct ')
			ifFalse: [ stream << 'struct ' ].
		stream << name.
		self type parseType arity timesRepeat: [ 
			stream << '*' ].
		stream << ')'. 
		stream << self element name ]
]

{ #category : 'generating' }
CigCParameterStructTypeTemplate >> generateCType [
	| typeName startArity parsed |
	
	typeName := (self elementAtPath: (self type typeReference typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
		ifNil: [ type name ].

	startArity := 0.
	parsed := self type parseType.
	
	^ String streamContents: [ :stream |
		stream << type element cTemplate structureType << ' ' << typeName.
		(1 + startArity) to: parsed arity do: [ :each |
			stream << '*' ] ]
]

{ #category : 'generating' }
CigCParameterStructTypeTemplate >> generateFFIType [
	
	^ (self elementAtPath: (self type typeReference typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
		ifNil: [ type name ]
]
