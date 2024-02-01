Class {
	#name : 'CXUnsavedFile',
	#superclass : 'FFIExternalStructure',
	#classVars : [
		'OFFSET_CONTENTS',
		'OFFSET_FILENAME',
		'OFFSET_LENGTH'
	],
	#category : 'CIG-LibClang',
	#package : 'CIG-LibClang'
}

{ #category : 'field definition' }
CXUnsavedFile class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	
	^ #(
  void *Filename;
  void *Contents;
  ulong Length;	
	)
]

{ #category : 'instance creation' }
CXUnsavedFile class >> newFileName: aString contents: contentsString [

	^ self new 
		Filename: (ExternalAddress fromString: aString);
		Contents: (ExternalAddress fromString: contentsString);
		Length: contentsString size + 1;
		yourself
]

{ #category : 'accessing - structure variables' }
CXUnsavedFile >> Contents [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_CONTENTS) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXUnsavedFile >> Contents: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_CONTENTS put: anObject getHandle.
]

{ #category : 'accessing - structure variables' }
CXUnsavedFile >> Filename [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_FILENAME) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXUnsavedFile >> Filename: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_FILENAME put: anObject getHandle.
]

{ #category : 'accessing - structure variables' }
CXUnsavedFile >> Length [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_LENGTH
]

{ #category : 'accessing - structure variables' }
CXUnsavedFile >> Length: anObject [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_LENGTH put: anObject
]

{ #category : 'finalizing' }
CXUnsavedFile >> dispose [
	| filename contents |

	(filename := self Filename) isNull 
		ifFalse: [ filename free ].
	(contents := self Contents) isNull 
		ifFalse: [ contents free ]
]
