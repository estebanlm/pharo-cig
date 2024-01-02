Class {
	#name : 'IGTypeReference',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGTypeReference class >> kind [
	
	^ CXCursor_TypeRef
]

{ #category : 'dependencies' }
IGTypeReference class >> typeReferenceClasses [
	
	^ { IGClass. IGStructure. IGEnum }
]

{ #category : 'visiting' }
IGTypeReference >> accept: aVisitor [

	"Used by its parent"
]

{ #category : 'testing' }
IGTypeReference >> isClass [

	^ self referenceType = IGClass
]

{ #category : 'testing' }
IGTypeReference >> isStructure [

	^ self referenceType = IGStructure
]

{ #category : 'testing' }
IGTypeReference >> isTypeReference [

	^ true
]

{ #category : 'testing' }
IGTypeReference >> isUnknownReference [

	^ self referenceType = IGUnknown
]

{ #category : 'accessing' }
IGTypeReference >> namePath [
	
	^ self typeName substrings: '::'
]

{ #category : 'private' }
IGTypeReference >> referenceName [

	^ self referenceType typeReferenceName
]

{ #category : 'private' }
IGTypeReference >> referenceNamePrefixFor: typeName [

	self referenceName ifNotNil: [ :aName | ^ aName, ' ', typeName ].
	
	(self root elementAtPath: (typeName substrings: '::')) ifNotNil: [ :anElement | 
		^ anElement class typeReferenceName, ' ', anElement cppDeclaration ].

	^ typeName
]

{ #category : 'accessing' }
IGTypeReference >> referenceType [
	| typeString |

	typeString := self name copyUpTo: Character space.
	^ self class typeReferenceClasses 
		detect: [ :each | each typeReferenceName = typeString ]
		ifNone: [ IGUnknown ]

]

{ #category : 'private' }
IGTypeReference >> specializeTypeClassTemplate: aClassTemplate type: typeString [
	| newTypeName |

	newTypeName := IGType 
		replaceTypeClassTemplate: aClassTemplate
		type:typeString
		in: self typeName.
		
	name := self referenceNamePrefixFor: newTypeName
]

{ #category : 'private' }
IGTypeReference >> specializeTypeTemplate: aClassTemplate type: typeString [
	| newTypeName |

	newTypeName := IGType 
		replaceTypeTemplate: aClassTemplate
		type:typeString
		in: self typeName.
		
	name := self referenceNamePrefixFor: newTypeName
]

{ #category : 'accessing' }
IGTypeReference >> typeBasename [
	
	^ self typeName copyAfterLast: $:
]

{ #category : 'accessing' }
IGTypeReference >> typeKind [
	
	^ self referenceType kind
]

{ #category : 'accessing' }
IGTypeReference >> typeName [

	^ (self name includes: Character space) 
		ifTrue: [ self name copyAfter: Character space ]
		ifFalse: [ self name ]

]
