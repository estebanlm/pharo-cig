Class {
	#name : 'CigCTemplateTest',
	#superclass : 'CigBaseTest',
	#pools : [
		'CXCursorKind',
		'CXTypeKind'
	],
	#category : 'CIG-Tests-C-Template',
	#package : 'CIG-Tests',
	#tag : 'C-Template'
}

{ #category : 'testing' }
CigCTemplateTest class >> isAbstract [

	^ self = CigCTemplateTest
]
