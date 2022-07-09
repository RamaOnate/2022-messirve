Class {
	#name : #OverloadCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #private }
OverloadCard >> activatedTo: aSpaceShip poweredBy: anEnginePowerApplicator on: aCardApplicator from: aMessirveSpaceRaceGame [

	anEnginePowerApplicator powerEngineOf: aSpaceShip by: -2
]

{ #category : #private }
OverloadCard >> applyNegatedOn: aSpaceShip on: anEnginePowerApplicator from: aRoundBoard [

	anEnginePowerApplicator powerEngineOf: aSpaceShip by: 2
]

{ #category : #private }
OverloadCard >> inventoriesAfterTargeting: cardTarget from: inventories on: aCardApplicator [

	^ aCardApplicator inventoriesAfter: cardTarget wasApplied: self
]

{ #category : #asserting }
OverloadCard >> playOf: cardPlayer at: cardTarget on: aCardApplicator from: aGame [

	aCardApplicator
		handlePermanentPlayOf: self
		from: cardPlayer
		on: aGame
]
