Class {
	#name : 'CigPharoConstantsPoolGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private' }
CigPharoConstantsPoolGenerator class >> constantsTemplate [

	^ '
#define fmt_spec(x) _Generic((x), \
    int: "%d", \
    unsigned int: "%u", \
    long: "%ld", \
    unsigned long: "%lu", \
    long long: "%lld", \
    unsigned long long: "%llu", \
    short: "%hd", \
    unsigned short: "%hu", \
    signed char: "%hhd", \
    unsigned char: "%hhu", \
    char: "%c", \
    float: "%f", \
    double: "%f", \
    long double: "%Lf", \
    char *: "\"%s\"", \
    const char *: "\"%s\"", \
    default: "<unknown type>")
#define print_macro(x) \
    do { \
        printf("%s=", #x); \
        printf(fmt_spec((x)+0), (x)+0); \
        printf("\n"); \
    } while (0)
'
]

{ #category : 'private' }
CigPharoConstantsPoolGenerator >> addClassAccessors: aCollection [

	aCollection do: [ :each | 
		self generatedClass class 
			compileSilently: ('{1}

	^ {1}' format: { each })
			classified: 'accessing' ]
]

{ #category : 'private' }
CigPharoConstantsPoolGenerator >> addClassInitializationMethodConstants: aDictionary [

	generatedClass class 
		compile: (self classInitializationTemplate: aDictionary)
		classified: 'class initialization'.
		
	generatedClass initialize
]

{ #category : 'private' }
CigPharoConstantsPoolGenerator >> addClassWithConstants: aCollection [
	| typesName |

	typesName := self libraryConstantsName.
	generatedClass := SharedPool << typesName asSymbol
		sharedVariables: (self collectSharedVariables: aCollection); 
		tag: 'Library';
		package: self packageName;
		install
]

{ #category : 'private' }
CigPharoConstantsPoolGenerator >> classInitializationTemplate: aDictionary [

	^ String streamContents: [ :stream |
		stream << 'initialize'; cr; cr.
		aDictionary associations 
			do: [ :assoc | 
				stream tab.
				stream <<  assoc key << ' := '.
				"no point on print hex values of 0-9 values"
				(assoc value isNumber 
					and: [ self shouldPrintNumbersAsHex 
					and: [ assoc value abs > 9 ] ])
					ifTrue: [ stream << assoc value hex ]
					ifFalse: [ stream print: assoc value ] ]
			separatedBy: [ 
				stream << '.'; cr ] ]
]

{ #category : 'private' }
CigPharoConstantsPoolGenerator >> collectConstantValues: aCollection [
	"
	1. generate temporal file and compile it, get results.
	2. parse and collect results into a dictionary.
	"
	| macros fileReference binaryReference result |

	logger trace: aCollection.

	macros := OrderedDictionary new.
	fileReference := self generateCFileWith: aCollection.
	binaryReference := self compileCFile: fileReference.
	result := self executeCommand: binaryReference.

	result trimmed linesDo: [ :each | 
		| macroName macroValue |
		
		macroName := each copyUpTo: $=.
		macroValue := each allButFirst: macroName size + 1.
		logger trace: macroName.
		macros 
			at: macroName 
			put: (self convert: macroValue) ].
	
	^ macros
]

{ #category : 'private' }
CigPharoConstantsPoolGenerator >> collectSharedVariables: aCollection [
		
	^ aCollection 
		collect: [ :each | each asSymbol ] 
		as: Array
]

{ #category : 'private' }
CigPharoConstantsPoolGenerator >> compileCFile: fileReference [
	| result binaryReference command |

	logger trace: fileReference.

	binaryReference := fileReference withoutExtension ensureDelete.
	command := 'clang -std=c11 -Wall {3} {1} -o {2}' format: { 
		fileReference basename. 
		binaryReference basename.
		String streamContents: [ :stream |
			self file cIncludePathsAsArguments
				do: [ :each | stream << each ] 
				separatedBy: [ stream space ] ] }.
	
	CigCommandExecutor execute: command. 

	^ binaryReference
]

{ #category : 'private' }
CigPharoConstantsPoolGenerator >> convert: aString [

	aString first = $" ifTrue: [
		^ aString copyFrom: 2 to: (aString size - 1) ].

	^ aString asNumber
]

{ #category : 'private' }
CigPharoConstantsPoolGenerator >> executeCommand: binaryReference [

	logger trace: binaryReference.
	^ CigCommandExecutor execute: binaryReference fullName.	

]

{ #category : 'generating' }
CigPharoConstantsPoolGenerator >> generate [

	^ self addClassWithConstants: #()
]

{ #category : 'private' }
CigPharoConstantsPoolGenerator >> generateCFileWith: aCollection [
	| fileReference |

	fileReference := (FileLocator temp 
		/ 'CIG' 
		/ (self file libraryName, '_constants')) 
		withExtension: 'c'.
	fileReference parent ensureCreateDirectory.
	
	fileReference 
		ensureDelete;
		writeStreamDo: [ :stream | 

			stream << '#import <stdio.h>'; lf.
			
			self file constantGenerator headers
				ifNotNil: [ :aCollection | 
					aCollection 
						do: [ :each | stream << '#import <' << each << '>' ]
						separatedBy: [ stream lf ] ]
				ifNil: [
					self file imports 
						do: [ :eachTarget | 
							eachTarget isUnit 
								ifTrue: [ stream << eachTarget unit ]
								ifFalse: [ stream << '#import <' << eachTarget name << '>' ] ]
						separatedBy: [ stream lf ] ].

			stream << self class constantsTemplate; lf.
			
			stream << 'int main() {'; lf.
			aCollection 
				do: [ :each | 
					stream tab. 
					stream << 'print_macro(' << each << ');'; lf ] .
			stream tab; << 'return 0;'; lf.
			stream << '}'; lf ].

	^ fileReference
]

{ #category : 'generating' }
CigPharoConstantsPoolGenerator >> generateConstants: aCollection [
	| macros |

	macros := self collectConstantValues: aCollection.
	macros ifEmpty: [ ^ self ].
	
	self addClassWithConstants: macros keys sorted.
	self addClassInitializationMethodConstants: macros.
	self addClassAccessors: macros keys
]

{ #category : 'accessing' }
CigPharoConstantsPoolGenerator >> generatedClass [

	^ generatedClass
]

{ #category : 'private' }
CigPharoConstantsPoolGenerator >> shouldPrintNumbersAsHex [

	^ self file constantGenerator shouldPrintNumbersAsHex
]
