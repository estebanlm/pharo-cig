Class {
	#name : 'CigConstructor',
	#superclass : 'CigClassMember',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigConstructor class >> kind [
	
	^ CXCursor_Constructor
]

{ #category : 'visiting' }
CigConstructor >> accept: aVisitor [

	aVisitor visitConstructor: self
]

{ #category : 'accessing' }
CigConstructor >> cDeclaration [

	^ self disambiguate: (String streamContents: [ :stream | 
		stream 
			<<  (self parent fullNameWith: '_')
			<< '_new' ])
]

{ #category : 'accessing' }
CigConstructor >> cTemplate [
	
	^ CigCMethodTemplate for: self
]

{ #category : 'accessing' }
CigConstructor >> cppDeclaration [

	^ self parent cppDeclaration
]

{ #category : 'testing' }
CigConstructor >> isConstructor [

	^ true
]

{ #category : 'accessing' }
CigConstructor >> phDeclaration [
	| params |

	^ (String streamContents: [ :stream | 
			stream 
				<< (self disambiguate: self spelling arguments: self parameters) uncapitalized 
				<< '_new'.
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
CigConstructor >> resolveReturnType [

	^ CigType new
		parent: self;
		name: self parent cppDeclaration;
		typeReference: ((CigTypeReference newName: 'class ', self parent cppDeclaration)
			parent: self;
			yourself);
		yourself
]

{ #category : 'private' }
CigConstructor >> specializeClassTemplate: aClassTemplate type: typeString [

	super specializeClassTemplate: aClassTemplate type: typeString.
	name := name 
		copyReplaceAll: aClassTemplate name 
		with: (aClassTemplate basename, typeString capitalized).
	spelling := spelling 
		copyReplaceAll: aClassTemplate name
		with: 	aClassTemplate basename, typeString capitalized
]
