Class {
	#name : 'CigClassDirectTranslation',
	#superclass : 'CigTranslation',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'testing' }
CigClassDirectTranslation >> appliesTo: aType [
	| element |
	
	element := aType element.
	^ element notNil 
		and: [ element isClass
		and: [ element isClassTemplate not
		and: [ aType isReference not
		and: [ aType isPointer not ] ] ] ]
]

{ #category : 'accessing' }
CigClassDirectTranslation >> cDeclaration [

	^ nil
]

{ #category : 'accessing' }
CigClassDirectTranslation >> cDeclarationOf: aType [

	^ aType cDeclarationFromReference
]

{ #category : 'converting' }
CigClassDirectTranslation >> cToCPP: aName from: aNode [

	^ self templateCPP format: { 
		self cppDeclarationOf: aNode resolveType.
		aName }
]

{ #category : 'accessing' }
CigClassDirectTranslation >> cppDeclaration [

	^ nil
]

{ #category : 'accessing' }
CigClassDirectTranslation >> cppDeclarationOf: aType [

	^ aType cppDeclarationFromReference
]

{ #category : 'converting' }
CigClassDirectTranslation >> cppToC: functionString from: aMethod [
	| type |

	type := aMethod resolveReturnType.
	^ self templateC 
		format: { 
			#functionCall -> functionString.
			#cppDecl -> (self cppDeclarationOf: type).
			#cDecl -> (self cDeclarationOf: type)
		} asDictionary
]

{ #category : 'accessing' }
CigClassDirectTranslation >> templateC [

	^ 'auto _tmp = {functionCall};
	auto _result = new {cppDecl}();
	memcpy(_result, &_tmp, sizeof({cppDecl}));
	return ({cDecl})_result'
]

{ #category : 'accessing' }
CigClassDirectTranslation >> templateCPP [

	^ '*({1}*){2}'
]
