Class {
	#name : #BoardEffect,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #private }
BoardEffect >> applyOn: statuses activatedBy: aStatus playedOn: aBoard and: aGame appliedBy: effectApplicator [

	self subclassResponsibility 
]
