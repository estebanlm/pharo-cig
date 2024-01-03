Class {
	#name : 'CigPharoGenerator',
	#superclass : 'Object',
	#instVars : [
		'visitor'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'instance creation' }
CigPharoGenerator class >> on: aVisitor [

	^ self new 
		visitor: aVisitor;
		yourself
]

{ #category : 'private' }
CigPharoGenerator >> cDeclarationOf: aType [

	aType ifNil: [ ^ 'void' ].
	^ aType cDeclaration
]

{ #category : 'private' }
CigPharoGenerator >> classFor: aName [

	^ self class environment at: aName asSymbol
]

{ #category : 'private' }
CigPharoGenerator >> commentOf: anElement [

	(self hasComments not or: [ anElement comment isEmptyOrNil ]) 
		ifTrue: [ ^ '' ].
	
	^ String streamContents: [ :stream | 
		stream tab.
		stream << '"'.
		anElement comment lines
			do: [ :line | stream << (line copyReplaceAll: '"' with: '""') trimmed ]
			separatedBy: [ stream cr; tab ].
		stream << '"'.
		stream cr ].
	
	
]

{ #category : 'private' }
CigPharoGenerator >> creatorMethodName: aConstructor [

	^ (String streamContents: [ :stream | 
			stream  <<  'new'.
			aConstructor parameters ifNotEmpty: [ :params |
				params first in: [ :each | 
					stream << each name capitalized << ': ' << each name << ' ' ].
				params allButFirst do: [ :each | 
					stream << each name << ': ' << each name << ' ' ] ] ])
		trimmed
]

{ #category : 'generating' }
CigPharoGenerator >> generateAutoRelease: aClass [
	| class template |
	
	class := self classFor: (aClass phDeclarationWith: self prefix).
	template := 'autoRelease
		
	FinalizationRegistry default add: self'.
	
	class compile: template classified: 'finalization'
]

{ #category : 'generating' }
CigPharoGenerator >> generateConstructor: aConstructor [
	| class template |

	class := self classFor: (aConstructor parent phDeclarationWith: self prefix).

	template := '{methodName}

	^ self ffiCall: #({type} {func}({arguments}))'
	format: {
		#methodName -> aConstructor phDeclaration.
		#type -> (self cDeclarationOf: aConstructor resolveReturnType).
		#func -> aConstructor cDeclaration.
		#arguments -> (self parametersList: aConstructor) }
		asDictionary.
	"install functions in class side"
	class class
		compile: template
		classified: 'private'
]

{ #category : 'generating' }
CigPharoGenerator >> generateCreator: aConstructor [
	| class template |

	class := self classFor: (aConstructor parent phDeclarationWith: self prefix).

	template := '{methodName}

	^ (self {cName}) "initialize"'
	format: {
		#methodName -> (self creatorMethodName: aConstructor).
		#cName -> aConstructor phDeclaration }
		asDictionary.
	"install functions in class side"
	class class
		compile: template
		classified: 'instance creation'
]

{ #category : 'generating' }
CigPharoGenerator >> generateDispose: aClass [
	| class template cDecl |
	
	class := self classFor: (aClass phDeclarationWith: self prefix).
	cDecl := aClass fullName, '_dispose'.
	template := 'dispose

	self ffiCall: #(void {cDecl}(self))'
	format: { 
		#cDecl -> cDecl 
	} asDictionary.
	
	class compile: template classified: 'finalization'
]

{ #category : 'generating' }
CigPharoGenerator >> generateFinalize: aClass [
	| class template |
	
	class := self classFor: (aClass phDeclarationWith: self prefix).
	template := 'finalize
		
	self dispose'.
	
	class compile: template classified: 'finalization'
]

{ #category : 'generating' }
CigPharoGenerator >> generateFunction: aFunction [
	| class template |

	class := self classFor: (aFunction parent phDeclarationWith: self prefix).
	
	template := '{methodName}
{comment}
	^ self ffiCall: #({type} {func}({arguments}))'
	format: {
		#methodName -> aFunction phDeclaration.
		#comment -> (self commentOf: aFunction).
		#type -> (self cDeclarationOf: aFunction resolveReturnType).
		#func -> aFunction cDeclaration.
		#arguments -> (self parametersList: aFunction) }
		asDictionary.
	"install functions in class side"
	class class 
		compile: template
		classified: 'functions'
]

{ #category : 'generating' }
CigPharoGenerator >> generateMethod: aMethod [
	| class template |

	class := self classFor: (aMethod parent phDeclarationWith: self prefix).
	
	template := '{methodName}
{comment}
	^ self ffiCall: #({type} {func}({arguments}))'
	format: {
		#methodName -> aMethod phDeclaration.
		#comment -> (self commentOf: aMethod). 
		#type -> (self cDeclarationOf: aMethod resolveReturnType).
		#func -> aMethod cDeclaration.
		#arguments -> (self methodParametersList: aMethod) }
		asDictionary.
	"install functions in class side"
	class
		compile: template
		classified: 'functions'
]

{ #category : 'testing' }
CigPharoGenerator >> hasComments [

	^ visitor file hasComments
]

{ #category : 'private' }
CigPharoGenerator >> methodParametersList: aNode [

	^ (self parametersList: aNode)
		ifNotEmpty: [ :aString | 'self, ', aString ]
		ifEmpty: [ 'self' ]
]

{ #category : 'private' }
CigPharoGenerator >> parameterDecl: aParameter [

	^ String streamContents: [ :stream |
		stream << (self cDeclarationOf: aParameter resolveType) << ' ' << aParameter name ]
]

{ #category : 'private' }
CigPharoGenerator >> parametersList: aNode [

	^ (aNode parameters collect: [ :each | self parameterDecl: each ]) asCommaString
]

{ #category : 'accessing' }
CigPharoGenerator >> prefix [
	
	^ visitor file prefix
]

{ #category : 'accessing' }
CigPharoGenerator >> visitor: aVisitor [

	visitor := aVisitor
]
