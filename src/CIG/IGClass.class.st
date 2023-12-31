Class {
	#name : 'IGClass',
	#superclass : 'IGElement',
	#traits : 'IGTClass',
	#classTraits : 'IGTClass classTrait',
	#instVars : [
		'comment',
		'isDeclaration'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGClass class >> kind [

	^ CXCursor_ClassDecl
]

{ #category : 'visiting' }
IGClass >> accept: aVisitor [

	aVisitor visitClass: self
]

{ #category : 'testing' }
IGClass >> acceptNestedClasses [

	^ true
]

{ #category : 'initialization' }
IGClass >> basicFromClassTemplate: aClassTemplate [

	parent := aClassTemplate parent.
	kind := self class kind.
	comment := aClassTemplate comment.
	isDeclaration := aClassTemplate isDeclaration
]

{ #category : 'accessing' }
IGClass >> cDeclaration [

	^ super cDeclaration, '*'
]

{ #category : 'accessing' }
IGClass >> cDisposeTemplate [
	
	^ IGCDisposeMethodTemplate for: self
]

{ #category : 'accessing' }
IGClass >> cTemplate [

	^ IGCClassTemplate for: self
]

{ #category : 'testing' }
IGClass >> canBeAddedTo: anElement [

	^ anElement acceptNestedClasses and: [ self isDeclaration not ]
]

{ #category : 'accessing' }
IGClass >> classMembers [

	^ self elements select: [ :each | each isClassMember ]
]

{ #category : 'accessing' }
IGClass >> comment [

	^ comment
]

{ #category : 'initialization' }
IGClass >> fromClassTemplate: aClassTemplate [
	"this is used to construct the specialised class superclass"
	
	name := aClassTemplate basename.
	self basicFromClassTemplate: aClassTemplate.
	elements := (aClassTemplate elements 
		reject: [ :each | each isClassMember and: [ each isTemplateOf: aClassTemplate ] ])
		collect: [ :each | 
			each copy
				parent: self;
				yourself ]
]

{ #category : 'initialization' }
IGClass >> fromClassTemplate: aClassTemplate specializedype: aString [

	name := aClassTemplate basename, aString capitalized.
	self basicFromClassTemplate: aClassTemplate.
	"I am just interested in class members here"
	elements := aClassTemplate classMembers
		select: [ :each | each isTemplateOf: aClassTemplate ]
		thenCollect: [ :each | 
			(each asSpecializationOf: aClassTemplate type: aString)
				parent: self;
				yourself ]
]

{ #category : 'initialization' }
IGClass >> fromCursor: aCursor [

	super fromCursor: aCursor.
	comment := aCursor rawComment.
	isDeclaration := (aCursor source includesAll: '{}') not
]

{ #category : 'testing' }
IGClass >> isAbstract [

	^ self methods anySatisfy: [ :each | each isPureVirtual ]
]

{ #category : 'testing' }
IGClass >> isClass [

	^ true
]

{ #category : 'testing' }
IGClass >> isDeclaration [

	^ isDeclaration
]

{ #category : 'accessing' }
IGClass >> resolveType [

	^ IGType new 
		parent: self;
		name: self name;
		typeReference: ((IGTypeReference newName: 'class ', self cppDeclaration)
			parent: self;
			yourself);
		yourself
]

{ #category : 'accessing' }
IGClass >> superclass [

	^ self elements 
		detect: [ :each | each isSuperclass ]
		ifNone: [ nil ]
]
