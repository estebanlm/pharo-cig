Class {
	#name : 'CigBaseTypedef',
	#superclass : 'CigElement',
	#traits : 'CigTTemplateSpecialization',
	#classTraits : 'CigTTemplateSpecialization classTrait',
	#instVars : [
		'underlyingTypeKind',
		'definesFunction',
		'definesArray',
		'underlyingTypeName'
	],
	#pools : [
		'CXTypeKind'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigBaseTypedef class >> kind [
	
	^ nil
]

{ #category : 'visiting' }
CigBaseTypedef >> accept: aVisitor [
	
	^ aVisitor visitTypedef: self
]

{ #category : 'accessing' }
CigBaseTypedef >> cTemplate [
	
	^ CigCTypedefTemplate for: self
]

{ #category : 'testing' }
CigBaseTypedef >> definesArray [

	^ definesArray
]

{ #category : 'testing' }
CigBaseTypedef >> definesFunction [

	^ definesFunction
]

{ #category : 'testing' }
CigBaseTypedef >> definesFunctionPointer [

	^ self definesFunction and: [ self underlyingTypeName includesSubstring: '(*)' ]
]

{ #category : 'initialization' }
CigBaseTypedef >> fromCursor: aCursor [
	| underlyingType |

	super fromCursor: aCursor.
	underlyingType := aCursor typedefDeclUnderlyingType.
	underlyingTypeName := underlyingType spelling.
	underlyingTypeKind := underlyingType kind.
	definesFunction := (underlyingTypeName beginsWith: 'std::function') 
		"or: [ 
			((underlyingTypeKind = CXType_Pointer or: [ underlyingTypeKind = CXType_MemberPointer ]) 
			and: [ underlyingType pointeeType resultType ~= CXType_Invalid ])"
		or: [ 
			underlyingTypeName matchesRegex: '.*\(.*\)' ].
	definesArray := underlyingTypeKind = CXType_ConstantArray 
			or: [ underlyingTypeKind = CXType_IncompleteArray
			or: [ underlyingTypeKind = CXType_VariableArray ] ].
		
	self checkForTemplateSpecialization: underlyingType name: underlyingTypeName
]

{ #category : 'testing' }
CigBaseTypedef >> isTypedef [

	^ true
]

{ #category : 'accessing' }
CigBaseTypedef >> phTemplate [
	
	^ CigPharoTypedefTemplate for: self
]

{ #category : 'accessing' }
CigBaseTypedef >> resolveType [
	
	^ CigType new
		parent: self;
		name: self name;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
CigBaseTypedef >> spelling [
]

{ #category : 'accessing' }
CigBaseTypedef >> underlyingTypeKind [

	^ underlyingTypeKind
]

{ #category : 'accessing' }
CigBaseTypedef >> underlyingTypeName [

	^ underlyingTypeName
]
