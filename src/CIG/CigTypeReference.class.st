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
	
	^ { CigClass. CigStructure. CigUnion. CigEnum }
]

{ #category : 'visiting' }
CigTypeReference >> accept: aVisitor [

	"Used by its parent"
]

{ #category : 'testing' }
CigTypeReference >> canBeAddedTo: aParent [

	^ aParent isUnit not
]

{ #category : 'testing' }
CigTypeReference >> isClass [

	^ self referenceType = CigClass
]

{ #category : 'testing' }
CigTypeReference >> isEnum [

	^ self referenceType = CigEnum
]

{ #category : 'testing' }
CigTypeReference >> isReferenceAnonymous [

	^ CigType isAnonymous: self typeName
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
CigTypeReference >> isUnion [

	^ self referenceType = CigUnion
]

{ #category : 'testing' }
CigTypeReference >> isUnknownReference [

	^ self referenceType = CigUnknown
]

{ #category : 'accessing' }
CigTypeReference >> matchingElementInUnit [

	(self parent scopeLookupPath: self namePath) ifNotNil: [ :anElement | ^ anElement ].
	"sometimes, it happens that this reference is splitted into a namespace reference and a 
	 type reference, in that case the namespace referece should be contained in the parent."
	self parent elements 
		detect: [ :each | each isNamespaceReference ]
		ifFound: [ :aReference | 
			^ self scopeLookupPath: (CigType toTypePath: aReference name), self namePath ].
	
	^ nil
]

{ #category : 'accessing' }
CigTypeReference >> namePath [
	
	^ CigType toTypePath: self typeName
]

{ #category : 'private' }
CigTypeReference >> referenceName [

	^ self referenceType typeReferenceName
]

{ #category : 'private' }
CigTypeReference >> referenceNamePrefixFor: typeName [

	self referenceName ifNotNil: [ :aName | ^ aName, ' ', typeName ].
	
	(self root elementAtPath: (CigType toTypePath: typeName)) 
		ifNotNil: [ :anElement | 
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
CigTypeReference >> specializeTypeClassTemplate: aClassTemplate types: typeString [
	| newTypeName |

	newTypeName := CigType 
		replaceTypeClassTemplate: aClassTemplate
		type:typeString
		in: self typeName.
		
	name := self referenceNamePrefixFor: newTypeName
]

{ #category : 'private' }
CigTypeReference >> specializeTypeTemplate: aClassTemplate types: typeString [
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
