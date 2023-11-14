@tool
extends Node3D

@export_global_file(".ply") var ply_file = "res://My_GS_Model/point_cloud/splat.ply"

@export var import_ply : bool = false : set = importSplatButton
func importSplatButton(value : bool):
	loadSplat(ply_file)

var splatPointCount : int = 0
var splatProperties : Array[String] = []
var splatPoints : Array = []

var splatAsFile : FileAccess

var splatMultiMesh : MultiMesh

var xPos : int
var yPos : int
var zPos : int

var xScale : int
var yScale : int
var zScale : int

var rot0 : int
var rot1 : int
var rot2 : int
var rot3 : int

var r : int
var g : int
var b : int

var opacity : int

func _ready():
	splatMultiMesh = $MultiMeshInstance3D.multimesh

func loadSplat(path : String):
	splatMultiMesh.instance_count = 0
	
	splatAsFile = FileAccess.open(path, FileAccess.READ)
	
	var splatLine = splatAsFile.get_line()
	while splatLine != "end_header":
		splatLine = splatAsFile.get_line()
		print(splatLine)
		
		if splatLine.begins_with("element vertex "):
			splatPointCount = int(splatLine.replace("element vertex ", ""))
		
		if splatLine.begins_with("property float "):
			splatProperties.append(splatLine.replace("property float ", ""))
		
	splatMultiMesh.instance_count = splatPointCount
	
	#addAllPoints()
	#createMultiMesh()
	
	xPos = splatProperties.find("x")
	yPos = splatProperties.find("y")
	zPos = splatProperties.find("z")
	
	xScale = splatProperties.find("scale_0")
	yScale = splatProperties.find("scale_1")
	zScale = splatProperties.find("scale_2")
	
	rot0 = splatProperties.find("rot_0")
	rot1 = splatProperties.find("rot_1")
	rot2 = splatProperties.find("rot_2")
	rot3 = splatProperties.find("rot_3")
	
	r = splatProperties.find("f_dc_0")
	g = splatProperties.find("f_dc_1")
	b = splatProperties.find("f_dc_2")
	
	opacity = splatProperties.find("opacity")
	
	var thread : Thread
	thread = Thread.new()
	thread.start(loadPointAndCreateMesh)

func loadPointAndCreateMesh():
	var count : int = 0
	splatMultiMesh.visible_instance_count = 0
	while count < splatPointCount:
		var newSplat : Array[float] = []
		for property in splatProperties:
			newSplat.append(splatAsFile.get_float())
		splatPoints.append(newSplat)
		
		var splatPoint = newSplat
		var splatPointTransform = Transform3D()
		
		splatPointTransform.origin = Vector3(
			splatPoint[xPos] * 5,
			splatPoint[yPos] * 5,
			splatPoint[zPos] * 5
		)
		
		splatPointTransform.basis = splatPointTransform.basis.scaled(
			Vector3(
				splatPoint[xScale],
				splatPoint[yScale],
				splatPoint[zScale]
			)
		)
		
		splatPointTransform.basis = splatPointTransform.basis.rotated(
			Vector3(
				splatPoint[rot0],
				splatPoint[rot1],
				splatPoint[rot2]
			).normalized(),
			splatPoint[rot3]
		)
		
		splatMultiMesh.set_instance_transform(count, splatPointTransform)
		
		splatMultiMesh.set_instance_color(count, 
			Color(
				clamp(splatPoint[r], 0.0, 1.0), 
				clamp(splatPoint[g], 0.0, 1.0), 
				clamp(splatPoint[b], 0.0, 1.0),
				clamp(splatPoint[opacity], 0.0, 1.0)
			)
		)
		
		splatMultiMesh.visible_instance_count += 1
		
		count += 1
		if count % 10000 == 0:
			print(str(round((float(count)/float(splatPointCount))*100)) + "%" + " (" + str(count) + "/" + str(splatPointCount) + ")")
	
	splatAsFile.close()
	print("finished")
