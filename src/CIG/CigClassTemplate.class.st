Class {
	#name : 'CigClassTemplate',
	#superclass : 'CigClass',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigClassTemplate class >> kind [

	^ CXCursor_ClassTemplate
]

{ #category : 'visiting' }
CigClassTemplate >> accept: aVisitor [

	aVisitor visitClassTemplate: self
]

{ #category : 'converting' }
CigClassTemplate >> addSubclassWithSpecializedType: aString [
	"this creates the subclass an adds it as element (so it can be found in the 
	 generating process)"
	| specializedClass |
	
	specializedClass := self asSubclassWithSpecializedType: aString.
	self flag: #TODO. "ensure a replace. Demeters law!"
	self parent elements remove: specializedClass ifAbsent: [  ].
	self parent addElement: specializedClass.
	^ specializedClass
]

{ #category : 'converting' }
CigClassTemplate >> asBaseClass [
	
	^ CigClassSpecialization fromClassTemplate: self
]

{ #category : 'converting' }
CigClassTemplate >> asSubclassWithSpecializedType: aString [ 
	
	^ CigClassSpecialization 
		fromClassTemplate: self 
		specializedype: aString
]

{ #category : 'accessing' }
CigClassTemplate >> basename [

	^ self name copyUpTo: $<
]

{ #category : 'accessing' }
CigClassTemplate >> cDeclaration [

	^ (self fullName copyUpTo: $<), '*'
]

{ #category : 'accessing' }
CigClassTemplate >> cDeclarationWithSpecialization: typesCollection [

	typesCollection ifEmpty: [ ^ self cDeclaration ].
	
	^ String streamContents: [ :stream |
		stream << (self fullName copyUpTo: $<).
		typesCollection do: [ :each | stream << each capitalized ].
		stream << '*' ]
]

{ #category : 'accessing' }
CigClassTemplate >> cppDeclaration [

	^ super cppDeclaration copyUpTo: $<
]

{ #category : 'accessing' }
CigClassTemplate >> cppDeclarationWithSpecialization: typesCollection [

	typesCollection ifEmpty: [ ^ self cDeclaration ].
	
	^ String streamContents: [ :stream |
		stream << self cppDeclaration.
		stream << '<'.
		typesCollection 
			do: [ :each | stream << each ]
			separatedBy: [ stream << ', ' ].
		stream << '>' ]
]

{ #category : 'testing' }
CigClassTemplate >> isClassTemplate [

	^ true
]

{ #category : 'testing' }
CigClassTemplate >> isEqualToPath: aString [

	^ (super isEqualToPath: aString) or: [ self basename = aString ]
]

{ #category : 'accessing' }
CigClassTemplate >> templateTypeParameters [
	
	^ self elements select: [ :each | each isTemplateTypeParameter ]
]

{ #category : 'accessing' }
CigClassTemplate >> typeSpecializations [

	^ self root typeSpecializationsOf: self basename
]
