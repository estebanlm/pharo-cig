Class {
	#name : 'IGBaseTest',
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
IGBaseTest class >> isAbstract [

	^ self = IGBaseTest
]

{ #category : 'accessing' }
IGBaseTest >> elementAtPath: aPath [

	^ self translatedUnit elementAtPath: aPath
]

{ #category : 'accessing' }
IGBaseTest >> translatedUnit [

	^ IGTestResource current translatedUnit
]

{ #category : 'accessing' }
IGBaseTest >> translatedUnitTvision [

	^ IGTestResource current translatedUnitTvision
]
