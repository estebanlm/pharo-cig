Class {
	#name : 'IGCEnumTemplate',
	#superclass : 'IGCTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'instance creation' }
IGCEnumTemplate class >> for: anEnum [

	^ self allSubclasses 
		detect: [ :each | each handlesElement: anEnum ]
		ifFound: [ :aClass | aClass forElement: anEnum ]
		ifNone: [ IGCEnumDefaultTemplate forElement: anEnum ]
]

{ #category : 'private' }
IGCEnumTemplate class >> handlesElement: anElement [

	^ false
]

{ #category : 'private' }
IGCEnumTemplate >> enumName [
	
	"yeah, enums can be unnamed :P"
	"self element isUnnamed ifTrue: [
		unnamedEnum := self root incrementUnnamedEnum.
		^ '{1}_unnamed_enum_{2}' format: { 
			self root prefix asLowercase.			
			unnamedEnum } ]."

	^ self element cDeclaration
]

{ #category : 'generating' }
IGCEnumTemplate >> generate [

	self subclassResponsibility
]
