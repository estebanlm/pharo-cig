Class {
	#name : 'CigPharoBaseClassGenerator',
	#superclass : 'CigPharoGenerator',
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private' }
CigPharoBaseClassGenerator >> namespaceName [

	^ self defaultNamespaceName
]

{ #category : 'private' }
CigPharoBaseClassGenerator >> sharedPoolNames [

	^ Array streamContents: [ :stream |
		stream nextPut: #CigCPPTypedef.
		(self unit namespaces collect: #typedef as: Set)
			do: [ :each | stream nextPut: each name ].
		stream nextPut: self libraryTypedefName asSymbol ]
]
