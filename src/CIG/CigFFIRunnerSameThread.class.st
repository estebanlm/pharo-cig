"
The library will be executed in same thread as the vm
"
Class {
	#name : 'CigFFIRunnerSameThread',
	#superclass : 'CigFFIRunner',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigFFIRunnerSameThread >> phTemplate [

	^ TFSameThreadRunner uniqueInstance
]
