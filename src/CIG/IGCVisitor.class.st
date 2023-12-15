Class {
	#name : 'IGCVisitor',
	#superclass : 'IGCBaseVisitor',
	#instVars : [
		'fileReference',
		'stack',
		'cStream',
		'hStream',
		'unnamedEnum'
	],
	#category : 'CIG-Generate-C',
	#package : 'CIG',
	#tag : 'Generate-C'
}

{ #category : 'private - rendering' }
IGCVisitor >> addCHeaders [
		
	cStream << '#include "' << self file fileReference basename << '"' << String cr.
	cStream << '#include "' << (self fileReference withExtension: 'h') basename << '"' << String cr.
	cStream cr
]

{ #category : 'private - rendering' }
IGCVisitor >> addCPreamble [
		
	cStream << 'extern "C" {

'
]

{ #category : 'private - rendering' }
IGCVisitor >> addClassDispose: aClass [
	
	aClass isAbstract ifTrue: [ ^ self ].

	self hStream << ('void {name}_dispose({cClass} self);' 
		format: { 
			#name -> aClass fullName.
			#cClass -> aClass cDeclaration } 
		asDictionary).
	self hStream cr.
	
	self cStream << ('void {name}_dispose({cClass} self) \{
	delete ({cppClass} *)self;
\}' 
		format: { 
			#name -> aClass fullName.
			#cClass -> aClass cDeclaration.
			#cppClass -> aClass cppDeclaration } 
		asDictionary).
	self cStream cr
]

{ #category : 'private - rendering' }
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

{ #category : 'private - rendering' }
IGCVisitor >> addHPreamble [
		
	hStream << 'extern "C" {

'
]

{ #category : 'accessing' }
IGCVisitor >> cStream [

	^ cStream
]

{ #category : 'private - rendering' }
IGCVisitor >> endCPreamble [
		
	cStream << '}
'
]

{ #category : 'private - rendering' }
IGCVisitor >> endHFile [
	| def |
		
	def := self fileReference basenameWithoutExtension asUppercase.
	hStream << '
}
	
#endif /* ' << def << '*/'.
]

{ #category : 'private' }
IGCVisitor >> enumNameFor: anEnum [
	"yeah, enums can be unnamed :P"
	anEnum isUnnamed ifTrue: [
		unnamedEnum := unnamedEnum + 1.
		^ '{1}_unnamed_enum_{2}' format: { 
			anEnum root prefix asLowercase.			
			unnamedEnum } ].

	^ anEnum cDeclaration
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
	stack := Stack new.
	unnamedEnum := 0
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
IGCVisitor >> push: anObject [

	stack push: anObject
]

{ #category : 'visiting' }
IGCVisitor >> visitClass: aClass [

	self push: aClass.
	[  
		self indentDo: [  
			hStream << '/* BEGIN CLASS: ' << aClass name << ' */' << String cr.
			cStream << '/* BEGIN CLASS: ' << aClass name << ' */' << String cr.
			super visitClass: aClass.
			self addClassDispose: aClass.
			hStream << '/* END CLASS: ' << aClass name << ' */' << String cr << String cr.
			cStream << '/* END CLASS: ' << aClass name << ' */' << String cr << String cr ] ]
	ensure: [
		self pop ]
]

{ #category : 'visiting' }
IGCVisitor >> visitClassTemplate: aClassTemplate [

	"
	1. collect defined templates.
	2. generate a typedef for each.
	(this is make in the declaration phase)
	3. generate functions for each.
		- later, in pharo side, we will generate a class and a hierarchy
	"
	self flag: #TODO. "I am skipping method generation for the moment"
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

	"skipping unnamed enums"
	anEnum isUnnamed ifTrue: [ ^ self ].

	"if it does not belongs to a namespace, it will be available at compile 
	 time in C, so we just generate it as a typedef"
	anEnum depth = 1 ifTrue: [ 
		^ self addTypedef: anEnum cppDeclaration as: anEnum cDeclaration ].

	(IGCGenerator on: self) generateEnum: anEnum.
	cStream cr
]

{ #category : 'visiting' }
IGCVisitor >> visitFunction: aFunction [

	aFunction isOperator ifTrue: [ ^ self ].
	
	(IGCGenerator on: self) generateFunction: aFunction.
	cStream cr
]

{ #category : 'visiting' }
IGCVisitor >> visitMethod: aMethod [

	"skipping non public methods and operators (maybe I need to include operators? 
	 e.g. = generates an equals: method?) "
	(aMethod isPublic not 
		or: [ aMethod isOperator ]) 
		ifTrue: [ ^ self ].

	self haltIf: (aMethod parent name = 'TText').
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

	"skip if is template specialization"
	aStructure isTemplateSpecialization ifTrue: [ ^ self ].
	"act as class if it behaves as a class"
	self flag: #TODO. "Maybe add accessors for fields? (style properties)"
	aStructure isClass ifTrue: [ ^ self visitClass: aStructure ].
	"otherwise generate structure"	
	(IGCGenerator on: self) generateStructure: aStructure
]

{ #category : 'visiting' }
IGCVisitor >> visitUnit: aUnit [
	
	root := aUnit.
	
	cStream := self newCStream.
	hStream := self newHStream.	
	[
		self addHHeaders.
		self addHPreamble.
		self addCHeaders.
		self addCPreamble.
		
		hStream << '/* BEGIN SECTION: DECLARATIONS */' << String cr.
		IGCHeaderDeclareVisitor new 
			hStream: self hStream; 
			visit: aUnit.
		hStream << '/* END SECTION: DECLARATIONS */' << String cr << String cr.
		self visitAll: aUnit elements.
		self endCPreamble.
		self endHFile ]
	ensure: [ 
		hStream close.
		cStream close ]
]
