Class {
	#name : 'IGCClassTemplateTemplate',
	#superclass : 'IGCClassTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCClassTemplateTemplate class >> handlesElement: anElement [

	^ anElement isClassTemplate
]

{ #category : 'private' }
IGCClassTemplateTemplate >> classSpecializations [
	
	^ IGCTemplateCollector new
		typeName: self element baseName;
		visit: self root;
		collected
]

{ #category : 'generating' }
IGCClassTemplateTemplate >> generateHeader [
	| cName |

	cName := self element cDeclaration allButLast.
	^ String streamContents: [ :stream |  
		stream << 'typedef void ' << cName << ';'.
		stream cr.
		self classSpecializations 
			do: [ :each | stream << 'typedef void ' <<  cName << each capitalized << ';' ]
			separatedBy: [ stream cr ] ]
]
