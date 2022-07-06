Class {
	#name : #HyperJumpEffect,
	#superclass : #BoardEffect,
	#instVars : [
		'sequence',
		'distances'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #asserting }
HyperJumpEffect class >> assertValid: someParsecs and: someLightyears [

	someParsecs size = someLightyears size ifFalse: [ 
		Error signal:
			'Parsec and lightyear collection must have the same size' ]
]

{ #category : #initialization }
HyperJumpEffect class >> with: someParsecs and: someLightyears [

	| distanceUnits |
	self assertValid: someParsecs and: someLightyears.
	distanceUnits := OrderedCollection new.
	1 to: someParsecs size do: [ :i | 
		distanceUnits add: (SpaceGameDistanceUnit
				 with: (someParsecs at: i)
				 and: (someLightyears at: i)) ].
	^ self new initializeWith: distanceUnits
]

{ #category : #private }
HyperJumpEffect >> applyOn: statuses activatedBy: aStatus playedOn: aBoard and: aGame appliedBy: effectApplicator [

	| aDistance |
	aDistance := distances at: sequence currentSequenceNumber.
	sequence next.

	^ effectApplicator
		  applyHyperJumpEffectWith: aDistance
		  on: statuses
		  activatedBy: aStatus
		  playedOn: aBoard
		  and: aGame
]

{ #category : #initialization }
HyperJumpEffect >> initializeWith: someDistanceUnits [

	distances := someDistanceUnits.
	sequence := Sequence formedBy: distances.
]
