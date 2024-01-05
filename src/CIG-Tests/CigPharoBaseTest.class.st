Class {
	#name : 'CigPharoBaseTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'testing' }
CigPharoBaseTest class >> isAbstract [
	
	^ super isAbstract or: [ self = CigPharoBaseTest ]
]

{ #category : 'running' }
CigPharoBaseTest >> tearDown [

	PackageOrganizer default 
		packageNamed: 'LibGeneratedForTest'
		ifPresent: [ :aPackage | aPackage removeFromSystem ].
		
	super tearDown
]
