"
C++ contains a few ""standard types"" (standard for C++. that's it) we do not have currently in our system and there is no point on defining special types for them, when they are just aliases of plain C types.
Here there are types taken from: cstdint
"
Class {
	#name : 'CigCPPTypedef',
	#superclass : 'SharedPool',
	#classVars : [
		'int16_t',
		'int32_t',
		'int64_t',
		'int8_t',
		'uint16_t',
		'uint32_t',
		'uint64_t',
		'uint8_t'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'initialization' }
CigCPPTypedef class >> initialize [

	int8_t := #int8.
  	int16_t := #int16.
  	int32_t := #int32.
	int64_t := #int64.
	
	uint8_t := #uint8.
  	uint16_t := #uint16.
  	uint32_t := #uint32.
	uint64_t := #Uint64
]
