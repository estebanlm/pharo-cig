Class {
	#name : 'IGStdStringTranslation',
	#superclass : 'IGTranslation',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'testing' }
IGStdStringTranslation >> appliesTo: aType [

	^ aType parseType name = 'std::string'
]

{ #category : 'accessing' }
IGStdStringTranslation >> cDeclaration [

	^ 'char*'
]

{ #category : 'accessing' }
IGStdStringTranslation >> cppDeclaration [

	^ 'char*'
]

{ #category : 'accessing' }
IGStdStringTranslation >> templateC [
	
	^ 'auto _tmp = {1};
	auto _result = _tmp.c_str();
	return (char*)_result'
]

{ #category : 'accessing' }
IGStdStringTranslation >> templateCPP [

	^ 'std::string({1})'
]
