Class {
	#name : 'IGElement',
	#superclass : 'Object',
	#traits : 'IGTElementContainer',
	#classTraits : 'IGTElementContainer classTrait',
	#instVars : [
		'name',
		'parent',
		'kind'
	],
	#pools : [
		'CXCursorKind'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGElement class >> allNodes [

	^ self allSubclasses reject: [ :each | each kind isNil ]
]

{ #category : 'accessing' }
IGElement class >> delimiter [

	^ '_'
]

{ #category : 'instance creation' }
IGElement class >> fromCursor: aCursor [

	^ self new fromCursor: aCursor
]

{ #category : 'accessing' }
IGElement class >> kind [
	
	^ self subclassResponsibility
]

{ #category : 'instance creation' }
IGElement class >> newName: aString [
	"This is for testing purposes"

	^ self new
		name: aString;
		kind: self kind;
		yourself
]

{ #category : 'accessing' }
IGElement class >> nodesDictionary [

	^ self allNodes
		collect: [ :each | each kind -> each ]
		as: IdentityDictionary
]

{ #category : 'comparing' }
IGElement >> = other [

	^ self species = other species 
		and: [ self name = other name ]
]

{ #category : 'visiting' }
IGElement >> accept: aVisitor [

	self subclassResponsibility
]

{ #category : 'testing' }
IGElement >> acceptNestedClasses [

	^ false
]

{ #category : 'accessing' }
IGElement >> basename [
	"remove the basic name"
	
	^ self pathName
]

{ #category : 'accessing' }
IGElement >> cDeclaration [

	^ self fullNameWith: '_'
]

{ #category : 'testing' }
IGElement >> canBeAddedTo: anElement [

	^ true
]

{ #category : 'accessing' }
IGElement >> cppDeclaration [

	^ self nameWith: '::'
]

{ #category : 'accessing' }
IGElement >> depth [
	
	^ self path size - 1
]

{ #category : 'accessing' }
IGElement >> elementAtPath: aPath [
	| current |

	current := self.
	aPath do: [ :each |
		current := current findElementMatching: [ :eachElement | eachElement isEqualToPath: each ] ].
	^ current
]

{ #category : 'accessing' }
IGElement >> findDeepElementMatching: aBlock [

	(aBlock value: self) ifTrue: [ ^ self ].
	
	self elements do: [ :each | 
		(each findDeepElementMatching: aBlock) 
			ifNotNil: [ :found | ^ found ] ].
	
	^ nil
]

{ #category : 'initialization' }
IGElement >> fromCursor: aCursor [

	name := aCursor displayName.
	kind := aCursor kind
]

{ #category : 'accessing' }
IGElement >> fullName [

	^ self fullNameWith: self class delimiter
]

{ #category : 'accessing' }
IGElement >> fullNameWith: delim [ 

	^ String streamContents: [ :stream |
		self path asStringOn: stream delimiter: delim ]
]

{ #category : 'comparing' }
IGElement >> hash [

	^ self species hash bitXor: self name hash
]

{ #category : 'testing' }
IGElement >> isClass [

	^ false
]

{ #category : 'testing' }
IGElement >> isClassMember [

	^ false
]

{ #category : 'testing' }
IGElement >> isClassTemplate [

	^ false
]

{ #category : 'testing' }
IGElement >> isEnum [

	^ false
]

{ #category : 'testing' }
IGElement >> isEqualToPath: aString [

	^ self name = aString
]

{ #category : 'testing' }
IGElement >> isField [

	^ false
]

{ #category : 'testing' }
IGElement >> isFunction [

	^ false
]

{ #category : 'testing' }
IGElement >> isMethod [

	^ false
]

{ #category : 'testing' }
IGElement >> isNamespace [

	^ false
]

{ #category : 'testing' }
IGElement >> isParameter [

	^ false
]

{ #category : 'testing' }
IGElement >> isStructure [

	^ false
]

{ #category : 'testing' }
IGElement >> isSuperclass [

	^ false
]

{ #category : 'testing' }
IGElement >> isTemplateTypeParameter [
	
	^ false
]

{ #category : 'testing' }
IGElement >> isTypeReference [

	^ false
]

{ #category : 'testing' }
IGElement >> isTypedef [

	^ false
]

{ #category : 'testing' }
IGElement >> isUnknown [

	^ false
]

{ #category : 'testing' }
IGElement >> isUsingDeclaration [

	^ false
]

{ #category : 'testing' }
IGElement >> isVariable [

	^ false
]

{ #category : 'accessing' }
IGElement >> kind [

	^ kind
]

{ #category : 'private - utils' }
IGElement >> kind: aKind [
	
	kind := aKind
]

{ #category : 'testing' }
IGElement >> matchesCursor: aCursor [

	^ self kind = aCursor kind 
		and: [ self name = aCursor displayName ]
]

{ #category : 'accessing' }
IGElement >> name [

	^ name
]

{ #category : 'private - utils' }
IGElement >> name: aString [
	
	name := aString
]

{ #category : 'accessing' }
IGElement >> nameWith: delim [ 

	^ String streamContents: [ :stream |
		"first element is the unit and we do not want that" 
		self path allButFirst asStringOn: stream delimiter: delim ]
]

{ #category : 'accessing' }
IGElement >> parent [

	^ parent
]

{ #category : 'accessing' }
IGElement >> parent: anElement [

	parent := anElement
]

{ #category : 'accessing' }
IGElement >> path [

	self parent ifNil: [ ^ { self pathName } ].
	^ self parent path copyWith: self pathName
]

{ #category : 'accessing' }
IGElement >> pathName [

	^ self name
]

{ #category : 'accessing' }
IGElement >> phDeclarationWith: aPrefix [

	^ (aPrefix, self name capitalized) asSymbol
]

{ #category : 'printing' }
IGElement >> printOn: stream [

	super printOn: stream.
	stream << '(' << self name << ')'
]

{ #category : 'accessing' }
IGElement >> root [

	^ self parent 
		ifNotNil: [ self parent root ]
		ifNil: [ self ]
]

{ #category : 'private' }
IGElement >> typeReference [

	^ self elements 
		detect: [ :each | each isTypeReference ]
		ifNone: [ nil ]
]
