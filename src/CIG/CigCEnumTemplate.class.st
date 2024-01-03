Class {
	#name : 'CigCEnumTemplate',
	#superclass : 'CigCTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'instance creation' }
CigCEnumTemplate class >> for: anEnum [

	^ self allSubclasses 
		detect: [ :each | each handlesElement: anEnum ]
		ifFound: [ :aClass | aClass forElement: anEnum ]
		ifNone: [ CigCEnumDefaultTemplate forElement: anEnum ]
]

{ #category : 'private' }
CigCEnumTemplate class >> handlesElement: anElement [

	^ false
]

{ #category : 'private' }
CigCEnumTemplate >> enumName [
	
	"yeah, enums can be unnamed :P"
	"self element isUnnamed ifTrue: [
		unnamedEnum := self root incrementUnnamedEnum.
		^ '{1}_unnamed_enum_{2}' format: { 
			self root prefix asLowercase.			
			unnamedEnum } ]."

	^ self element cDeclaration
]

{ #category : 'generating' }
CigCEnumTemplate >> generate [

	self subclassResponsibility
]
