Class {
	#name : 'IGBaseTest',
	#superclass : 'TestCase',
	#pools : [
		'CXCursorKind',
		'CXTypeKind'
	],
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
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
