Class {
	#name : #LimitedDeckTests,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
LimitedDeckTests >> testACancellationCardUsedOnASpeedCardGoesToTheDiscardDeck [

	| aSpaceGame aLoadedDie aBoard speedCard cancellationCard limitedDeck |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	cancellationCard := CancellationCard new.
	limitedDeck := DeckHolder formedBy: { 
			               speedCard.
			               cancellationCard.
			               speedCard }.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: limitedDeck.

	self assert: limitedDeck cards equals: { speedCard } asOrderedCollection 
]
