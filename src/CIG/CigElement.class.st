Class {
	#name : 'CigElement',
	#superclass : 'Object',
	#traits : 'CigTElementContainer',
	#classTraits : 'CigTElementContainer classTrait',
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
CigElement >> acceptNestedClasses [

	^ false
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
	kind := aCursor kind
]

{ #category : 'accessing' }
CigElement >> fullName [

	^ self fullNameWith: self class delimiter
]

{ #category : 'accessing' }
CigElement >> fullNameWith: delim [ 

	^ String streamContents: [ :stream |
		self path asStringOn: stream delimiter: delim ]
]

{ #category : 'comparing' }
CigElement >> hash [

	^ self species hash bitXor: self name hash
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
CigElement >> isMethod [

	^ false
]

{ #category : 'testing' }
CigElement >> isNamespace [

	^ false
]

{ #category : 'testing' }
CigElement >> isParameter [

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
		self path allButFirst asStringOn: stream delimiter: delim ]
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

	^ String streamContents: [ :stream | 
		stream 
			<< self root prefix capitalized 
			<< self name capitalized ]
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
CigElement >> typeReference [

	^ self elements 
		detect: [ :each | each isTypeReference ]
		ifNone: [ nil ]
]

{ #category : 'private' }
CigElement >> typeReferences [

	^ self elements select: [ :each | each isTypeReference ]
]
