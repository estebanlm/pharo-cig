Class {
	#name : 'IGCVisitor',
	#superclass : 'IGVisitor',
	#instVars : [
		'fileReference',
		'stack',
		'cStream',
		'hStream'
	],
	#category : 'CIG-Generate-C',
	#package : 'CIG',
	#tag : 'Generate-C'
}

{ #category : 'private - adding' }
IGCVisitor >> addCHeaders [
		
	cStream << '#include "' << self file fileReference basename << '"' << String cr.
	cStream << '#include "' << (self fileReference withExtension: 'h') basename << '"' << String cr.
	cStream cr
]

{ #category : 'private - adding' }
IGCVisitor >> addCPreamble [
		
	cStream << 'extern "C" {

'
]

{ #category : 'private - adding' }
IGCVisitor >> addHHeaders [
	| def |
		
	def := self fileReference basenameWithoutExtension asUppercase.
	hStream << '#ifndef ' << def  << String cr.
	hStream << '#define ' << def  << String cr.
	hStream cr.
	(self file namespaces 
		collect: [ :each | each cppHeader ]
		as: Set)
		do: [ :each |
			hStream << '#include "' << each << '"' << String cr ].
	hStream cr		
]

{ #category : 'private - adding' }
IGCVisitor >> addHPreamble [
		
	hStream << 'extern "C" {

'
]

{ #category : 'accessing' }
IGCVisitor >> cStream [

	^ cStream
]

{ #category : 'private - adding' }
IGCVisitor >> endCPreamble [
		
	cStream << '}
'
]

{ #category : 'private - adding' }
IGCVisitor >> endHFile [
	| def |
		
	def := self fileReference basenameWithoutExtension asUppercase.
	hStream << '
}
	
#endif /* ' << def << '*/'.
]

{ #category : 'accessing' }
IGCVisitor >> fileReference [
	
	^ fileReference ifNil: [ fileReference := self file cFileReference ]
]

{ #category : 'accessing' }
IGCVisitor >> hStream [

	^ hStream
]

{ #category : 'private' }
IGCVisitor >> indentDo: aBlock [

	aBlock value
]

{ #category : 'initialization' }
IGCVisitor >> initialize [

	super initialize.
	stack := Stack new
]

{ #category : 'private - factory' }
IGCVisitor >> newCStream [

	^ self newStreamFor: self fileReference ensureDelete
]

{ #category : 'private - factory' }
IGCVisitor >> newHStream [

	^ self newStreamFor: (self fileReference withExtension: 'h') ensureDelete
]

{ #category : 'private - factory' }
IGCVisitor >> newStreamFor: aFileReference [

	^ ZnNewLineWriterStream on: aFileReference writeStream
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
			hStream << '/* BEGIN CLASS: ' << aClass name << ' */' << String cr << String cr.
			cStream << '/* BEGIN CLASS: ' << aClass name << ' */' << String cr << String cr.
			(IGCClassGenerator on: self) generateClass: aClass.
			super visitClass: aClass.
			hStream << '/* END CLASS: ' << aClass name << ' */' << String cr << String cr.
			cStream << '/* END CLASS: ' << aClass name << ' */' << String cr << String cr ] ]
	ensure: [
		self pop ]
]

{ #category : 'visiting' }
IGCVisitor >> visitConstructor: aConstructor [

	"abstract classes do not have public constructors"
	aConstructor parent isAbstract ifTrue: [ ^ self ].
	
	(IGCClassGenerator on: self) generateConstructor: aConstructor
]

{ #category : 'visiting' }
IGCVisitor >> visitDestructor: aDestructor [

]

{ #category : 'visiting' }
IGCVisitor >> visitEnum: anEnum [

	(IGCGenerator on: self) generateEnum: anEnum.
	cStream cr
]

{ #category : 'visiting' }
IGCVisitor >> visitFunction: aFunction [

	(IGCGenerator on: self) generateFunction: aFunction.
	cStream cr
]

{ #category : 'visiting' }
IGCVisitor >> visitMethod: aMethod [

	(aMethod isPublic not 
		or: [ aMethod isOperator ]) 
		ifTrue: [ ^ self ].

	"outStream << (aMethod asFunctionSourceWithPrefix: self prefix delimiter: '_')."
	(IGCClassGenerator on: self) generateMethod: aMethod.
	cStream cr
]

{ #category : 'visiting' }
IGCVisitor >> visitNamespace: aNamespace [

	(self includesNamespace: aNamespace cppDeclaration) ifTrue: [
		"skip the namespace since is already there, but try to process nested namespaces"
		self visitAll: (aNamespace elements select: [ :each | each isNamespace ]). 
		 ^ self ].

	self push: aNamespace.
	[ 
		self indentDo: [  
			cStream << '/* BEGIN NAMESPACE: ' << aNamespace name << ' */' << String cr << String cr.
			super visitNamespace: aNamespace.
			cStream << '/* END NAMESPACE: ' << aNamespace name << ' */' << String cr << String cr ] ]
	ensure: [ 
		self pop ]
]

{ #category : 'visiting' }
IGCVisitor >> visitStructure: aStructure [

	(IGCGenerator on: self) generateStructure: aStructure
]

{ #category : 'visiting' }
IGCVisitor >> visitTypedef: aTypedef [
	
	hStream 
		<< 'typedef ' 
		<< aTypedef resolveType cDeclaration 
		<< ' ' 
		<< aTypedef cDeclaration 
		<< ';' 
		<< String cr
]

{ #category : 'visiting' }
IGCVisitor >> visitUnit: aUnit [
	

	cStream := self newCStream.
	hStream := self newHStream.	
	[
		self addHHeaders.
		self addHPreamble.
		self addCHeaders.
		self addCPreamble.
		self visitAll: aUnit elements.
		self endCPreamble.
		self endHFile ]
	ensure: [ 
		hStream close.
		cStream close ]
]
