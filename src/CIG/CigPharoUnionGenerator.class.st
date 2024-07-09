Class {
	#name : 'CigPharoUnionGenerator',
	#superclass : 'CigPharoStructureGenerator',
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'accessing' }
CigPharoUnionGenerator class >> structType [

	^ 'Union'
]

{ #category : 'private' }
CigPharoUnionGenerator >> baseClass [

	^ self baseUnionClass
]
