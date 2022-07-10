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

{ #category : #initialization }
DeckHolder >> initializeFormedBy: someCards [

	cards := someCards asOrderedCollection.
	discardPile := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
DeckHolder >> pickOne [

	cards isEmpty
		ifTrue: [ 
			cards := discardPile shuffle.
			discardPile := discardPile removeAll ]
		ifFalse: [ 
			discardPile add: cards first.
			cards removeFirst ]
]
