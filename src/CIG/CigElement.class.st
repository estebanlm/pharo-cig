Class {
	#name : 'CigElement',
	#superclass : 'Object',
	#traits : 'CigTElementContainer',
	#classTraits : 'CigTElementContainer classTrait',
	#instVars : [
		'name',
		'parent',
		'kind',
		'location'
	],
	#pools : [
		'CXCursorKind'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigElement class >> allNodes [

	^ self allSubclasses reject: [ :each | each kind isNil ]
]

{ #category : 'accessing' }
CigElement class >> delimiter [

	^ '_'
]

{ #category : 'instance creation' }
CigElement class >> fromCursor: aCursor [

	^ self new fromCursor: aCursor
]

{ #category : 'accessing' }
CigElement class >> kind [
	
	^ self subclassResponsibility
]

{ #category : 'instance creation' }
CigElement class >> newName: aString [
	"This is for testing purposes"

	^ self new
		name: aString;
		kind: self kind;
		yourself
]

{ #category : 'accessing' }
CigElement class >> nodesDictionary [

	^ self allNodes
		collect: [ :each | each kind -> each ]
		as: IdentityDictionary
]

{ #category : 'comparing' }
CigElement >> = other [

	^ self species = other species 
		and: [ self name = other name ]
]

{ #category : 'visiting' }
CigElement >> accept: aVisitor [

	self subclassResponsibility
]

{ #category : 'testing' }
CigElement >> acceptDataStructures [
	"data structures (composite types) in C++ are: classes, structs and unions"

	^ false
]

{ #category : 'visiting' }
CigElement >> acceptNameGenerator: aVisitor [

	^ aVisitor visitElement: self
]

{ #category : 'accessing' }
CigElement >> basename [
	"remove the basic name"
	
	^ self pathName
]

{ #category : 'accessing' }
CigElement >> cDeclaration [

	^ self fullNameWith: '_'
]

{ #category : 'testing' }
CigElement >> canBeAddedTo: anElement [

	^ true
]

{ #category : 'private' }
CigElement >> closestAccessSpecifierOf: anElement [

	^ (self elements copyUpTo: anElement) reversed 
		detect: [ :each | each isAccessSpecifier ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
CigElement >> cppDeclaration [

	^ self nameWith: '::'
]

{ #category : 'accessing' }
CigElement >> depth [
	
	^ self path size - 1
]

{ #category : 'accessing' }
CigElement >> elementAtPath: aPath [
	| current |

	current := self.
	aPath do: [ :each |
		current ifNil: [ ^ nil ].
		current := current findElementMatching: [ :eachElement | eachElement isEqualToPath: each ] ].
	^ current
]

{ #category : 'accessing' }
CigElement >> findDeepElementMatching: aBlock [

	(aBlock value: self) ifTrue: [ ^ self ].
	
	self elements do: [ :each | 
		(each findDeepElementMatching: aBlock) 
			ifNotNil: [ :found | ^ found ] ].
	
	^ nil
]

{ #category : 'initialization' }
CigElement >> fromCursor: aCursor [

	name := aCursor displayName.
	location := aCursor location fileName.
	kind := aCursor kind
]

{ #category : 'accessing' }
CigElement >> fullName [

	^ self fullNameWith: self class delimiter
]

{ #category : 'accessing' }
CigElement >> fullNameWith: delim [	

	^ String streamContents: [ :stream |
		| path |
		path := self path.
		self root shouldIncludeUnitPrefixOnFullName 
			ifFalse: [ path := path allButFirst ].
		path 
			do: [ :each | stream nextPutAll: each asString ] 
			separatedBy: [ stream nextPutAll: delim asString ] ]
]

{ #category : 'comparing' }
CigElement >> hash [

	^ self species hash bitXor: self name hash
]

{ #category : 'accessing' }
CigElement >> indexOfElementOfSameKind: anElement [
	"selects elements of same type of anElement and answer the index of 
	 in in such collection (this is useful to name anonymous structs/unions/enums)" 

	^ (self elements
		select: [ :each | each kind = anElement kind ]) 
		indexOf: anElement
]

{ #category : 'testing' }
CigElement >> isAccessSpecifier [

	^ false
]

{ #category : 'testing' }
CigElement >> isClass [

	^ false
]

{ #category : 'testing' }
CigElement >> isClassMember [

	^ false
]

{ #category : 'testing' }
CigElement >> isClassTemplate [

	^ false
]

{ #category : 'testing' }
CigElement >> isEnum [

	^ false
]

{ #category : 'testing' }
CigElement >> isEqualToPath: aString [

	^ self name = aString
]

{ #category : 'testing' }
CigElement >> isField [

	^ false
]

{ #category : 'testing' }
CigElement >> isFunction [

	^ false
]

{ #category : 'testing' }
CigElement >> isImportedNamespaceElement [
	
	^ false
]

{ #category : 'testing' }
CigElement >> isMacroDefinition [

	^ false
]

{ #category : 'testing' }
CigElement >> isMethod [

	^ false
]

{ #category : 'testing' }
CigElement >> isNamespace [

	^ false
]

{ #category : 'testing' }
CigElement >> isNamespaceReference [

	^ false
]

{ #category : 'testing' }
CigElement >> isNonTypeTemplateParameter [

	^ false
]

{ #category : 'testing' }
CigElement >> isParameter [

	^ false
]

{ #category : 'testing' }
CigElement >> isPublic [
		
	^ true
]

{ #category : 'testing' }
CigElement >> isPublic: anElement [

	^ true
]

{ #category : 'testing' }
CigElement >> isSpecial [
	
	^ false
]

{ #category : 'testing' }
CigElement >> isStructMember [

	^ false
]

{ #category : 'testing' }
CigElement >> isStructure [

	^ false
]

{ #category : 'testing' }
CigElement >> isSuperclass [

	^ false
]

{ #category : 'testing' }
CigElement >> isTemplateTypeParameter [
	
	^ false
]

{ #category : 'testing' }
CigElement >> isTypeReference [

	^ false
]

{ #category : 'testing' }
CigElement >> isTypedef [

	^ false
]

{ #category : 'testing' }
CigElement >> isUnion [

	^ false
]

{ #category : 'testing' }
CigElement >> isUnit [

	^ false
]

{ #category : 'testing' }
CigElement >> isUnknown [

	^ false
]

{ #category : 'testing' }
CigElement >> isUsingDeclaration [

	^ false
]

{ #category : 'testing' }
CigElement >> isVariable [

	^ false
]

{ #category : 'accessing' }
CigElement >> kind [

	^ kind
]

{ #category : 'private - utils' }
CigElement >> kind: aKind [
	
	kind := aKind
]

{ #category : 'accessing' }
CigElement >> location [

	^ location
]

{ #category : 'testing' }
CigElement >> matchesCursor: aCursor [

	^ self kind = aCursor kind 
		and: [ self name = aCursor displayName ]
]

{ #category : 'accessing' }
CigElement >> name [

	^ name
]

{ #category : 'private - utils' }
CigElement >> name: aString [
	
	name := aString
]

{ #category : 'accessing' }
CigElement >> nameWith: delim [ 

	^ String streamContents: [ :stream |
		"first element is the unit and we do not want that" 
		self path allButFirst 
			do: [ :each | stream nextPutAll: each asString ] 
			separatedBy: [ stream nextPutAll: delim asString ] ]
]

{ #category : 'accessing' }
CigElement >> parent [

	^ parent
]

{ #category : 'accessing' }
CigElement >> parent: anElement [

	parent := anElement
]

{ #category : 'accessing' }
CigElement >> path [

	self parent ifNil: [ ^ { self pathName } ].
	^ self parent path copyWith: self pathName
]

{ #category : 'accessing' }
CigElement >> pathName [

	^ self name
]

{ #category : 'accessing' }
CigElement >> phDeclaration [

	^ self root nameFor: self
]

{ #category : 'printing' }
CigElement >> printOn: stream [

	super printOn: stream.
	stream << '(' << self name << ')'
]

{ #category : 'accessing' }
CigElement >> root [

	^ self parent 
		ifNotNil: [ self parent root ]
		ifNil: [ self ]
]

{ #category : 'private' }
CigElement >> sanitizeName: aString [
	"used to avoid 'ugly' names (like prefix duplication).
	 but, in the case of prefix duplication that is not the case... example 
	 NoNoise... how to realise?"
	| prefix |
	
	prefix := self root prefix asLowercase.
	"same prefix"

	prefix isEmpty ifFalse: [
		((aString asLowercase beginsWith: prefix)
			"name bigger than prefix"
			and: [ aString size > prefix size
			"change of case"
			and: [ prefix last isLowercase and: [ (aString at: prefix size + 1) isUppercase ] ] ])
			ifTrue: [ ^ aString allButFirst: prefix size ]].

	^ aString capitalized
]

{ #category : 'accessing' }
CigElement >> sanitizedName [

	^ self sanitizeName: self name
]

{ #category : 'accessing' }
CigElement >> scopeLookup: aString [

	^ self scopeLookupPath: (CigType toTypePath: aString)
]

{ #category : 'accessing' }
CigElement >> scopeLookupPath: aPath [

	^ (self elementAtPath: aPath)
		ifNil: [ self parent scopeLookupPath: aPath ]
]

{ #category : 'private' }
CigElement >> typeReference [

	^ self elements
		detect: [ :each | each isTypeReference ]
		ifNone: [ nil ]
]

{ #category : 'private' }
CigElement >> typeReferences [

	^ self elements select: [ :each | each isTypeReference ]
]
