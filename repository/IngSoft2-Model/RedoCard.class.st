Class {
	#name : #RedoCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
RedoCard >> activatedTo: aSpaceShip on: anEnginePowerApplicator from: aBoard [

	anEnginePowerApplicator
		applyEnginePowerTo: aSpaceShip
		afterPlaying: aBoard lastCardPlayed
		on: aBoard
]

{ #category : #asserting }
RedoCard >> assertValidCardPlayOf: cardPlayer at: cardTarget on: aBoard from: aGame [

	aBoard assertSpaceShip: cardPlayer owns: self
]

{ #category : #'as yet unclassified' }
RedoCard >> inventoriesAfterTargeting: target from: inventories on: aBoard [

	^ aBoard lastCardPlayed
		  inventoriesAfterTargeting: target
		  from: inventories
		  on: aBoard
]