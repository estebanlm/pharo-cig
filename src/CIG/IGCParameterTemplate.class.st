Class {
	#name : 'IGCParameterTemplate',
	#superclass : 'IGCTemplate',
	#instVars : [
		'type'
	],
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'instance creation' }
IGCParameterTemplate class >> forClass: aClass [

	^ self 
		forType: aClass resolveType 
		ofElement: aClass
]

{ #category : 'instance creation' }
IGCParameterTemplate class >> forField: aField [

	^ self forType: aField resolveType ofElement: aField
]

{ #category : 'instance creation' }
IGCParameterTemplate class >> forParameter: aParam [

	^ self forType: aParam resolveType ofElement: aParam
]

{ #category : 'instance creation' }
IGCParameterTemplate class >> forReturn: aMethodOrFunction [

	^ self 
		forType: aMethodOrFunction resolveReturnType
		ofElement: aMethodOrFunction
]

{ #category : 'instance creation' }
IGCParameterTemplate class >> forType: aType ofElement: anElement [

	^ (self allSubclasses 
		detect: [ :each | each handlesType: aType ]
			ifFound: [ :aClass | aClass forElement: anElement ]
			ifNone: [ IGCParameterBasicTypeTemplate forElement: anElement ])
		type: aType;
		yourself
]

{ #category : 'private' }
IGCParameterTemplate class >> handlesElement: anElement [
		
	^ self handlesType: anElement resolveType
]

{ #category : 'private' }
IGCParameterTemplate class >> handlesType: aType [
		
	^ false
]

{ #category : 'generating' }
IGCParameterTemplate >> castReturn: aString [ 
	
	self subclassResponsibility
]

{ #category : 'generating' }
IGCParameterTemplate >> generate [

	^ '{1} {2}' format: { 
		self generateCType.
		self name }
]

{ #category : 'generating' }
IGCParameterTemplate >> generateArgument [

	self subclassResponsibility
]

{ #category : 'generating' }
IGCParameterTemplate >> generateCType [

	self subclassResponsibility
]

{ #category : 'accessing' }
IGCParameterTemplate >> name [

	^ self element name
]

{ #category : 'accessing' }
IGCParameterTemplate >> type [

	^ type
]

{ #category : 'accessing' }
IGCParameterTemplate >> type: aType [

	type := aType
]
