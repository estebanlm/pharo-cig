Class {
	#name : 'IGEnumConstant',
	#superclass : 'IGElement',
	#instVars : [
		'value'
	],
	#category : 'LibClang-IG',
	#package : 'LibClang-IG'
}

{ #category : 'visiting' }
IGEnumConstant >> accept: aVisitor [
	"enum constant are taken by their parent"
]

{ #category : 'initialization' }
IGEnumConstant >> fromCursor: aCursor [

	super fromCursor: aCursor.
	value := aCursor enumConstantValue.
]

{ #category : 'testing' }
IGEnumConstant >> matchesCursor: aCursor [

	^ aCursor isEnumConstantDeclaration and: [ aCursor displayName = self name ]
]

{ #category : 'evaluating' }
IGEnumConstant >> value [

	^ value
]
