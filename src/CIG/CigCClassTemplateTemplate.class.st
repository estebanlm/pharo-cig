Class {
	#name : 'CigCClassTemplateTemplate',
	#superclass : 'CigCClassTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCClassTemplateTemplate class >> handlesElement: anElement [

	^ anElement isClassTemplate
]

{ #category : 'generating' }
CigCClassTemplateTemplate >> generateHeader [
	| cName |

	cName := self element cDeclaration allButLast.
	^ String streamContents: [ :stream |  
		stream << 'typedef void ' << cName << ';'.
		stream cr.
		self typeSpecializations 
			do: [ :each | stream << 'typedef void ' <<  cName << each capitalized << ';' ]
			separatedBy: [ stream cr ] ]
]

{ #category : 'private' }
CigCClassTemplateTemplate >> typeSpecializations [
	
	^ self element typeSpecializations
]