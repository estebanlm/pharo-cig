Class {
	#name : 'CigStdStringTranslation',
	#superclass : 'CigTranslation',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'testing' }
CigStdStringTranslation >> appliesTo: aType [

	^ aType parseType name = 'std::string'
]

{ #category : 'accessing' }
CigStdStringTranslation >> cDeclaration [

	^ 'char*'
]

{ #category : 'accessing' }
CigStdStringTranslation >> cppDeclaration [

	^ 'char*'
]

{ #category : 'accessing' }
CigStdStringTranslation >> templateC [
	
	^ 'auto _tmp = {1};
	auto _result = _tmp.c_str();
	return (char*)_result'
]

{ #category : 'accessing' }
CigStdStringTranslation >> templateCPP [

	^ 'std::string({1})'
]
