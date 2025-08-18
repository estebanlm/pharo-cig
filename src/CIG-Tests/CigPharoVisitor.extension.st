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

	constants := OrderedCollection new.
	types := OrderedDictionary new.
	file := CigCLibraryGenerator new
		prefix: 'Gft';
		libraryName: 'GeneratedForTest';
		yourself.

	initializationRegistry := OrderedCollection new
]

{ #category : '*CIG-Tests' }
CigPharoVisitor >> prepareForTestAsCPP [
	
	constants := OrderedCollection new.
	types :=  OrderedDictionary new.
	file := CigCppLibraryGenerator new
		prefix: 'Gft';
		libraryName: 'GeneratedForTest';
		yourself.
		
	initializationRegistry := OrderedCollection new
]
