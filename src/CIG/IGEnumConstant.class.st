Class {
	#name : 'IGEnumConstant',
	#superclass : 'IGElement',
	#instVars : [
		'value'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGEnumConstant class >> kind [

	^ CXCursor_EnumConstantDecl
]

{ #category : 'visiting' }
IGEnumConstant >> accept: aVisitor [
	"enum constant are taken by their parent"
]

{ #category : 'initialization' }
IGEnumConstant >> fromCursor: aCursor [

	super fromCursor: aCursor.
	value := aCursor enumConstantValue.
]

{ #category : 'evaluating' }
IGEnumConstant >> value [

	^ value
]
