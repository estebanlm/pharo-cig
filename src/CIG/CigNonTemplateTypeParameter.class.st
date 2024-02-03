Class {
	#name : 'CigNonTemplateTypeParameter',
	#superclass : 'CigElement',
	#instVars : [
		'parentSpelling'
	],
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

{ #category : 'initialization' }
CigNonTemplateTypeParameter >> fromCursor: aCursor [

	super fromCursor: aCursor.
	parentSpelling := aCursor parent spelling.
]

{ #category : 'as yet unclassified' }
CigNonTemplateTypeParameter >> isNonTypeTemplateParameter [

	^ true
]
