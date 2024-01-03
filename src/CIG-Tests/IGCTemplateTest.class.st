Class {
	#name : 'IGCTemplateTest',
	#superclass : 'IGBaseTest',
	#pools : [
		'CXCursorKind',
		'CXTypeKind'
	],
	#category : 'CIG-Tests-C-Template',
	#package : 'CIG-Tests',
	#tag : 'C-Template'
}

{ #category : 'testing' }
IGCTemplateTest class >> isAbstract [

	^ self = IGCTemplateTest
]
