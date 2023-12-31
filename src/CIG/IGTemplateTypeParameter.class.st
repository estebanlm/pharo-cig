Class {
	#name : 'IGTemplateTypeParameter',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGTemplateTypeParameter class >> kind [
	
	^ CXCursor_TemplateTypeParameter
]

{ #category : 'visiting' }
IGTemplateTypeParameter >> accept: aVisitor [
	"nothing, handled by its parent (a class template)"
	
]

{ #category : 'testing' }
IGTemplateTypeParameter >> isTemplateTypeParameter [

	^ true
]
