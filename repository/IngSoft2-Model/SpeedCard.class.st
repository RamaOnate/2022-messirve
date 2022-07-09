Class {
	#name : #SpeedCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #private }
SpeedCard >> activatedTo: aSpaceShip poweredBy: anEnginePowerApplicator on: aCardApplicator from: aMessirveSpaceRaceGame [ 

	anEnginePowerApplicator powerEngineOf: aSpaceShip by: 1
]

{ #category : #private }
SpeedCard >> applyNegatedOn: aSpaceShip on: anEnginePowerApplicator from: aRoundBoard [ 

	anEnginePowerApplicator powerEngineOf: aSpaceShip by: -1
]

{ #category : #private }
SpeedCard >> inventoriesAfterTargeting: cardTarget from: inventories on: aCardApplicator [

	^ aCardApplicator inventoriesAfter: cardTarget wasApplied: self
]

{ #category : #asserting }
SpeedCard >> playOf: cardPlayer at: cardTarget on: aCardApplicator from: aGame [

	aCardApplicator
		handlePermanentPlayOf: self
		from: cardPlayer
		on: aGame
]
