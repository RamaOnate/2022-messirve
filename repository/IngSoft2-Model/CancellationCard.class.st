Class {
	#name : #CancellationCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #private }
CancellationCard >> activatedTo: aCard poweredBy: anEnginePowerApplicator on: aCardApplicator from: aMessirveSpaceRaceGame [

	anEnginePowerApplicator
		applyCancellationTargetting: aCard
		in: aCardApplicator
]

{ #category : #private }
CancellationCard >> inventoriesAfterTargeting: cardTarget from: inventories on: aCardApplicator [

	^ aCardApplicator
		  inventoriesAfterRemoving: cardTarget
		  from: inventories
]

{ #category : #private }
CancellationCard >> playOf: cardPlayer at: cardTarget on: aCardApplicator from: aGame [

	aCardApplicator handleCancellationOf: self to: cardTarget
]
