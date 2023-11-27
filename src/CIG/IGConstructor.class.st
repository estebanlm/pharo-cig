Class {
	#name : 'IGConstructor',
	#superclass : 'IGClassMember',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGConstructor class >> kind [
	
	^ CXCursor_Constructor
]

{ #category : 'visiting' }
IGConstructor >> accept: aVisitor [

	aVisitor visitConstructor: self
]

{ #category : 'accessing' }
IGConstructor >> cDeclaration [

	^ String streamContents: [ :stream | 
		stream 
			<<  (self parent fullNameWith: '_')
			<< '_new' ]
]

{ #category : 'accessing' }
IGConstructor >> cppDeclaration [

	^ self parent cppDeclaration
]

{ #category : 'handling' }
IGConstructor >> resolveReturnType [

	^ IGType new
		parent: self;
		name: self parent cppDeclaration, '*';
		reference: (IGTypeReference newName: 'class ', self parent cppDeclaration);
		yourself	
]
