Class {
	#name : 'IGCVisitor',
	#superclass : 'IGVisitor',
	#instVars : [
		'fileReference',
		'stack',
		'outStream'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'private' }
IGCVisitor >> addCHeaders [
		
	outStream << ('#include "{1}"

' format: { self file fileReference basename })
]

{ #category : 'private' }
IGCVisitor >> addCPreamble [
		
	outStream << 'extern "C" {

'
]

{ #category : 'private' }
IGCVisitor >> endCPreamble [
		
	outStream << '}
'
]

{ #category : 'accessing' }
IGCVisitor >> fileReference [
	
	^ fileReference ifNil: [ fileReference := self file cFileReference ]
]

{ #category : 'private' }
IGCVisitor >> indentDo: aBlock [

	aBlock value
]

{ #category : 'private' }
IGCVisitor >> initialize [

	super initialize.
	stack := Stack new
]

{ #category : 'private' }
IGCVisitor >> newStreamOn: aStream [

	^ ZnNewLineWriterStream on: aStream
]

{ #category : 'private' }
IGCVisitor >> outStream [

	^ outStream
]

{ #category : 'private' }
IGCVisitor >> pop [ 
	
	^ stack pop
]

{ #category : 'private' }
IGCVisitor >> prefix [

	^ String streamContents: [ :s |
		(stack reversed collect: #name as: Array) 
			asStringOn: s delimiter: '_' ]
]

{ #category : 'private' }
IGCVisitor >> prefixWithSuffix: aString [

	^ self prefix 
		ifNotEmpty: [ :prefix | prefix, aString ]
]

{ #category : 'private' }
IGCVisitor >> push: anObject [

	stack push: anObject
]

{ #category : 'visiting' }
IGCVisitor >> visitClass: aClass [

	self push: aClass.
	[  
		self indentDo: [  
			outStream << '/* BEGIN CLASS: ' << aClass name << '*/' << String cr << String cr.
			(IGCClassGenerator on: self) generateClass: aClass.
			super visitClass: aClass.
			outStream << '/* END CLASS: ' << aClass name << '*/' << String cr << String cr ] ]
	ensure: [
		self pop ]
]

{ #category : 'visiting' }
IGCVisitor >> visitConstructor: aConstructor [

]

{ #category : 'visiting' }
IGCVisitor >> visitDestructor: aDestructor [

]

{ #category : 'visiting' }
IGCVisitor >> visitEnum: anEnum [

	"C files do not contain enum declarations (they will be taken from the hpp definition)"
	outStream << 'enum ' << anEnum name << ' {
'.

	anEnum elements do: [ :each | 
		outStream << '    ' << each name << ' = ' << each value asString << ',
' ].
	outStream << '};

'
]

{ #category : 'visiting' }
IGCVisitor >> visitFunction: aFunction [

	outStream << (aFunction asFunctionSourceWithPrefix: self prefix delimiter: '_').
	outStream cr
]

{ #category : 'visiting' }
IGCVisitor >> visitMethod: aMethod [

	(aMethod isPublic not
		or: [ aMethod isOperator ]) 
		ifTrue: [ ^ self ].

	"outStream << (aMethod asFunctionSourceWithPrefix: self prefix delimiter: '_')."
	(IGCClassGenerator on: self) generateMethod: aMethod.
	outStream cr
]

{ #category : 'visiting' }
IGCVisitor >> visitNamespace: aNamespace [

	self push: aNamespace.
	[ 
		self indentDo: [  
			outStream << '/* BEGIN NAMESPACE: ' << aNamespace name << '*/' << String cr << String cr.
			super visitNamespace: aNamespace.
			outStream << '/* END NAMESPACE: ' << aNamespace name << '*/' << String cr << String cr ] ]
	ensure: [ 
		self pop ]
]

{ #category : 'visiting' }
IGCVisitor >> visitUnit: aUnit [

	self fileReference 
		ensureDelete;
		writeStreamDo: [ :aStream |
			outStream := self newStreamOn: aStream.
			self addCHeaders.
			self addCPreamble.
			self visitAll: aUnit elements.
			self endCPreamble ]
]
