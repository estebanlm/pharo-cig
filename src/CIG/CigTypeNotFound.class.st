Class {
	#name : 'CigTypeNotFound',
	#superclass : 'Error',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigTypeNotFound >> messageText [

	^ '{1} can''t be mapped to a n FFIType' format: { super messageText }
]
