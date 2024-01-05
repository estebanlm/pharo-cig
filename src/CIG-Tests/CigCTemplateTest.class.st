Class {
	#name : 'CigCTemplateTest',
	#superclass : 'CigBaseTest',
	#pools : [
		'CXCursorKind',
		'CXTypeKind'
	],
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'testing' }
CigCTemplateTest class >> isAbstract [

	^ self = CigCTemplateTest
]
