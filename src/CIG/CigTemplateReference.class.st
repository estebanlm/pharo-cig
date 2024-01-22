Class {
	#name : 'CigTemplateReference',
	#superclass : 'CigTypeReference',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigTemplateReference class >> kind [

	^ CXCursor_TemplateRef
]
