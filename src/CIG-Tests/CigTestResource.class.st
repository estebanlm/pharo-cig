Class {
	#name : 'CigTestResource',
	#superclass : 'TestResource',
	#instVars : [
		'translatedUnitTvison',
		'translatedUnitFinalcut',
		'translatedUnitNoiseutils',
		'translatedUnitNoise',
		'translatedUnitStdArray',
		'translatedUnitRaylib',
		'translatedUnitIcal',
		'translatedUnitOpenSSL',
		'translatedUnitLibXML',
		'translatedUnitLibvips'
	],
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'utilities' }
CigTestResource class >> build: aLibName with: aHeaderGenerator [

	self reset.
	self resourcePath ensureCreateDirectory.
	FLSerializer 
		serialize: aHeaderGenerator translateUnit removeAllUnknowns
		toFileNamed: (self resourceFileName: aLibName)
]

{ #category : 'private - specs' }
CigTestResource class >> finalcutSpec [

	^ CigCppLibraryGenerator new
		prefix: 'Fc';
		libraryName: 'finalcut'; 
		cDefine: 'HAVE_CONFIG_H';
		cDefine: 'COMPILE_FINAL_CUT';
		import: '/home/esteban/dev/vm/finalcut/final/final.h';
		cIncludePath: '/home/esteban/dev/vm/finalcut/final';
		cIncludePath: '/home/esteban/dev/vm/finalcut';
		cIncludePath: '/';
		cLib: 'final';
		yourself
]

{ #category : 'private - specs' }
CigTestResource class >> icalSpec [
	
	^ CigCLibraryGenerator new
		prefix: 'ical';
		bindingsName: 'ical';
		import: 'libical/ical.h';
		yourself.
]

{ #category : 'private - specs' }
CigTestResource class >> libXMLSpec [
	
	^ CigCLibraryGenerator new
	prefix: 'Xml';
	bindingsName: 'xml';
	from: 'iconv.h' import: #('iconv_t');
	from: 'libxml2/libxml/tree.h' import: #(
		'_xmlNode' 
		'_xmlDtd' 
		'_xmlDoc');
	import: 'libxml2/libxml/xmlreader.h';
	import: 'libxml2/libxml/encoding.h';
	import: 'libxml2/libxml/xmlwriter.h';
	cIncludePath: '/usr/include/libxml2';
	cTypedef: '_xmlCharEncodingHandler__uconv_t' as: #void;
	yourself.	
	
]

{ #category : 'private - specs' }
CigTestResource class >> libvipsSpec [
	
	^ CigCppLibraryGenerator new
	prefix: 'Vp';
	bindingsName: 'vips';
	import: '/usr/include/vips/vips8';
	cIncludePath: '/usr/include/c++/14.1.1';
	cIncludePath: '/usr/include/vips';
	cIncludePath: '/usr/include/glib-2.0';
	cIncludePath: '/usr/lib/glib-2.0/include';
	cTypedef: '_pid_t' as: 'pid_t';
	cTypedef: '__pid_t' as: 'pid_t';
	yourself
]

{ #category : 'private - specs' }
CigTestResource class >> noiseSpec [
	
	^ CigCppLibraryGenerator new
		prefix: 'No';
		libraryName: 'noise';
		import: '/home/esteban/dev/vm/libnoise/include/noise/noise.h';
		cIncludePath: '/home/esteban/dev/vm/libnoise/include';
		cIncludePath: '/home/esteban/dev/vm/libnoise/include/noise';
		cLib: 'noise';
		yourself
]

{ #category : 'private - specs' }
CigTestResource class >> noiseutilsSpec [
	
	^ CigCppLibraryGenerator new
		prefix: 'Nu';
		libraryName: 'noiseutils'; 
		import: '/home/esteban/dev/vm/noiseutils/noiseutils.h';
		cIncludePath: '/home/esteban/dev/vm/noiseutils';
		cIncludePath: '/home/esteban/dev/vm/libnoise/include';
		cIncludePath: '/home/esteban/dev/vm/libnoise/include/noise';
		namespace: CigNoiseNamespace;
		namespace: CigModelNamespace;
		namespace: CigModuleNamespace;
		cLib: 'noise';
		cLib: 'noiseutils';
		yourself
]

{ #category : 'private - specs' }
CigTestResource class >> openSSLSpec [
	
	^ CigCLibraryGenerator new
		prefix: 'SSL';
		bindingsName: 'ssl';
		import: 'openssl/types.h';
		import: 'openssl/bio.h';
		import: 'openssl/ssl.h';
		import: 'openssl/evp.h';
		import: 'openssl/crypto.h';
		import: 'openssl/decoder.h';
		import: 'openssl/core_names.h';
		import: 'openssl/pem.h';
		import: 'openssl/err.h';
		cTypedef: 'pthread_once_t' as: #void;
		cTypedef: 'pthread_key_t' as: #void;
		cTypedef: 'pthread_t' as: #void;
		cTypedef: 'crypto_ex_data_st_stack_st_void' as: #void; 
		yourself
]

{ #category : 'private - specs' }
CigTestResource class >> raylibSpec [
	
	^ CigCLibraryGenerator new
		prefix: 'Ray';
		bindingsName: 'raylib';
		import: '/home/esteban/dev/vm/raylib/src/raylib.h';
		cIncludePath: '/home/esteban/dev/vm/raylib/src';
		cLib: 'raylib';
		yourself

]

{ #category : 'utilities' }
CigTestResource class >> readResource: aString [

	^ FLMaterializer materializeFromFileNamed: (self resourceFileName: aString)
]

{ #category : 'utilities' }
CigTestResource class >> rebuildAll [
	<script>

	self build: 'noise' with: self noiseSpec.
	self build: 'noiseutils' with: self noiseutilsSpec.
	self build: 'tvision' with: self tvisionSpec.
	self build: 'finalcut' with: self finalcutSpec.
	self build: 'stdArray' with: self stdArraySpec.
	self build: 'raylib' with: self raylibSpec.
	self build: 'ical' with: self icalSpec.
	self build: 'openssl' with: self openSSLSpec.
	self build: 'libxml' with: self libXMLSpec.
	self build: 'libvips' with: self libvipsSpec

]

{ #category : 'utilities' }
CigTestResource class >> resourceFileName: aLibName [

	^ (self resourcePath / (aLibName asLowercase, '.fuel')) fullName
]

{ #category : 'utilities' }
CigTestResource class >> resourcePath [

	^ (IceRepository repositoryNamed: 'pharo-cig') location / 'test-resources'
]

{ #category : 'private - specs' }
CigTestResource class >> stdArraySpec [
	
	^ CigCppLibraryGenerator new
		prefix: 'Std';
		bindingsName: 'std';
		import: 'array';
		withoutSpecialElements;
		yourself
]

{ #category : 'private - specs' }
CigTestResource class >> tvisionSpec [
	
	^ CigCppLibraryGenerator new
		prefix: 'Tv';
		bindingsName: 'tvision'; 
		import: '/home/esteban/dev/vm/tvision/include/tvision/tv.h';
		cIncludePath: '/home/esteban/dev/vm/tvision/include';
		cIncludePath: '/home/esteban/dev/vm/tvision/include/tvision';
		cIncludePath: '/home/esteban/dev/vm/tvision/include/tvision/compat/borland';
		cIncludePath: '/home/esteban/dev/vm/tvision/include/tvision/compat/windows';
		cLib: 'tvision';
		cDefineBeforeHeader: 'TVISION_NO_STL';
		cDefinesBeforeHeader: #('Uses_EventCodes' 'Uses_MsgBox' 'Uses_TApplication' 'Uses_TBackground' 'Uses_TButton' 'Uses_TChDirDialog' 'Uses_TCheckBoxes' 'Uses_TClipboard' 'Uses_TCluster' 'Uses_TCollection' 'Uses_TColorAttr' 'Uses_TColorDialog' 'Uses_TColorDisplay' 'Uses_TColorGroup' 'Uses_TColorGroupList' 'Uses_TColorItem' 'Uses_TColorItemList' 'Uses_TColorSelector' 'Uses_TCommandSet' 'Uses_TDeskTop' 'Uses_TDialog' 'Uses_TDirCollection' 'Uses_TDirEntry' 'Uses_TDirListBox' 'Uses_TDrawBuffer' 'Uses_TDrawSurface' 'Uses_TEditWindow' 'Uses_TEditor' 'Uses_TEvent' 'Uses_TEventQueue' 'Uses_TFileCollection' 'Uses_TFileDialog' 'Uses_TFileEditor' 'Uses_TFileInfoPane' 'Uses_TFileInputLine' 'Uses_TFileList' 'Uses_TFilterValidator' 'Uses_TFindDialogRec' 'Uses_TFrame' 'Uses_TGroup' 'Uses_THardwareInfo' 'Uses_THistory' 'Uses_THistoryViewer' 'Uses_THistoryWindow' 'Uses_TIndicator' 'Uses_TInputLine' 'Uses_TKeys' 'Uses_TLabel' 'Uses_TListBox' 'Uses_TListViewer' 'Uses_TLookupValidator' 'Uses_TMemo' 'Uses_TMenu' 'Uses_TMenuBar' 'Uses_TMenuBox' 'Uses_TMenuItem' 'Uses_TMenuPopup' 'Uses_TMenuView' 'Uses_TMonoSelector' 'Uses_TMultiCheckBoxes' 'Uses_TNSCollection' 'Uses_TNSSortedCollection' 'Uses_TObject' 'Uses_TOutline' 'Uses_TOutlineViewer' 'Uses_TPReadObjects' 'Uses_TPWrittenObjects' 'Uses_TPXPictureValidator' 'Uses_TPalette' 'Uses_TParamText' 'Uses_TPoint' 'Uses_TProgram' 'Uses_TRadioButtons' 'Uses_TRangeValidator' 'Uses_TRect' 'Uses_TReplaceDialogRec' 'Uses_TResourceCollection' 'Uses_TResourceFile' 'Uses_TResourceItem' 'Uses_TSItem' 'Uses_TScreen' 'Uses_TScreenCell' 'Uses_TScrollBar' 'Uses_TScroller' 'Uses_TSearchRec' 'Uses_TSortedCollection' 'Uses_TSortedListBox' 'Uses_TStaticText' 'Uses_TStatusDef' 'Uses_TStatusItem' 'Uses_TStatusLine' 'Uses_TStrIndexRec' 'Uses_TStrListMaker' 'Uses_TStreamable' 'Uses_TStreamableClass' 'Uses_TStreamableTypes' 'Uses_TStringCollection' 'Uses_TStringList' 'Uses_TStringLookupValidator' 'Uses_TSubMenu' 'Uses_TSurfaceView' 'Uses_TSystemError' 'Uses_TTerminal' 'Uses_TText' 'Uses_TTextDevice' 'Uses_TTimerQueue' 'Uses_TVMemMgr' 'Uses_TValidator' 'Uses_TView' 'Uses_TWindow' 'Uses_ViewCommands' 'Uses_fpbase' 'Uses_fpstream' 'Uses_ifpstream' 'Uses_iopstream' 'Uses_ipstream' 'Uses_ofpstream' 'Uses_opstream' 'Uses_otstream' 'Uses_pstream');
		yourself
]

{ #category : 'running' }
CigTestResource >> setUp [
]

{ #category : 'running' }
CigTestResource >> tearDown [

	translatedUnitNoiseutils := nil.
	translatedUnitTvison := nil
]

{ #category : 'accessing' }
CigTestResource >> translatedUnitFinalcut [

	^ translatedUnitFinalcut ifNil: [ 
		translatedUnitFinalcut := self class readResource: 'finalcut' ]
]

{ #category : 'accessing' }
CigTestResource >> translatedUnitIcal [

	^ translatedUnitIcal ifNil: [ 
		translatedUnitIcal := self class readResource: 'ical' ]
]

{ #category : 'accessing' }
CigTestResource >> translatedUnitLibXML [

	^ translatedUnitLibXML ifNil: [ 
		translatedUnitLibXML := self class readResource: 'libxml' ]
]

{ #category : 'accessing' }
CigTestResource >> translatedUnitLibvips [

	^ translatedUnitLibvips ifNil: [ 
		translatedUnitLibvips := self class readResource: 'libvips' ]
]

{ #category : 'accessing' }
CigTestResource >> translatedUnitNoise [

	^ translatedUnitNoise ifNil: [ 
		translatedUnitNoise := self class readResource: 'noise' ]
]

{ #category : 'accessing' }
CigTestResource >> translatedUnitNoiseutils [

	^ translatedUnitNoiseutils ifNil: [ 
		translatedUnitNoiseutils := self class readResource: 'noiseutils' ]
]

{ #category : 'accessing' }
CigTestResource >> translatedUnitOpenSSL [

	^ translatedUnitOpenSSL ifNil: [ 
		translatedUnitOpenSSL := self class readResource: 'openssl' ]
]

{ #category : 'accessing' }
CigTestResource >> translatedUnitRaylib [

	^ translatedUnitRaylib ifNil: [ 
		translatedUnitRaylib := self class readResource: 'raylib' ]
]

{ #category : 'accessing' }
CigTestResource >> translatedUnitStdArray [

	^ translatedUnitStdArray ifNil: [ 
		translatedUnitStdArray := self class readResource: 'stdarray' ]
]

{ #category : 'accessing' }
CigTestResource >> translatedUnitTvision [

	^ translatedUnitTvison ifNil: [ 
		translatedUnitTvison := self class readResource: 'tvision' ]
]
