Class {
	#name : #Deck,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Deck >> ofOneHundredRandomCards [

| source cancellationCard accelerationCard overloadCard speedCard redoCard repeatCard probabilityEvents discreteProbabilityDistribution |
    cancellationCard := CancellationCard new.
    accelerationCard := AccelerationCard new.
    overloadCard := OverloadCard new.
    speedCard := SpeedCard new.
    redoCard := RedoCard new.
    repeatCard := RepeatCard new.


    probabilityEvents := { 
                             (ProbabilityEvent
                                  of: cancellationCard
                                  with: 1 / 6).
                             (ProbabilityEvent
                                  of: accelerationCard
                                  with: 1 / 6).
                             (ProbabilityEvent of: overloadCard with: 1 / 6).
                             (ProbabilityEvent of: speedCard with: 1 / 6).
                             (ProbabilityEvent of: redoCard with: 1 / 6).
                             (ProbabilityEvent of: repeatCard with: 1 / 6) }.

    discreteProbabilityDistribution := DiscreteProbabilityDistribution 
                                           withAll: probabilityEvents.
    source := DiscreteProbabilityEventSource with:
                  discreteProbabilityDistribution.

	^ source next: 100
]
