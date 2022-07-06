Class {
	#name : #RedoCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #private }
RedoCard >> activatedTo: aCard poweredBy: anEnginePowerApplicator on: aCardApplicator from: aGame [

	anEnginePowerApplicator
		applyEnginePowerTo: aCard
		afterPlaying: aCardApplicator lastCardPlayed
		on: aCardApplicator
		from: aGame
]

{ #category : #asserting }
RedoCard >> handleLastPlayedWithPlayOf: cardPlayer at: cardTarget on: aCardApplicator from: aGame [

	aCardApplicator handleRedoFrom: cardPlayer in: aGame
]

{ #category : #private }
RedoCard >> inventoriesAfterTargeting: target from: inventories on: aBoard [

	^ aBoard lastCardPlayed
		  inventoriesAfterTargeting: target
		  from: inventories
		  on: aBoard
]
