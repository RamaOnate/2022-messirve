Class {
	#name : #DeckHolder,
	#superclass : #Object,
	#instVars : [
		'cards',
		'discardPile'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
DeckHolder class >> assertSizeOf: cards [

	cards size > 0 ifFalse: [ 
		Error signal: 'DeckHolder must have at least 1 card' ]
]

{ #category : #initialization }
DeckHolder class >> formedBy: cards [

	self assertSizeOf: cards.
	^ self new initializeFormedBy: cards
]

{ #category : #accessing }
DeckHolder >> cards [

	^ cards
]

{ #category : #accessing }
DeckHolder >> discardPile [

	^ discardPile
]

{ #category : #initialization }
DeckHolder >> initializeFormedBy: someCards [

	cards := someCards asOrderedCollection.
	discardPile := OrderedCollection new.
]

{ #category : #accessing }
DeckHolder >> pickOne [

	| cardPicked |
	cards isEmpty
		ifTrue: [ 
			discardPile isEmpty
				ifFalse: [ 
					cards := discardPile shuffle.
					discardPile := discardPile removeAll.
					cardPicked := cards removeFirst ]
				ifTrue: [ Error signal: 'No cards available to pick up' ] ]
		ifFalse: [ cardPicked := cards removeFirst ].
	^ cardPicked
]

{ #category : #accessing }
DeckHolder >> putAway: aCard [

	discardPile add: aCard
]
