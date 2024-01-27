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

{ #category : 'accessing' }
CigBaseTest >> translatedUnitFinalcut [

	^ CigTestResource current translatedUnitFinalcut
		prefix: 'fc';
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
CigBaseTest >> translatedUnitStdArray [

	^ CigTestResource current translatedUnitStdArray
		prefix: 'Std';
		yourself
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnitTvision [

	^ CigTestResource current translatedUnitTvision
		prefix: 'tv';
		yourself
]
