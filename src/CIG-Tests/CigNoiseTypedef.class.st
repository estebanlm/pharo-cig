Class {
	#name : 'CigNoiseTypedef',
	#superclass : 'SharedPool',
	#classVars : [
		'no_noise_module_Module'
	],
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'class initialization' }
CigNoiseTypedef class >> initialize [

	no_noise_module_Module := CigNoiseObjectForTest
]
