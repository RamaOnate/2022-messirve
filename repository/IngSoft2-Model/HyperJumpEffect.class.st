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

{ #category : #'instance creation' }
HyperJumpEffect class >> withAll: someDistances [ 

	^ self new initializeWith: someDistances
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
