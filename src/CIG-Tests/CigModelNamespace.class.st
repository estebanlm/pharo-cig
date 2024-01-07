Class {
	#name : 'CigModelNamespace',
	#superclass : 'Object',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigModelNamespace class >> cppHeader [

	^ 'noise_bindings.h'
]

{ #category : 'accessing' }
CigModelNamespace class >> cppName [

	^ 'noise::model'
]

{ #category : 'accessing' }
CigModelNamespace class >> cppPrefix [

	^ 'no'
]
