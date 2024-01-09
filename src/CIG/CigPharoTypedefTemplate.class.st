"
Template for `CigField`, to properly generate its declarations.
"
Class {
	#name : 'CigPharoTypedefTemplate',
	#superclass : 'CigPharoTemplate',
	#category : 'CIG-Pharo-Template',
	#package : 'CIG',
	#tag : 'Pharo-Template'
}

{ #category : 'instance creation' }
CigPharoTypedefTemplate class >> for: anElement [

	^ self allSubclasses 
		detect: [ :each | each handlesElement: anElement ]
		ifFound: [ :aClass | aClass forElement: anElement ]
		ifNone: [ CigPharoTypedefTemplate forElement: anElement ]
]

{ #category : 'private' }
CigPharoTypedefTemplate class >> handlesElement: anElement [

	^ false
]

{ #category : 'generating' }
CigPharoTypedefTemplate >> generate [

	^ self element cTemplate generateFFIType
]
