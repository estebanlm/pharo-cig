Class {
	#name : 'IGClassDirectTranslation',
	#superclass : 'IGTranslation',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'testing' }
IGClassDirectTranslation >> appliesTo: aType [
	| element |
	
	element := aType element.
	^ element notNil 
		and: [ element isClass 
		and: [ aType isReference not
		and: [ aType isPointer not ] ] ]
]

{ #category : 'accessing' }
IGClassDirectTranslation >> cDeclaration [

	^ nil
]

{ #category : 'accessing' }
IGClassDirectTranslation >> cDeclarationOf: aType [

	^ aType cDeclarationFromReference
]

{ #category : 'accessing' }
IGClassDirectTranslation >> cppDeclaration [

	^ nil
]

{ #category : 'accessing' }
IGClassDirectTranslation >> cppDeclarationOf: aType [

	^ aType cppDeclarationFromReference
]

{ #category : 'converting' }
IGClassDirectTranslation >> cppToC: functionString from: aMethod [
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
IGClassDirectTranslation >> templateC [

	^ 'auto _tmp = {functionCall};
	auto _result = new {cppDecl}();
	memcpy(_result, &_tmp, sizeof({cppDecl}));
	return ({cDecl})_result'
]
