Class {
	#name : 'IGCClassGenerator',
	#superclass : 'IGCGenerator',
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'as yet unclassified' }
IGCClassGenerator >> addClassTypedef: aClass [

	self outStream << ('typedef void* {1};' format: { aClass fullName  }).
	self outStream cr
]

{ #category : 'as yet unclassified' }
IGCClassGenerator >> generateClass: aClass [
	
	self addClassTypedef: aClass.
	self outStream cr
]

{ #category : 'as yet unclassified' }
IGCClassGenerator >> generateMethod: aMethod [
	| type |

	type := self typeOf: aMethod returnTypeName.
	self outStream
		<< type << ' '
		<< aMethod fullName 
		<< '(' << (self parametersList: aMethod parameters) << ') {' << String cr
		<< String cr 
		<< '}' << String cr
	 "self outStream << aMethod full 
			<< prefix << delim
			<< self spelling 
			<< '(' << self parametersAsList << ')' ]	"
]
