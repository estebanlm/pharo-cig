Class {
	#name : 'IGCClassGenerator',
	#superclass : 'IGCGenerator',
	#category : 'CIG-Generate-C',
	#package : 'CIG',
	#tag : 'Generate-C'
}

{ #category : 'private' }
IGCClassGenerator >> addClassDispose: aClass [

	self outStream << ('void {cClass}_dispose({cClass}* self) \{
	delete ({cppClass} *)self;
\}' format: { 
	#cClass -> aClass cDeclaration.
	#cppClass -> aClass cppDeclaration. 
	} asDictionary).
	self outStream cr
]

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
	self outStream cr.
	self addClassDispose: aClass.
	self outStream cr	
]

{ #category : 'generating' }
IGCClassGenerator >> generateConstructor: aConstructor [
	| body |
	
	self root: aConstructor root.

	body := '{type} {methodName}({parameters}) \{
	{return}{returnCast}(new {func}({arguments}\));
\}' format: { 
		#type -> (self cDeclarationOf: aConstructor resolveReturnType).
		#methodName -> aConstructor cDeclaration.
		#parameters -> (self parametersList: aConstructor).
		#func -> aConstructor cppDeclaration.
		#arguments -> (self argumentsListToCPP: aConstructor).
		#returnCast -> (self cCastToReturn: aConstructor resolveReturnType).
		#classCast -> (self cppCastForSelf: aConstructor parent).
		#return -> 'return ' }
		asDictionary	.
			
	self outStream << body << String cr.
	
]

{ #category : 'generating' }
IGCClassGenerator >> generateMethod: aMethod [
	| body |
	
	self root: aMethod root.

	body := '{type} {methodName}({parameters}) \{
	{return}{returnCast}(({classCast})self)->{func}({arguments}\);
\}' format: { 
		#type -> (self cDeclarationOf: aMethod resolveReturnType).
		#methodName -> aMethod cDeclaration.
		#parameters -> (self selfParametersList: aMethod).
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
IGCClassGenerator >> selfParametersList: anElement [

	^ String streamContents: [ :stream |
		stream 
			<< anElement parent cDeclaration
			<< '* self'.
		(super parametersList: anElement) 
			ifNotEmpty: [ :aString | stream << ', ' << aString ] ]
]
