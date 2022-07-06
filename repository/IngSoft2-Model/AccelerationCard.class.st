Class {
	#name : #AccelerationCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #private }
AccelerationCard >> activatedTo: aSpaceShip poweredBy: anEnginePowerApplicator on: aCardApplicator from: aMessirveSpaceRaceGame [

	anEnginePowerApplicator accelerateAllEngines
]

{ #category : #private }
AccelerationCard >> applyNegatedOn: anAccelerationCard on: anEnginePowerApplicator from: aRoundBoard [

	anEnginePowerApplicator slowDownAllEngines
]

{ #category : #asserting }
AccelerationCard >> handleLastPlayedWithPlayOf: cardPlayer at: cardTarget on: aCardApplicator from: aGame [

	aCardApplicator
		handlePermanentPlayOf: self
		from: cardPlayer
		on: aGame
]

{ #category : #private }
AccelerationCard >> inventoriesAfterTargeting: target from: inventories on: cardApplicator [

	^ cardApplicator inventoriesAfterNewGlobalCardOf: self
]
