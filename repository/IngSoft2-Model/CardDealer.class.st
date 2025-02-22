Class {
	#name : #CardDealer,
	#superclass : #Object,
	#instVars : [
		'deck',
		'cardHandingSequence'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
CardDealer class >> handing: cards [

	^ self new initializeHanding: cards
]

{ #category : #private }
CardDealer >> hand: aCard to: aSpaceShipInventory [

	^ aSpaceShipInventory draw: aCard
]

{ #category : #'action handling' }
CardDealer >> handCardFromDeckTo: aSpaceShipInventory [

	| cardToHand |
	cardToHand := deck pickOne.
	^ aSpaceShipInventory draw: cardToHand
]

{ #category : #initialization }
CardDealer >> initializeHanding: aDeck [

	deck := aDeck
]

{ #category : #'action handling' }
CardDealer >> inventoriesAfterDrawingTwoFrom: inventories [

	| inventoriesAfterDrawingOne |
	inventoriesAfterDrawingOne := inventories collect: [ :inventory | 
		                              self handCardFromDeckTo: inventory ].
	^ inventoriesAfterDrawingOne collect: [ :inventory | 
		  self handCardFromDeckTo: inventory ]
]

{ #category : #private }
CardDealer >> putAway: aCard [

	deck putAway: aCard
]
