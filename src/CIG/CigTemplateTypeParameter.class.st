Class {
	#name : 'CigTemplateTypeParameter',
	#superclass : 'CigElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigTemplateTypeParameter class >> kind [
	
	^ CXCursor_TemplateTypeParameter
]

{ #category : 'visiting' }
CigTemplateTypeParameter >> accept: aVisitor [
	"nothing, handled by its parent (a class template)"
	
]

{ #category : 'testing' }
CigTemplateTypeParameter >> isTemplateTypeParameter [

	^ true
]
