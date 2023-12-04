Class {
	#name : 'IGCClassGenerator',
	#superclass : 'IGCGenerator',
	#category : 'CIG-Generate-C',
	#package : 'CIG',
	#tag : 'Generate-C'
}

{ #category : 'private' }
IGCClassGenerator >> addClassDispose: aClass [

	aClass isAbstract ifTrue: [ ^ self ].

	self hStream << ('void {name}_dispose({cClass} self);' 
		format: { 
			#name -> aClass fullName.
			#cClass -> aClass cDeclaration } 
		asDictionary).
	self hStream cr.
	
	self cStream << ('void {name}_dispose({cClass} self) \{
	delete ({cppClass} *)self;
\}' 
		format: { 
			#name -> aClass fullName.
			#cClass -> aClass cDeclaration.
			#cppClass -> aClass cppDeclaration } 
		asDictionary).
	self cStream cr
]

{ #category : 'private' }
IGCClassGenerator >> addClassTypedef: aClass [

	self hStream << ('typedef void {1};' format: { aClass fullName  }).
	self hStream cr
]

{ #category : 'private' }
IGCClassGenerator >> basicFunctionCallOf: aMethod [
	
	^ '(({classCast})self)->{func}({arguments})' 
		format: { 
			#func -> aMethod spelling.
			#arguments -> (self argumentsListToCPP: aMethod).
			#classCast -> (self cppCastForSelf: aMethod parent) }
		asDictionary
]

{ #category : 'private' }
IGCClassGenerator >> cppCastForSelf: aNode [

	^ aNode cppDeclaration, '*'
]

{ #category : 'private' }
IGCClassGenerator >> defaultCastOf: aMethod call: aString [
	| cast |
	
	cast := self cCastToReturn: aMethod resolveReturnType.
	^ '{return}{returnCast}{call}' 
		format: { 
			#call -> (cast 
				ifNotEmpty: [ '(', aString, ')' ]
				ifEmpty: [ aString ]).
			#returnCast -> cast.
			#return -> (aMethod isReturnTypeVoid 
				ifTrue: [ '' ]
				ifFalse: [ 'return ' ]) }
		asDictionary
]

{ #category : 'private' }
IGCClassGenerator >> findClass: aName [

	^ self root findDeepElementMatching: [ :each | each isClass and: [ each name = aName ] ]
]

{ #category : 'private' }
IGCClassGenerator >> functionCall: aMethod [
	| template |
	
	template := self basicFunctionCallOf: aMethod.
	aMethod resolveReturnType
		ifTranslated: [ :translation | ^ translation cppToC: template from: aMethod  ].
			
	^ self defaultCastOf: aMethod call: template
]

{ #category : 'generating' }
IGCClassGenerator >> generateClass: aClass [
	
	self root: aClass root.

	self addClassTypedef: aClass.
	self addClassDispose: aClass
]

{ #category : 'generating' }
IGCClassGenerator >> generateConstructor: aConstructor [
	| header body |
	
	self root: aConstructor root.

	header := '{type} {methodName}({parameters});' 
		format: { 
			#type -> (self cDeclarationOf: aConstructor resolveReturnType).
			#methodName -> aConstructor cDeclaration.
			#parameters -> (self parametersList: aConstructor) }
		asDictionary	.
	self hStream << header << String cr.

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

	self cStream << body << String cr
]

{ #category : 'generating' }
IGCClassGenerator >> generateMethod: aMethod [
	| header body |
	
	self root: aMethod root.

	header := '{type} {methodName}({parameters});' 
		format: { 
			#type -> (self cDeclarationOf: aMethod resolveReturnType).
			#methodName -> aMethod cDeclaration.
			#parameters -> (self selfParametersList: aMethod) }
		asDictionary	.
	self hStream << header << String cr.
	
	body := '{type} {methodName}({parameters}) \{
	{functionCall};
\}' format: { 
		#type -> (self cDeclarationOf: aMethod resolveReturnType).
		#methodName -> aMethod cDeclaration.
		#parameters -> (self selfParametersList: aMethod).
		#functionCall -> (self functionCall: aMethod) } 
	asDictionary.

	self cStream << body << String cr
]

{ #category : 'private' }
IGCClassGenerator >> selfParametersList: anElement [

	^ String streamContents: [ :stream |
		stream 
			<< anElement parent cDeclaration
			<< ' self'.
		(super parametersList: anElement) 
			ifNotEmpty: [ :aString | stream << ', ' << aString ] ]
]
