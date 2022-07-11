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
DeckHolder class >> formedBy: cards [ 

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

{ #category : #'as yet unclassified' }
DeckHolder >> putAway: aCard [

	discardPile add: aCard
]
