Class {
	#name : #SpaceShipCardInventory,
	#superclass : #Object,
	#instVars : [
		'spaceShip',
		'activeCards',
		'cards'
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
SpaceShipCardInventory >> cards [

	^ cards
]

{ #category : #drawing }
SpaceShipCardInventory >> draw: aCard [ 

	cards add: aCard
]

{ #category : #testing }
SpaceShipCardInventory >> includes: aCard [

	^ cards anySatisfy: [ :card | card == aCard ]
]

{ #category : #initialization }
SpaceShipCardInventory >> initializeCarriedBy: aSpaceShip [

	spaceShip := aSpaceShip.
	cards := OrderedCollection new.
	activeCards := OrderedCollection new
]

{ #category : #removing }
SpaceShipCardInventory >> remove: aCard [

	cards remove: aCard
]

{ #category : #accessing }
SpaceShipCardInventory >> spaceShip [
	^ spaceShip
]
