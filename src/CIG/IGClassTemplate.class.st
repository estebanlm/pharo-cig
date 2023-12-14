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

	^ (super fullName copyUpTo: $<), '*'
]

{ #category : 'accessing' }
IGClassTemplate >> cppDeclaration [

	^ super cppDeclaration copyUpTo: $<
]

{ #category : 'testing' }
IGClassTemplate >> isEqualToPath: aString [

	^ (super isEqualToPath: aString) or: [ self baseName = aString ]
]
