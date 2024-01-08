Class {
	#name : 'CigNoiseNamespace',
	#superclass : 'Object',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigNoiseNamespace class >> cppHeader [

	^ 'noise_bindings.h'
]

{ #category : 'accessing' }
CigNoiseNamespace class >> cppName [

	^ 'noise'
]

{ #category : 'accessing' }
CigNoiseNamespace class >> cppPrefix [

	^ 'no'
]

{ #category : 'accessing' }
CigNoiseNamespace class >> typedef [

	^ CigNoiseTypedef
]
