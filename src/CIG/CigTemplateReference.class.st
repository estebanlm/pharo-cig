Class {
	#name : 'CigTemplateReference',
	#superclass : 'CigTypeReference',
	#classTraits : '{} + TraitedClass',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigTemplateReference class >> kind [

	^ CXCursor_TemplateRef
]
