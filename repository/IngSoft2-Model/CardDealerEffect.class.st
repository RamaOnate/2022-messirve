Class {
	#name : #CardDealerEffect,
	#superclass : #BoardEffect,
	#instVars : [
		'card'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
CardDealerEffect class >> createHanding: aCard [

	^ self new initializeHanding: { aCard }
]

{ #category : #initialization }
CardDealerEffect class >> handing: aCard [

	^ self createHanding: aCard
]

{ #category : #'as yet unclassified' }
CardDealerEffect class >> handingFrom: aDeck [ 
	
	^ self createHanding: aDeck
]

{ #category : #initialization }
CardDealerEffect class >> handingRandomCards [

	^ self new initializeHanding: { CancellationCard new . AccelerationCard new . OverloadCard new . SpeedCard new . RedoCard new . RepeatCard new }
]

{ #category : #private }
CardDealerEffect >> applyOn: statuses activatedBy: aStatus playedOn: aBoard and: aGame appliedBy: effectApplicator [

	^ effectApplicator
		  applyCardDealerEffectTo: aStatus
		  with: (card at: 1) pickOne
		  from: statuses
		  playedOn: aGame
]

{ #category : #initialization }
CardDealerEffect >> initializeHanding: aCard [

	card := aCard
]
