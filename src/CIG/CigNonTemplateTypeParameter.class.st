Class {
	#name : 'CigNonTemplateTypeParameter',
	#superclass : 'CigElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigNonTemplateTypeParameter class >> kind [
	
	^ CXCursor_NonTypeTemplateParameter
]

{ #category : 'visiting' }
CigNonTemplateTypeParameter >> accept: aVisitor [
	"nothing, handled by its parent (a class template)"
	
]

{ #category : 'as yet unclassified' }
CigNonTemplateTypeParameter >> isNonTypeTemplateParameter [

	^ true
]
