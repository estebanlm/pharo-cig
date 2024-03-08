"
The library will be executed in main thread.
"
Class {
	#name : 'CigFFIRunnerMainThread',
	#superclass : 'CigFFIRunner',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigFFIRunnerMainThread >> phTemplate [

	^ 'TFMainThreadRunner uniqueInstance'
]
