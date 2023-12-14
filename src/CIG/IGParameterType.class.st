Class {
	#name : 'IGParameterType',
	#superclass : 'IGType',
	#instVars : [
		'definesFunction'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
IGParameterType >> definesFunction [

	^ definesFunction
]

{ #category : 'accessing' }
IGParameterType >> definesFunction: aBoolean [

	definesFunction := aBoolean
]
