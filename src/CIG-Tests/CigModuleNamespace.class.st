Class {
	#name : 'CigModuleNamespace',
	#superclass : 'Object',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigModuleNamespace class >> cppHeader [

	^ 'noise_bindings.h'
]

{ #category : 'accessing' }
CigModuleNamespace class >> cppName [

	^ 'noise::module'
]

{ #category : 'accessing' }
CigModuleNamespace class >> cppPrefix [

	^ 'no'
]

{ #category : 'accessing' }
CigModuleNamespace class >> typedef [

	^ CigNoiseTypedef
]
