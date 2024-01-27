Class {
	#name : 'CigClassSpecialization',
	#superclass : 'CigClass',
	#instVars : [
		'templateName',
		'isAbstract',
		'superclass'
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
CigClassSpecialization class >> fromClassTemplate: aClassTemplate specializedTypes: aCollection [

	^ self new 
		fromClassTemplate: aClassTemplate 
		specializedTypes: aCollection
]

{ #category : 'accessing' }
CigClassSpecialization class >> kind [

	^ nil
]

{ #category : 'visiting' }
CigClassSpecialization >> accept: aVisitor [
	"this will be handled by the specialization caller"
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
	
	isAbstract := true.
	name := aClassTemplate basename.
	self basicFromClassTemplate: aClassTemplate.
	elements := #()
]

{ #category : 'initialization' }
CigClassSpecialization >> fromClassTemplate: aClassTemplate specializedTypes: aCollection [

	isAbstract := false.
	superclass := (CigSuperclass newName: aClassTemplate basename)
		parent: self;
		typePath: aClassTemplate parent path allButFirst, { aClassTemplate basename };
		yourself.
	name := aClassTemplate specializedNameWithTypes: aCollection.
	templateName := String streamContents: [ :stream | 
		stream << aClassTemplate basename << '<' << aCollection asCommaString << '>' ].
	self basicFromClassTemplate: aClassTemplate.
	"I am just interested in class members here"
	elements := aClassTemplate classMembers collect: [ :each | 
		(each asSpecializationOf: aClassTemplate types: aCollection)
			parent: self;
			yourself ]
]

{ #category : 'testing' }
CigClassSpecialization >> isAbstract [

	^ isAbstract
]

{ #category : 'accessing' }
CigClassSpecialization >> superclass [

	^ superclass ifNil: [ super superclass ]
]
