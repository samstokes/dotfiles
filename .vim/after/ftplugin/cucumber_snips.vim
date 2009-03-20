if !exists('loaded_snips') || exists('b:did_cucumber_snips')
	fini
en
let b:did_cucumber_snips = 1

exe "Snipp Fea Feature: ${1}\n  In order to ${2:GOAL}\n  ${3:ROLE}\n  ${4:ACTION}"
exe "Snipp Sce Scenario: ${1}\n  Given ${4}\n  When ${3}\n  Then ${2}"
