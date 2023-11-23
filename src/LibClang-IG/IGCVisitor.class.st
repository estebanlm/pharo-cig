Class {
	#name : 'IGCVisitor',
	#superclass : 'IGVisitor',
	#instVars : [
		'generator',
		'stream',
		'fileReference'
	],
	#category : 'LibClang-IG-',
	#package : 'LibClang-IG',
	#tag : ''
}

{ #category : 'private' }
IGCVisitor >> addCHeaders [
		
	stream << ('#include "{1}"

' format: { self file fileReference basename })
]

{ #category : 'private' }
IGCVisitor >> addCPreamble [
		
	stream << 'extern "C" {

'
]

{ #category : 'private' }
IGCVisitor >> endCPreamble [
		
	stream << '}
'
]

{ #category : 'accessing' }
IGCVisitor >> fileReference [
	
	^ fileReference ifNil: [ fileReference := self file cFileReference ]
]

{ #category : 'visiting' }
IGCVisitor >> visitAll: aCollection [

	self fileReference 
		ensureDelete;
		writeStreamDo: [ :aStream |
			stream := ZnNewLineWriterStream on: aStream.
			generator := nil.
			self addCHeaders.
			self addCPreamble.
			super visitAll: aCollection.
			self endCPreamble ]
]

{ #category : 'visiting' }
IGCVisitor >> visitEnum: anEnum [

	"C files do not contain enum declarations (they will be taken from the hpp definition)"
	stream << 'enum ' << anEnum name << ' {
'.

	anEnum elements do: [ :each | 
		stream << '    ' << each name << ' = ' << each value asString << ',
' ].
	stream << '};

'
]

{ #category : 'visiting' }
IGCVisitor >> visitFunction: aFunction [

	generator appendFunction: aFunction
]

{ #category : 'visiting' }
IGCVisitor >> visitNamespace: aNamespace [

	generator := IGNamespaceCGenerator new 
		namespace: aNamespace;
		stream: stream;
		yourself.
	super visitNamespace: aNamespace
]
