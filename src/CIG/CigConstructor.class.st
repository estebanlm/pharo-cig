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

{ #category : 'instance creation' }
CigConstructor class >> newDefaultConstructorOf: aClass [ 
	
	^ self new forClass: aClass
]

{ #category : 'visiting' }
CigConstructor >> accept: aVisitor [

	aVisitor visitConstructor: self
]

{ #category : 'accessing' }
CigConstructor >> cDeclaration [

	^ self disambiguateName: (String streamContents: [ :stream | 
		stream 
			<<  (self parent fullNameWith: '_')
			<< '_new' ])
]

{ #category : 'accessing' }
CigConstructor >> cTemplate [
	
	^ CigCMethodTemplate for: self
]

{ #category : 'testing' }
CigConstructor >> canBeExported [

	"abstract classes do not have constructors"
	self parent isAbstract ifTrue: [ ^ false ].

	^ super canBeExported
]

{ #category : 'accessing' }
CigConstructor >> cppDeclaration [

	^ self parent cppDeclaration
]

{ #category : 'initialization' }
CigConstructor >> forClass: aClass [
	
	name := aClass name, '()'.
	kind := self class kind.
	spelling := aClass name.
	returnTypeName := 'void'.
	isPublic := true.
	isDeleted := false.
	isVariadic := false.
	parameters := #()
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
				<< (self disambiguateName: self spelling arguments: self parameters) uncapitalized 
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
CigConstructor >> specializeClassTemplate: aClassTemplate types: aCollection [
	| className |

	super specializeClassTemplate: aClassTemplate types: aCollection.
	className := aClassTemplate specializedNameWithTypes: aCollection.
	name := name copyReplaceAll: aClassTemplate name with: className.
	spelling := spelling copyReplaceAll: aClassTemplate name with: className
]
