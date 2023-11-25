Class {
	#name : 'IGCGenerator',
	#superclass : 'Object',
	#instVars : [
		'base'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'instance creation' }
IGCGenerator class >> on: aVisitor [

	^ self new 
		base: aVisitor;
		yourself
]

{ #category : 'accessing' }
IGCGenerator >> base: aVisitor [

	base := aVisitor
]

{ #category : 'accessing' }
IGCGenerator >> outStream [
	
	^ base outStream
]

{ #category : 'as yet unclassified' }
IGCGenerator >> parameterDecl: aParameter [

	^ String streamContents: [ :stream |
		stream << (self typeOf: aParameter typeName) << ' ' << aParameter name ]
]

{ #category : 'as yet unclassified' }
IGCGenerator >> parametersList: aCollection [

	^ (aCollection collect: [ :each | (self parameterDecl: each) ]) asCommaString
]

{ #category : 'parsing' }
IGCGenerator >> parseType: aString [
	
	^ IGFunctionParser parse: aString
]

{ #category : 'private' }
IGCGenerator >> typeOf: aString [
	| parsed |

	^ String streamContents: [ :stream |
		parsed := self parseType: aString.
		parsed isReference 
			ifTrue: [ stream << parsed name << '*' ]
			ifFalse: [ stream << aString ] ]
]
