Class {
	#name : 'CigBaseTest',
	#superclass : 'TestCase',
	#pools : [
		'CXCursorKind',
		'CXTypeKind'
	],
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'testing' }
CigBaseTest class >> isAbstract [

	^ self = CigBaseTest
]

{ #category : 'instance creation' }
CigBaseTest >> newUnit: aString [

	^ CigCLibraryGenerator new 
		packageName: 'Unit';
		prefix: 'Unit';
		importUnit: aString;
		translateUnit
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnitFinalcut [

	^ CigTestResource current translatedUnitFinalcut
		prefix: 'fc';
		yourself
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnitIcal [

	^ CigTestResource current translatedUnitIcal
		prefix: 'ical';
		yourself
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnitLibXML [

	^ CigTestResource current translatedUnitLibXML
		prefix: 'xml';
		yourself
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnitNoise [

	^ CigTestResource current translatedUnitNoise
		prefix: 'no';
		yourself
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnitNoiseutils [

	^ CigTestResource current translatedUnitNoiseutils
		prefix: 'nu';
		yourself
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnitOpenSSL [

	^ CigTestResource current translatedUnitOpenSSL
		prefix: 'ssl';
		yourself
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnitRaylib [

	^ CigTestResource current translatedUnitRaylib
		prefix: 'ray';
		yourself
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnitStdArray [

	^ CigTestResource current translatedUnitStdArray
		prefix: 'xx';
		yourself
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnitTvision [

	^ CigTestResource current translatedUnitTvision
		prefix: 'tv';
		yourself
]
