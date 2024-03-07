Class {
	#name : 'CigCParameterTemplate',
	#superclass : 'CigCTemplate',
	#instVars : [
		'type'
	],
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'instance creation' }
CigCParameterTemplate class >> forClass: aClass [

	^ self 
		forType: aClass resolveType 
		ofElement: aClass
]

{ #category : 'instance creation' }
CigCParameterTemplate class >> forField: aField [

	^ self forType: aField resolveType ofElement: aField
]

{ #category : 'instance creation' }
CigCParameterTemplate class >> forParameter: aParam [

	^ self forType: aParam resolveType ofElement: aParam
]

{ #category : 'instance creation' }
CigCParameterTemplate class >> forReturn: aMethodOrFunction [

	^ self 
		forType: aMethodOrFunction resolveReturnType
		ofElement: aMethodOrFunction
]

{ #category : 'instance creation' }
CigCParameterTemplate class >> forType: aType ofElement: anElement [

	^ (self allSubclasses 
		detect: [ :each | each handlesType: aType ]
			ifFound: [ :aClass | aClass forElement: anElement ]
			ifNone: [ CigCParameterBasicTypeTemplate forElement: anElement ])
		type: aType;
		yourself
]

{ #category : 'private' }
CigCParameterTemplate class >> handlesElement: anElement [
		
	^ self handlesType: anElement resolveType
]

{ #category : 'private' }
CigCParameterTemplate class >> handlesType: aType [
		
	^ false
]

{ #category : 'generating' }
CigCParameterTemplate >> castReturn: aString [ 
	
	self subclassResponsibility
]

{ #category : 'generating' }
CigCParameterTemplate >> generate [

	^ '{1} {2}' format: { 
		self generateCType.
		self name }
]

{ #category : 'generating' }
CigCParameterTemplate >> generateArgument [

	self subclassResponsibility
]

{ #category : 'generating' }
CigCParameterTemplate >> generateCType [

	self subclassResponsibility
]

{ #category : 'generating' }
CigCParameterTemplate >> generateFFIType [
	
	^ self generateCType
]

{ #category : 'generating' }
CigCParameterTemplate >> generateForFFI [

	^ self generate
]

{ #category : 'accessing' }
CigCParameterTemplate >> name [

	^ self element name 
		ifEmpty: [ self anonymousName ]
]

{ #category : 'accessing' }
CigCParameterTemplate >> type [

	^ type
]

{ #category : 'accessing' }
CigCParameterTemplate >> type: aType [

	type := aType
]
