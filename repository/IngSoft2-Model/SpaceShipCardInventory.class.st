Class {
	#name : #SpaceShipCardInventory,
	#superclass : #Object,
	#instVars : [
		'spaceShip',
		'activeCards',
		'deck'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
SpaceShipCardInventory class >> carriedBy: aSpaceShip [

	^ self new initializeCarriedBy: aSpaceShip
]

{ #category : #accessing }
SpaceShipCardInventory >> activeCards [

	^ activeCards
]

{ #category : #adding }
SpaceShipCardInventory >> addCardToActiveCards: aCard [

	activeCards add: aCard
]

{ #category : #accessing }
SpaceShipCardInventory >> deck [

	^ deck
]

{ #category : #drawing }
SpaceShipCardInventory >> draw: aCard [ 

	deck add: aCard
]

{ #category : #testing }
SpaceShipCardInventory >> includes: aCard [

	^ deck anySatisfy: [ :card | card == aCard ]
]

{ #category : #initialization }
SpaceShipCardInventory >> initializeCarriedBy: aSpaceShip [

	spaceShip := aSpaceShip.
	deck := OrderedCollection new.
	activeCards := OrderedCollection new
]

{ #category : #removing }
SpaceShipCardInventory >> remove: aCard [

	deck remove: aCard
]

{ #category : #accessing }
SpaceShipCardInventory >> spaceShip [
	^ spaceShip
]
