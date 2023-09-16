class_name CharacterSelectPointer
extends Node2D

var target : CharacterSelectIcon:
	set(val):
		position = val.position
		target = val
	get:
		return target 

var index := 0
