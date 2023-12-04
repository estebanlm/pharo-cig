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

	^ self disambiguate: (String streamContents: [ :stream | 
		stream 
			<<  (self parent fullNameWith: '_')
			<< '_new' ])
]

{ #category : 'accessing' }
IGConstructor >> cppDeclaration [

	^ self parent cppDeclaration
]

{ #category : 'accessing' }
IGConstructor >> phDeclaration [
	| params |

	^ (String streamContents: [ :stream | 
			stream  << self spelling uncapitalized << '_new'.
			(params := self parameters) size = 1
				ifTrue: [ 
					stream << ': ' << params first name  ]
				ifFalse: [  
					self parameters do: [ :each | 
						stream 
							<< each name  
							<< ': ' 
							<< each name 
							<< ' ' ] ] ])
		trimmed
]

{ #category : 'handling' }
IGConstructor >> resolveReturnType [

	^ IGType new
		parent: self;
		name: self parent cppDeclaration;
		typeReference: ((IGTypeReference newName: 'class ', self parent cppDeclaration)
			parent: self;
			yourself);
		yourself
]
