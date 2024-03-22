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
		ifPresent: [ :aPackage | 
			"first remove classes (except the traits and sharedpools)"
			aPackage definedClasses 
				reject: [ :each | each isTrait or: [ each isKindOf: SharedPool ] ]
				thenDo: [ :each | each removeFromSystem ].
			"then the rest"
			aPackage removeFromSystem ].
		
	super tearDown
]

{ #category : 'accessing' }
CigPharoBaseTest >> translatedUnitFinalcut [

	"change prefix to ensure it does not collides with existing classes"
	^ super translatedUnitFinalcut
		prefix: 'xx';
		yourself
]

{ #category : 'accessing' }
CigPharoBaseTest >> translatedUnitIcal [

	"change prefix to ensure it does not collides with existing classes"
	^ super translatedUnitIcal
		prefix: 'xx';
		yourself
]

{ #category : 'accessing' }
CigPharoBaseTest >> translatedUnitNoise [

	"change prefix to ensure it does not collides with existing classes"
	^ super translatedUnitNoise
		prefix: 'xx';
		yourself
]

{ #category : 'accessing' }
CigPharoBaseTest >> translatedUnitNoiseutils [

	"change prefix to ensure it does not collides with existing classes"
	^ super translatedUnitNoiseutils
		prefix: 'xx';
		yourself
]

{ #category : 'accessing' }
CigPharoBaseTest >> translatedUnitOpenSSL [

	"change prefix to ensure it does not collides with existing classes"
	^ super translatedUnitOpenSSL
		prefix: 'xx';
		yourself
]

{ #category : 'accessing' }
CigPharoBaseTest >> translatedUnitRaylib [

	"change prefix to ensure it does not collides with existing classes"
	^ super translatedUnitRaylib
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
