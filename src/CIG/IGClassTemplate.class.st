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

{ #category : 'accessing' }
IGClassTemplate >> baseName [

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

	^ (super isEqualToPath: aString) or: [ self baseName = aString ]
]
