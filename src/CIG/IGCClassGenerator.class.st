Class {
	#name : 'IGCClassGenerator',
	#superclass : 'IGCGenerator',
	#category : 'CIG-Generate-C',
	#package : 'CIG',
	#tag : 'Generate-C'
}

{ #category : 'private' }
IGCClassGenerator >> addClassTypedef: aClass [

	visitor addTypedef: #void as: aClass fullName
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
IGCClassGenerator >> constructorArgumentListToCPP: aConstructor [	
	| operator |
	
	operator := aConstructor parent operatorAt: 'new'.
	
	(operator isNil or: [ operator parameters size = 1 ]) ifTrue: [ ^ '' ].
	
	^ String streamContents: [ :stream |
		stream << '('. 
		operator parameters allButFirst
			do: [ :each | stream << (self argumentCastToCPP: each) ]
			separatedBy: [ stream << ', ' ].
		stream << ') ' ]
]

{ #category : 'private' }
IGCClassGenerator >> constructorParametersList: aConstructor [
	
	^ aConstructor parent
		operatorAt: 'new'
		ifFound: [ :operator | 
			(operator parameters allButFirst, aConstructor parameters
				collect: [ :each | self parameterDecl: each ]) asCommaString ]
		ifNone: [ 
			self parametersList: aConstructor ]
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
	
	template := aMethod isStatic 
		ifTrue: [ self staticFunctionCallOf: aMethod ]
		ifFalse: [ self basicFunctionCallOf: aMethod ].
	
	aMethod resolveReturnType
		ifTranslated: [ :translation | ^ translation cppToC: template from: aMethod  ].
			
	^ self defaultCastOf: aMethod call: template
]

{ #category : 'generating' }
IGCClassGenerator >> generateConstructor: aConstructor [
	| header body |
	
	self root: aConstructor root.

	header := '{type} {methodName}({parameters});' 
		format: { 
			#type -> (self cDeclarationOf: aConstructor resolveReturnType).
			#methodName -> aConstructor cDeclaration.
			#parameters -> (self constructorParametersList: aConstructor) }
		asDictionary	.
	self hStream << header << String cr.

	body := '{type} {methodName}({parameters}) \{
	{return}{returnCast}(new {newArguments}{func}({arguments}\));
\}' format: { 
		#type -> (self cDeclarationOf: aConstructor resolveReturnType).
		#methodName -> aConstructor cDeclaration.
		#parameters -> (self constructorParametersList: aConstructor).
		#newArguments -> (self constructorArgumentListToCPP: aConstructor).
		#func -> aConstructor cppDeclaration.
		#arguments -> (self argumentsListToCPP: aConstructor).
		#returnCast -> (self cCastToReturn: aConstructor resolveReturnType).
		#classCast -> (self cppCastForSelf: aConstructor parent).
		#return -> 'return ' }
		asDictionary	.

	self cStream << body << String cr
]

{ #category : 'generating' }
IGCClassGenerator >> generateDispose: aClass [

	aClass isAbstract ifTrue: [ ^ self ].
	"if there is a delete overload, I will need to handle the free of resources myself.
	 (there will probably be a paired new overload)"
	(aClass operatorAt: 'delete') ifNotNil: [ ^ self ].
	
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

{ #category : 'generating' }
IGCClassGenerator >> generateMethod: aMethod [
	| header body |
	
	self root: aMethod root.

	header := '{type} {methodName}({parameters});' 
		format: { 
			#type -> (self cDeclarationOf: aMethod resolveReturnType).
			#methodName -> aMethod cDeclaration.
			#parameters -> (self methodParametersList: aMethod) }
		asDictionary	.
	self hStream << header << String cr.
	
	body := '{type} {methodName}({parameters}) \{
	{functionCall};
\}' format: { 
		#type -> (self cDeclarationOf: aMethod resolveReturnType).
		#methodName -> aMethod cDeclaration.
		#parameters -> (self methodParametersList: aMethod).
		#functionCall -> (self functionCall: aMethod) } 
	asDictionary.

	self cStream << body << String cr
]

{ #category : 'private' }
IGCClassGenerator >> methodParametersList: aMethod [

	aMethod isStatic 
		ifTrue: [ ^ self parametersList: aMethod ].

	^ String streamContents: [ :stream |
		stream 
			<< aMethod parent cDeclaration
			<< ' self'.
		(self parametersList: aMethod) 
			ifNotEmpty: [ :aString | stream << ', ' << aString ] ]
]

{ #category : 'private' }
IGCClassGenerator >> staticFunctionCallOf: aMethod [
	
	^ '{classCast}::{func}({arguments})' 
		format: { 
			#func -> aMethod spelling.
			#arguments -> (self argumentsListToCPP: aMethod).
			#classCast -> aMethod parent cppDeclaration }
		asDictionary
]
