Class {
	#name : #InfiniteDeck,
	#superclass : #Object,
	#instVars : [
		'cards',
		'cardSequence'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #event }
InfiniteDeck class >> randomCardAssignation [

	| source cancellationCard discreteProbabilityDistribution accelerationCard overloadCard speedCard redoCard repeatCard probabilityEvents |
	cancellationCard := CancellationCard new.
	accelerationCard := AccelerationCard new.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	redoCard := RedoCard new.
	repeatCard := RepeatCard new.


	probabilityEvents := { 
		                     (ProbabilityEvent
			                      of: cancellationCard
			                      with: 1 / 6).
		                     (ProbabilityEvent
			                      of: accelerationCard
			                      with: 1 / 6).
		                     (ProbabilityEvent of: overloadCard with: 1 / 6).
		                     (ProbabilityEvent of: speedCard with: 1 / 6).
		                     (ProbabilityEvent of: redoCard with: 1 / 6).
		                     (ProbabilityEvent of: repeatCard with: 1 / 6) }.

	discreteProbabilityDistribution := DiscreteProbabilityDistribution 
		                                   withAll: probabilityEvents.
	source := DiscreteProbabilityEventSource with:
		          discreteProbabilityDistribution.
	^ source
]

{ #category : #initialization }
InfiniteDeck class >> with: amountOfCards [

	| source |
	source := self randomCardAssignation.
	^ self new initializeMadeOf: (source next: 100)
]

{ #category : #initialization }
InfiniteDeck >> initializeMadeOf: someCards [

	cards := someCards.
	cardSequence := Sequence formedBy: someCards
]

{ #category : #private }
InfiniteDeck >> pickOne [

	| cardPicked |
	cardPicked := cards at: cardSequence currentSequenceNumber.
	cardSequence next.
	^ cardPicked
]

{ #category : #private }
InfiniteDeck >> putAway: aCard [

	^ self
]
