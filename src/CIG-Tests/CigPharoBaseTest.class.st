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

{ #category : 'accessing' }
CigPharoBaseTest >> translatedUnit [

	"change prefix to ensure it does not collides with existing classes"
	^ super translatedUnit
		prefix: 'xx';
		yourself
]

{ #category : 'accessing' }
CigPharoBaseTest >> translatedUnitFinalcut [

	"change prefix to ensure it does not collides with existing classes"
	^ super translatedUnitFinalcut
		prefix: 'xx';
		yourself
]

{ #category : 'accessing' }
CigPharoBaseTest >> translatedUnitTvision [

	"change prefix to ensure it does not collides with existing classes"
	^ super translatedUnitTvision
		prefix: 'xx';
		yourself
]
