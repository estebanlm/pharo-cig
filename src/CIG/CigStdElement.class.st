"
A base element for std:: elements that are not translatable (but appear in the code)
"
Class {
	#name : 'CigStdElement',
	#superclass : 'CigElement',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'accessing' }
CigStdElement class >> kind [
	
	^ nil
]

{ #category : 'instance creation' }
CigStdElement class >> newName: aString [

	^ self basicNew
		initializeName: aString;
		yourself
]

{ #category : 'visiting' }
CigStdElement >> accept: aVisitor [

]

{ #category : 'initialization' }
CigStdElement >> initializeName: aName [

	self initialize.
	name := aName
]

{ #category : 'testing' }
CigStdElement >> isSpecial [

	^ true
]
