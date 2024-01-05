Class {
	#name : 'CigPharoFunctionGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'function'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'instance creation' }
CigPharoFunctionGenerator class >> newFile: aLibraryGenerator function: aFunction [

	^ self new
		file: aLibraryGenerator;
		unit: aFunction root; 
		function: aFunction;
		yourself
]

{ #category : 'private' }
CigPharoFunctionGenerator >> classForElement [
		
	^ self libraryClass
]

{ #category : 'accessing' }
CigPharoFunctionGenerator >> function [

	^ function
]

{ #category : 'accessing' }
CigPharoFunctionGenerator >> function: aFunction [

	function := aFunction
]

{ #category : 'generating' }
CigPharoFunctionGenerator >> generate [

	self classForElement
		compile: self function phTemplate generate
		classified: self protocol
]

{ #category : 'private' }
CigPharoFunctionGenerator >> protocol [

	^ 'functions'
]
