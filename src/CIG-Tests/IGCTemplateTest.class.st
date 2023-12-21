Class {
	#name : 'IGCTemplateTest',
	#superclass : 'IGBaseTest',
	#pools : [
		'CXCursorKind',
		'CXTypeKind'
	],
	#category : 'CIG-Tests-Template',
	#package : 'CIG-Tests',
	#tag : 'Template'
}

{ #category : 'testing' }
IGCTemplateTest class >> isAbstract [

	^ self = IGCTemplateTest
]
