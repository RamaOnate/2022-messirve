Class {
	#name : #HyperJumpEffect,
	#superclass : #BoardEffect,
	#instVars : [
		'sequence',
		'distances'
	],
	#category : #'IngSoft2-Model'
}

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
