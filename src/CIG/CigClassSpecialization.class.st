Class {
	#name : 'CigClassSpecialization',
	#superclass : 'CigClass',
	#instVars : [
		'templateName'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'instance creation' }
CigClassSpecialization class >> fromClassTemplate: aClassTemplate [

	^ self new fromClassTemplate: aClassTemplate
]

{ #category : 'instance creation' }
CigClassSpecialization class >> fromClassTemplate: aClassTemplate specializedype: aString [

	^ self new 
		fromClassTemplate: aClassTemplate 
		specializedype: aString
]

{ #category : 'accessing' }
CigClassSpecialization class >> kind [

	^ nil
]

{ #category : 'private' }
CigClassSpecialization >> basicFromClassTemplate: aClassTemplate [

	parent := aClassTemplate parent.
	kind := self class kind.
	comment := aClassTemplate comment.
	isDeclaration := aClassTemplate isDeclaration
]

{ #category : 'accessing' }
CigClassSpecialization >> cppDeclaration [

	^ String streamContents: [ :stream |
		(self path allButFirst allButLast, { templateName })
			 asStringOn: stream 
			delimiter: '::' ]
]

{ #category : 'initialization' }
CigClassSpecialization >> fromClassTemplate: aClassTemplate [
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
CigClassSpecialization >> fromClassTemplate: aClassTemplate specializedype: aString [

	name := aClassTemplate basename, aString capitalized.
	templateName := String streamContents: [ :stream | 
		stream << aClassTemplate basename << '<' << aString << '>' ].
	self basicFromClassTemplate: aClassTemplate.
	"I am just interested in class members here"
	elements := aClassTemplate classMembers collect: [ :each | 
		(each asSpecializationOf: aClassTemplate type: aString)
			parent: self;
			yourself ]
]
