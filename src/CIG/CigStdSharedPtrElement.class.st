"
The std::shared_ptr class element.
It is need to translate from std::shared_ptr to void* and viceversa.
"
Class {
	#name : 'CigStdSharedPtrElement',
	#superclass : 'CigElement',
	#classTraits : '{} + TraitedClass',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'accessing' }
CigStdSharedPtrElement class >> kind [
	
	^ nil
]

{ #category : 'visiting' }
CigStdSharedPtrElement >> accept: aVisitor [
	
]

{ #category : 'initialization' }
CigStdSharedPtrElement >> initialize [

	super initialize.
	self name: 'shared_ptr'
]
