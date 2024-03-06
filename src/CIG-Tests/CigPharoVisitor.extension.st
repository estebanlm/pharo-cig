Extension { #name : 'CigPharoVisitor' }

{ #category : '*CIG-Tests' }
CigPharoVisitor class >> newForTest [

	^ self newForTestAsCPP
]

{ #category : '*CIG-Tests' }
CigPharoVisitor class >> newForTestAsC [

	^ self new prepareForTestAsC
]

{ #category : '*CIG-Tests' }
CigPharoVisitor class >> newForTestAsCPP [

	^ self new prepareForTestAsCPP
]

{ #category : '*CIG-Tests' }
CigPharoVisitor >> prepareForTest [
	
	types := Dictionary new.
	file := CigLibraryGenerator new
		prefix: 'Gft';
		bindingsName: 'GeneratedForTest';
		yourself.
		
	initializationRegistry := OrderedCollection new
]

{ #category : '*CIG-Tests' }
CigPharoVisitor >> prepareForTestAsC [
	
	types := Dictionary new.
	file := CigCLibraryGenerator new
		prefix: 'Gft';
		bindingsName: 'GeneratedForTest';
		yourself.
		
	initializationRegistry := OrderedCollection new
]

{ #category : '*CIG-Tests' }
CigPharoVisitor >> prepareForTestAsCPP [
	
	types := Dictionary new.
	file := CigCppLibraryGenerator new
		prefix: 'Gft';
		bindingsName: 'GeneratedForTest';
		yourself.
		
	initializationRegistry := OrderedCollection new
]
