Class {
	#name : #SpeedBoostCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #private }
SpeedBoostCard >> activatedTo: aCard poweredBy: anEnginePowerApplicator on: aCardApplicator from: aGame [ 

	anEnginePowerApplicator applySpeedBoostTargetting: aCard in: aCardApplicator from: aGame
]

{ #category : #private }
SpeedBoostCard >> inventoriesAfterTargeting: aTarget from: inventories on: aCardApplicator [

	^ aCardApplicator inventoriesAfterAdding: aTarget from: inventories
]

{ #category : #asserting }
SpeedBoostCard >> playOf: aString at: aSpeedCard on: aCardApplicator from: aMessirveSpaceRaceGame [

	aCardApplicator handleInstantaneousOf: self
]
