Class {
	#name : 'CigEnumConstant',
	#superclass : 'CigElement',
	#instVars : [
		'value'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigEnumConstant class >> kind [

	^ CXCursor_EnumConstantDecl
]

{ #category : 'visiting' }
CigEnumConstant >> accept: aVisitor [
	"enum constant are taken by their parent"
]

{ #category : 'initialization' }
CigEnumConstant >> fromCursor: aCursor [

	super fromCursor: aCursor.
	value := aCursor enumConstantValue.
]

{ #category : 'evaluating' }
CigEnumConstant >> value [

	^ value
]
