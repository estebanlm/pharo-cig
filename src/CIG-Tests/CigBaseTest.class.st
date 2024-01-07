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
CigBaseTest >> elementAtPath: aPath [

	^ self translatedUnit elementAtPath: aPath
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnit [

	^ CigTestResource current translatedUnit
		prefix: 'nu';
		yourself
]

{ #category : 'accessing' }
CigBaseTest >> translatedUnitTvision [

	^ CigTestResource current translatedUnitTvision
		prefix: 'tv';
		yourself
]
