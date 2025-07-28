Class {
	#name : 'CigNameGenerator',
	#superclass : 'CigVisitor',
	#instVars : [
		'withCamelCase',
		'withPrefixInFunctionName',
		'withFunctionProtocolGroupByHeader',
		'renaming'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'private' }
CigNameGenerator >> applyCamelCaseTo: aString [

	self isCamelCase ifFalse: [ ^ aString ].
	
	^ String streamContents: [ :stream | 
		(aString substrings: '_') 
			do: [ :each | stream << each capitalized ] ]
]

{ #category : 'private' }
CigNameGenerator >> applyFunctionModifiersTo: aString in: anElement [
	| result |

	result := aString.
	self isPrefixInFunctionName ifFalse: [ 
		result := self 
			applyPrefixInFunctionName: result
			in: anElement ].

	^ result
]

{ #category : 'private' }
CigNameGenerator >> applyPossibleRanameTo: aString [

	^ renaming
		at: aString
		ifAbsent: [ aString ]
]

{ #category : 'private' }
CigNameGenerator >> applyPrefixInFunctionName: aString in: anElement [
	| prefix result |
	
	prefix := anElement root prefix.
	(aString asLowercase beginsWith: prefix asLowercase) ifFalse: [ ^ aString ].
	
	result := aString allButFirst: prefix size.
	[ result first = $_ ] 
	whileTrue: [ result := result allButFirst ].
	
	^ result
]

{ #category : 'private' }
CigNameGenerator >> applyPrefixTo: name prefix: prefix [

	^ String streamContents: [ :stream |
		(name asLowercase beginsWith: prefix asLowercase)
			ifFalse: [ stream << prefix capitalized ].
		stream << name ]
]

{ #category : 'initialization' }
CigNameGenerator >> initialize [

	super initialize.
	renaming := Dictionary new.
	self withCamelCase.
	self withPrefixInFunctionName.
	self withFunctionProtocolGroupByHeader
]

{ #category : 'testing' }
CigNameGenerator >> isCamelCase [

	^ withCamelCase
]

{ #category : 'testing' }
CigNameGenerator >> isFunctionProtocolGroupByHeader [

	^ withFunctionProtocolGroupByHeader
]

{ #category : 'testing' }
CigNameGenerator >> isPrefixInFunctionName [

	^ withPrefixInFunctionName
]

{ #category : 'accessing' }
CigNameGenerator >> rename: aName as: aRenamedName [
	"Sometimes the generated name will conflict with an existing one (or it will 
	 be ugly, or not good for our purpose in any way). 
	 We can apply a rename to our convenience by declaring it here.
	 e.g. `nameGenerator rename: 'Archive' as: 'ArchiveFile'`"

	renaming at: aName put: aRenamedName
]

{ #category : 'visiting' }
CigNameGenerator >> visit: anElement [

	^ anElement acceptNameGenerator: self
]

{ #category : 'visiting' }
CigNameGenerator >> visitConstructor: anElement [
	| params |

	^ (String streamContents: [ :stream | 
			stream 
				<< anElement disambiguatedName uncapitalized 
				<< '_new'.
			(params := self parameters) size = 1
				ifTrue: [ 
					stream << ': ' << params first name  ]
				ifFalse: [  
					self parameters do: [ :each | 
						stream 
							<< each name  
							<< ': ' 
							<< each name 
							<< ' ' ] ] ])
		trimmed
]

{ #category : 'visiting' }
CigNameGenerator >> visitElement: anElement [
	| unit prefix name fullName |
	unit := anElement root.
	prefix := unit prefix asLowercase.
	name := self applyCamelCaseTo: anElement sanitizedName.
	fullName := self applyPrefixTo: name prefix: prefix.
	(anElement name beginsWith: prefix) ifFalse: [
		"it may happen that the name unprefixed clashes with a name prefixed
		 (e.g. in the case of CurlSockaddr and sockaddr, which are both present 
		 in the translated unit of libcurl). 
		 This can happen just ONE time (otherwise there will be an error) 
		 but it can happen. For now I am just letting the original name in this 
		 cases (it may create clashes with other projects, but we can use the 
		 rename for it)"
		unit elements
			detect: [ :each | 
				(each name = fullName) 
				or: [ each name asLowercase = (prefix, '_', anElement name) asLowercase ] ]
			ifFound: [ :each | fullName := name ] ].
	
	^ self applyPossibleRanameTo: fullName
]

{ #category : 'visiting' }
CigNameGenerator >> visitFunction: anElement [

	^ (String streamContents: [ :stream | 
			stream  << (self 
				applyFunctionModifiersTo: anElement sanitizedName
				in: anElement).
			anElement buildParametersOn: stream ])
		trimmed
]

{ #category : 'visiting' }
CigNameGenerator >> visitFunctionProtocol: anElement [
	"This is a stub to change the protocol where a function will be stored.
	 In general, we are storing them in 'public' but as a library can have a lot of 
	 functions we may be willing to change this for better understanding."

	^ (self isFunctionProtocolGroupByHeader and: [ anElement location isEmptyOrNil not ]) 
		ifTrue: [ 'public - ', anElement location asFileReference base ]
		ifFalse: [ 'public' ]
]

{ #category : 'visiting' }
CigNameGenerator >> visitMethod: anElement [

	^ (String streamContents: [ :stream | 
			stream  << anElement disambiguatedName uncapitalized.
			anElement buildParametersOn: stream ])
		trimmed
]

{ #category : 'visiting' }
CigNameGenerator >> visitNamespace: anElement [

	^ (self visitElement: anElement), 'Namespace'
]

{ #category : 'visiting' }
CigNameGenerator >> visitTypedef: anElement [

	"typedef will be generated as itself (no prefix, since is not a class)"
	^ anElement name
]

{ #category : 'visiting' }
CigNameGenerator >> visitVariadic: anElement [
	
	self error: 'Variadics do not require names (they are taken from its declaration)'
]

{ #category : 'accessing' }
CigNameGenerator >> withCamelCase [
	"Indicates the structures generated (struct, unions, enum, classes) will be translated to a 
	 camel case convention. e.g. My_struct_with_underscores will become MyStructWithUnderscores. 
	 DEFAULT: true (as it looks more according to our own conventions)"

	withCamelCase := true
]

{ #category : 'accessing' }
CigNameGenerator >> withFunctionProtocolGroupByHeader [
	"Indicate when the function protocol will be grouped by header, generating a list of 
	 'public - headername' protocols.
	 DEFAULT: true."

	withFunctionProtocolGroupByHeader := true
]

{ #category : 'accessing' }
CigNameGenerator >> withPrefixInFunctionName [
	"Indicates if the function will keep a prefix equivallent to the library prefix in its name 
	 in case it has it. E.g. A function of an Xml library named xml_do_something() will have as 
	 name xml_do_something if this is true, do_something if false.
	 DEFAULT: true"

	withPrefixInFunctionName := true
]

{ #category : 'accessing' }
CigNameGenerator >> withoutCamelCase [

	withCamelCase := false
]

{ #category : 'accessing' }
CigNameGenerator >> withoutFunctionProtocolGroupByHeader [
	"Indicate when the function protocol will NOT be grouped by header, generating a single 
	 'public' protocol to contain all generated functions."

	withFunctionProtocolGroupByHeader := false
]

{ #category : 'accessing' }
CigNameGenerator >> withoutPrefixInFunctionName [

	withPrefixInFunctionName := false
]
