Class {
	#name : #AtomicBombEffect,
	#superclass : #BoardEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #private }
AtomicBombEffect >> applyOn: statuses activatedBy: aStatus playedOn: aBoard and: aGame appliedBy: effectApplicator [

	^ effectApplicator applyAtomicBombOn: statuses playedOn: aBoard
]
