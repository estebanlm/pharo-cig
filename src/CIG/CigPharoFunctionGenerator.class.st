Class {
	#name : 'CigPharoFunctionGenerator',
	#superclass : 'CigPharoGenerator',
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private' }
CigPharoFunctionGenerator >> classForElement [
		
	^ self libraryClass
]

{ #category : 'generating' }
CigPharoFunctionGenerator >> generate [

	self classForElement
		compile: self element phTemplate generate
		classified: self protocol
]

{ #category : 'private' }
CigPharoFunctionGenerator >> protocol [

	^ 'public'
]
