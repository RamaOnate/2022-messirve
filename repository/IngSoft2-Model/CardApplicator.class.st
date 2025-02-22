Class {
	#name : #CardApplicator,
	#superclass : #Object,
	#instVars : [
		'cardDealer',
		'inventories',
		'globalInventory',
		'engineApplicator',
		'lastCardPlayed'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
CardApplicator class >> handing: someCards to: somePlayers [

	^ self new initializeHanding: someCards to: somePlayers
]

{ #category : #accessing }
CardApplicator >> activeCardsOf: aSpaceShip [

	^ (inventories detect: [ :inventory | 
		   inventory spaceShip = aSpaceShip ]) activeCards
]

{ #category : #private }
CardApplicator >> applyAllNegatedCardsOf: aCard [

	inventories do: [ :inventory | self applyNegatedAndRemove: aCard from: inventory ].

	globalInventory do: [ :card | 
		card = aCard ifTrue: [ 
			aCard applyNegatedOn: card on: engineApplicator from: self ] ]
]

{ #category : #private }
CardApplicator >> applyDoubledCardsOf: aCard from: aGame [

	inventories do: [ :inventory | 
		self doubleEffectOf: aCard from: inventory in: aGame ].

	globalInventory do: [ :card | 
		card = aCard ifTrue: [ 
			aCard
				activatedTo: self
				poweredBy: engineApplicator
				on: self
				from: aGame ] ]
]

{ #category : #private }
CardApplicator >> applyNegatedAndRemove: aCard from: inventory [

	^ inventory activeCards do: [ :card | 
		  card = aCard ifTrue: [ 
			  aCard
				  applyNegatedOn: inventory spaceShip
				  on: engineApplicator
				  from: self ] ]
]

{ #category : #private }
CardApplicator >> applyRepeatTargetting: aSpaceShip from: aGame [

	aGame applyLastEffectTo: aSpaceShip
]

{ #category : #asserting }
CardApplicator >> assertCardIsActive: aCard [ 

	| activeCardsExist globalCardExists |
	activeCardsExist := inventories anySatisfy: [ :inventory | 
		                    inventory activeCards anySatisfy: [ :activeCard | activeCard == aCard ] ].

	globalCardExists := globalInventory isNotEmpty.
	(globalCardExists or: activeCardsExist) ifFalse: [ 
		Error signal: 'The targeted card is not currently active' ]
]

{ #category : #asserting }
CardApplicator >> assertSpaceShip: aSpaceShip owns: aCard [

	| spaceShipInventory |
	spaceShipInventory := inventories detect: [ :inventory | 
		                      inventory spaceShip = aSpaceShip ].

	(spaceShipInventory includes: aCard) ifFalse: [ 
		Error signal: 'SpaceShip doesnt own that card' ]
]

{ #category : #asserting }
CardApplicator >> assertThereAreActiveCardsInPlay [

	| activeCardsExist globalActiveCardsExist |
	globalActiveCardsExist := globalInventory isNotEmpty.
	activeCardsExist := inventories anySatisfy: [ :inventory | 
		                    inventory activeCards isNotEmpty ].

	(activeCardsExist or: globalActiveCardsExist) ifFalse: [ 
		Error signal: 'No cards available to cancel' ]
]

{ #category : #accessing }
CardApplicator >> cardsInInventoryOf: aSpaceShip [

	^ (inventories detect: [ :inventory | 
		   inventory spaceShip = aSpaceShip ]) cards
]

{ #category : #private }
CardApplicator >> distribute: aCard toTheInventoryOf: aSpaceShip [

	| inventory newInventory |
	inventory := inventories detect: [ :inven | 
		             inven spaceShip = aSpaceShip ].
	newInventory := cardDealer hand: aCard to: inventory.
	inventories replaceAll: inventory with: newInventory
]

{ #category : #private }
CardApplicator >> distributeInitialCardsTo: spaceShipNames [

	inventories := spaceShipNames collect: [ :spaceShip | 
		               SpaceShipCardInventory carriedBy: spaceShip ].

	inventories := cardDealer inventoriesAfterDrawingTwoFrom: inventories
]

{ #category : #private }
CardApplicator >> doubleEffectOf: aCard from: inventory in: aGame [

	inventory activeCards do: [ :card | 
		card = aCard ifTrue: [ 
			aCard
				activatedTo: inventory spaceShip
				poweredBy: engineApplicator
				on: self
				from: aGame ] ]
]

{ #category : #accessing }
CardApplicator >> enginePowerOf: aSpaceShip [ 

	^engineApplicator powerOf: aSpaceShip 
]

{ #category : #private }
CardApplicator >> handleCancellationOf: aCancellation to: cardTarget [

	self assertThereAreActiveCardsInPlay.
	self assertCardIsActive: cardTarget.
	self handleInstantaneousOf: aCancellation.
	cardDealer putAway: cardTarget.
	cardDealer putAway: aCancellation
]

{ #category : #private }
CardApplicator >> handleInstantaneousOf: aCard [

	self makeLastPlayed: aCard
]

{ #category : #private }
CardApplicator >> handlePermanentPlayOf: aCard from: cardPlayer on: aGame [

	aGame assertPermanentPlayedOnCorrectlyBy: cardPlayer.
	self makeLastPlayed: aCard
]

{ #category : #private }
CardApplicator >> handleRedoFrom: cardPlayer of: aCard in: aGame [

	aGame assertPermanentPlayedOnCorrectlyBy: cardPlayer.
	cardDealer putAway: aCard
]

{ #category : #initialization }
CardApplicator >> initializeHanding: someCards to: spaceShips [

	cardDealer := CardDealer handing: someCards.
	self distributeInitialCardsTo: spaceShips.
	globalInventory := OrderedCollection new.
	engineApplicator := EnginePowerApplicator with: spaceShips.
	

]

{ #category : #accessing }
CardApplicator >> inventoriesAfter: cardTarget wasApplied: aCard [

	| inventoryOfCardTarget |
	inventoryOfCardTarget := inventories detect: [ :inventory | 
		                         inventory spaceShip == cardTarget ].
	inventoryOfCardTarget addCardToActiveCards: aCard.
	^ inventories
]

{ #category : #private }
CardApplicator >> inventoriesAfterAdding: aCard from: someInventories [

	| newInventories |
	newInventories := someInventories do: [ :inventory | 
		                  inventory activeCards do: [ :card | 
			                  card == aCard ifTrue: [ 
				                  inventory addCardToActiveCards: aCard ] ] ].
	^ newInventories
]

{ #category : #accessing }
CardApplicator >> inventoriesAfterNewGlobalCardOf: anAccelerationCard [

	globalInventory add: anAccelerationCard.
	^ inventories
]

{ #category : #private }
CardApplicator >> inventoriesAfterRemoving: aCard from: someInventories [

	| newInventories |
	newInventories := someInventories do: [ :inventory | 
		                  inventory activeCards removeAllSuchThat: [ :card | 
			                  card = aCard ] ].
	^ newInventories
]

{ #category : #accessing }
CardApplicator >> lastCardPlayed [

	^ lastCardPlayed
]

{ #category : #private }
CardApplicator >> makeLastPlayed: aCard [

	lastCardPlayed := aCard
]

{ #category : #private }
CardApplicator >> remove: aCard from: cardPlayer [

	| inventoryOfCardPlayer |
	inventoryOfCardPlayer := inventories detect: [ :inventory | 
		                         inventory spaceShip == cardPlayer ].
	inventoryOfCardPlayer remove: aCard
]

{ #category : #private }
CardApplicator >> spaceShip: cardPlayer plays: aCard on: cardTarget from: aGame [

	self assertSpaceShip: cardPlayer owns: aCard.
	aCard playOf: cardPlayer at: cardTarget on: self from: aGame.

	self remove: aCard from: cardPlayer.

	engineApplicator applyEnginePowerTo: cardTarget afterPlaying: aCard	on: self from: aGame.
	inventories := aCard inventoriesAfterTargeting: cardTarget from: inventories on: self
]
