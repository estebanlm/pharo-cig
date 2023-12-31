Class {
	#name : 'IGClassTemplate',
	#superclass : 'IGClass',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGClassTemplate class >> kind [

	^ CXCursor_ClassTemplate
]

{ #category : 'visiting' }
IGClassTemplate >> accept: aVisitor [

	aVisitor visitClassTemplate: self
]

{ #category : 'adding' }
IGClassTemplate >> addSubclassWithSpecializedType: aString [ 
	"this creates the subclass an adds it as element (so it can be found in the 
	 generating process)"
	| specializedClass |
	
	specializedClass := self asSubclassWithSpecializedType: aString.
	self parent addElement: specializedClass.
	^ specializedClass
]

{ #category : 'converting' }
IGClassTemplate >> asBaseClass [
	
	^ IGClass new fromClassTemplate: self
]

{ #category : 'converting' }
IGClassTemplate >> asSubclassWithSpecializedType: aString [ 
	
	^ IGClass new 
		fromClassTemplate: self 
		specializedype: aString
]

{ #category : 'accessing' }
IGClassTemplate >> basename [

	^ self name copyUpTo: $<
]

{ #category : 'accessing' }
IGClassTemplate >> cDeclaration [

	^ (self fullName copyUpTo: $<), '*'
]

{ #category : 'accessing' }
IGClassTemplate >> cDeclarationWithSpecialization: typesCollection [

	typesCollection ifEmpty: [ ^ self cDeclaration ].
	
	^ String streamContents: [ :stream |
		stream << (self fullName copyUpTo: $<).
		typesCollection do: [ :each | stream << each capitalized ].
		stream << '*' ]
]

{ #category : 'accessing' }
IGClassTemplate >> cppDeclaration [

	^ super cppDeclaration copyUpTo: $<
]

{ #category : 'accessing' }
IGClassTemplate >> cppDeclarationWithSpecialization: typesCollection [

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
IGClassTemplate >> isClassTemplate [

	^ true
]

{ #category : 'testing' }
IGClassTemplate >> isEqualToPath: aString [

	^ (super isEqualToPath: aString) or: [ self basename = aString ]
]

{ #category : 'accessing' }
IGClassTemplate >> templateTypeParameters [
	
	^ self elements select: [ :each | each isTemplateTypeParameter ]
]

{ #category : 'accessing' }
IGClassTemplate >> typeSpecializations [

	^ self root typeSpecializationsOf: self basename
]
