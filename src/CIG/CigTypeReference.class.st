Class {
	#name : 'CigTypeReference',
	#superclass : 'CigElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigTypeReference class >> kind [
	
	^ CXCursor_TypeRef
]

{ #category : 'dependencies' }
CigTypeReference class >> typeReferenceClasses [
	
	^ { CigClass. CigStructure. CigEnum }
]

{ #category : 'visiting' }
CigTypeReference >> accept: aVisitor [

	"Used by its parent"
]

{ #category : 'testing' }
CigTypeReference >> isClass [

	^ self referenceType = CigClass
]

{ #category : 'testing' }
CigTypeReference >> isStructure [

	^ self referenceType = CigStructure
]

{ #category : 'testing' }
CigTypeReference >> isTypeReference [

	^ true
]

{ #category : 'testing' }
CigTypeReference >> isUnknownReference [

	^ self referenceType = CigUnknown
]

{ #category : 'accessing' }
CigTypeReference >> namePath [
	
	^ self typeName substrings: '::'
]

{ #category : 'private' }
CigTypeReference >> referenceName [

	^ self referenceType typeReferenceName
]

{ #category : 'private' }
CigTypeReference >> referenceNamePrefixFor: typeName [

	self referenceName ifNotNil: [ :aName | ^ aName, ' ', typeName ].
	
	(self root elementAtPath: (typeName substrings: '::')) ifNotNil: [ :anElement | 
		^ anElement class typeReferenceName, ' ', anElement cppDeclaration ].

	^ typeName
]

{ #category : 'accessing' }
CigTypeReference >> referenceType [
	| typeString |

	typeString := self name copyUpTo: Character space.
	^ self class typeReferenceClasses 
		detect: [ :each | each typeReferenceName = typeString ]
		ifNone: [ CigUnknown ]

]

{ #category : 'private' }
CigTypeReference >> specializeTypeClassTemplate: aClassTemplate type: typeString [
	| newTypeName |

	newTypeName := CigType 
		replaceTypeClassTemplate: aClassTemplate
		type:typeString
		in: self typeName.
		
	name := self referenceNamePrefixFor: newTypeName
]

{ #category : 'private' }
CigTypeReference >> specializeTypeTemplate: aClassTemplate type: typeString [
	| newTypeName |

	newTypeName := CigType 
		replaceTypeTemplate: aClassTemplate
		type:typeString
		in: self typeName.
		
	name := self referenceNamePrefixFor: newTypeName
]

{ #category : 'accessing' }
CigTypeReference >> typeBasename [
	
	^ self typeName copyAfterLast: $:
]

{ #category : 'accessing' }
CigTypeReference >> typeKind [
	
	^ self referenceType kind
]

{ #category : 'accessing' }
CigTypeReference >> typeName [

	^ (self name includes: Character space) 
		ifTrue: [ self name copyAfter: Character space ]
		ifFalse: [ self name ]

]
