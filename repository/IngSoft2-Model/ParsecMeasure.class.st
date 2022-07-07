Class {
	#name : #ParsecMeasure,
	#superclass : #Object,
	#instVars : [
		'parsecs'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #asserting }
ParsecMeasure class >> assertValid: someParsecs [

	someParsecs > 0 ifFalse: [ 
		Error signal: 'Parsecs must be greater than zero' ]
]

{ #category : #'instance creation' }
ParsecMeasure class >> of: parsecs [

	self assertValid: parsecs.
	^ self new initializeOf: parsecs
]

{ #category : #initialization }
ParsecMeasure >> initializeOf: someParsecs [

	parsecs := someParsecs
]

{ #category : #accessing }
ParsecMeasure >> totalParsecs [

	^ parsecs
]
