"
A template to generate structure declarations.
"
Class {
	#name : 'CigPharoStructureTemplate',
	#superclass : 'CigPharoTemplate',
	#category : 'CIG-Pharo-Template',
	#package : 'CIG',
	#tag : 'Pharo-Template'
}

{ #category : 'private' }
CigPharoStructureTemplate >> anonymousElementName [
	| index |

	index := self indexOfElement.
	^ String streamContents: [ :stream |
		stream << self prefix << index asString ]
]

{ #category : 'private' }
CigPharoStructureTemplate >> anonymousTypeName [
	| index |
	
	index := self indexOfElement.
	^ String streamContents: [ :stream | | decl |
		decl := self element parent phDeclaration.
		stream << decl.
		"if parent is named with underscores, strategy will be add an underscore,
		 otherwise capitalize it"
		(decl includes: $_)
			ifTrue: [ stream << '_' << self prefix ]
			ifFalse: [ stream << self prefix capitalized ].
		stream << index asString ]
]

{ #category : 'accessing' }
CigPharoStructureTemplate >> elementName [
	
	^ self element isAnonymous
		ifTrue: [ self anonymousElementName ]
		ifFalse: [ self element name ]
]

{ #category : 'as yet unclassified' }
CigPharoStructureTemplate >> generateFieldDesc [
	"the structure is a field of another structure"
	
	^ String streamContents: [ :stream |
		 stream << self typeName  << ' ' << self elementName ]
]

{ #category : 'as yet unclassified' }
CigPharoStructureTemplate >> generateFieldsDesc [

	^ String streamContents: [ :stream |
		stream << 'fieldsDesc'; cr.
		stream cr; tab.
		stream << '^ #('; cr.
		self element fields 
			do: [ :each | 
				stream tab.
				stream << each phTemplate generateFieldDesc ]
			separatedBy: [ stream << ';'; cr ].
		stream cr; tab.
		stream << ')' ]
]

{ #category : 'accessing' }
CigPharoStructureTemplate >> indexOfElement [
	
	^ self element parent indexOfElementOfSameKind: self element
]

{ #category : 'private' }
CigPharoStructureTemplate >> prefix [
	
	^ 'struct'
]

{ #category : 'accessing' }
CigPharoStructureTemplate >> typeName [

	^ self element isAnonymous
		ifTrue: [ self anonymousTypeName ]
		ifFalse: [ self element phDeclaration ]
]
