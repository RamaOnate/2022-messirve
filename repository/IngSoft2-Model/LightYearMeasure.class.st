Class {
	#name : #LightYearMeasure,
	#superclass : #Object,
	#instVars : [
		'lightYears'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #asserting }
LightYearMeasure class >> assertValid: someLightYears [
 
	someLightYears > 0 ifFalse: [ Error signal: 'Light years must be greater than zero' ]
]

{ #category : #'instance creation' }
LightYearMeasure class >> of: someLightYears [

	self assertValid: someLightYears.
	^ self new initializeOf: someLightYears
]

{ #category : #initialization }
LightYearMeasure >> initializeOf: someLightYears [

	lightYears := someLightYears
]

{ #category : #accessing }
LightYearMeasure >> totalParsecs [

	^ lightYears / 3
]
