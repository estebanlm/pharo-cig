Class {
	#name : 'CigPharoUnionGenerator',
	#superclass : 'CigPharoStructureGenerator',
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private' }
CigPharoUnionGenerator >> baseClass [

	^ self baseUnionClass
]
