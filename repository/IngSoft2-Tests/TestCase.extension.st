Extension { #name : #TestCase }

{ #category : #'*IngSoft2-Tests' }
TestCase >> assert: spaceshipName isAt: aPosition with: aLap in: aMessirveSpaceRaceGame [

	self
		assert: (aMessirveSpaceRaceGame positionOfSpaceship: spaceshipName)
		equals: aPosition.
	self
		assert: (aMessirveSpaceRaceGame lapsOfSpaceship: spaceshipName)
		equals: aLap
]
