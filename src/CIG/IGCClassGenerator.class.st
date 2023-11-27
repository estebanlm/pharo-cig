Class {
	#name : 'IGCClassGenerator',
	#superclass : 'IGCGenerator',
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'private' }
IGCClassGenerator >> addClassTypedef: aClass [

	self outStream << ('typedef void {1};' format: { aClass fullName  }).
	self outStream cr
]

{ #category : 'private' }
IGCClassGenerator >> cppCastForSelf: aNode [

	^ aNode cppDeclaration, '*'
]

{ #category : 'private' }
IGCClassGenerator >> findClass: aName [

	^ self root findDeepElementMatching: [ :each | each isClass and: [ each name = aName ] ]
]

{ #category : 'generating' }
IGCClassGenerator >> generateClass: aClass [
	
	self root: aClass root.
	self addClassTypedef: aClass.
	self outStream cr
]

{ #category : 'generating' }
IGCClassGenerator >> generateMethod: aMethod [
	| body |
	
	self root: aMethod root.

	body := '{type} {methodName}({parameters}) \{
	{return}{returnCast}(({classCast})self)->{func}({arguments}\);
\}' format: { 
		#type -> (self cDeclarationOf: aMethod resolveReturnType).
		#methodName -> (self methodDeclarationOf: aMethod).
		#parameters -> (self parametersList: aMethod).
		#func -> aMethod spelling.
		#arguments -> (self argumentsListToCPP: aMethod).
		#returnCast -> (self cCastToReturn: aMethod resolveReturnType).
		#classCast -> (self cppCastForSelf: aMethod parent).
		#return -> (aMethod isReturnTypeVoid 
			ifTrue: [ '' ]
			ifFalse: [ 'return ' ]) }
		asDictionary	.
			
	self outStream << body << String cr.
]

{ #category : 'private' }
IGCClassGenerator >> methodDeclarationOf: aMethod [
	"We need to disambiguate potential multimethods"
	| methods |
	
	methods := aMethod parent elements 
		select: [ :each | (each kind = aMethod kind) and: [ each basename = aMethod basename  ] ].
	"this is the regular case"
	methods size = 1 ifTrue: [ ^ aMethod cDeclaration ].
	
	^ String streamContents: [ :stream |
		stream << aMethod cDeclaration << '_' <<  (methods indexOf: aMethod) asString ]
]

{ #category : 'private' }
IGCClassGenerator >> parametersList: anElement [

	^ String streamContents: [ :stream |
		stream 
			<< anElement parent fullName
			<< '* self'.
		(super parametersList: anElement) 
			ifNotEmpty: [ :aString | stream << ', ' << aString ] ]
]
