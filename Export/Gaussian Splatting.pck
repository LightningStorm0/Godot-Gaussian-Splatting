GDPC                                                                                          \   res://.godot/exported/133200997/export-30b3c08a3d6e14e08ee6a26d4f904f03-PlainUnshaded.res   �&      �      �&��!��x�Q��e    P   res://.godot/exported/133200997/export-bcb0d2eb5949c52b6a65bfe9de3e985b-Main.scn       �      ��jC8(��,ƪ�4�\    ,   res://.godot/global_script_class_cache.cfg  P.             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex`
      �      �̛�*$q�*�́        res://.godot/uid_cache.bin  02      ]       �&����L��#�       res://CameraRotator.gd          >       '�f��[V��[���U�       res://GaussianLoader.gd @       
      ~�� Tn2"ӏ_�2�       res://Main.tscn.remap   p-      a       3 J�M�B�b��}�        res://PlainUnshaded.tres.remap  �-      j       ��)wd�����*��       res://icon.svg  p.      �      C��=U���^Qu��U3       res://icon.svg.import   @      �       �у x�=�^��+�=�       res://project.binary�2      �      ж;�_�i��d}V�    extends Marker3D

func _process(delta):
	self.rotate_y(delta)
  extends Node3D

var splatPointCount : int = 0
var splatProperties : Array[String] = []
var splatPoints : Array = []

var splatAsFile : FileAccess
func _ready():
	splatAsFile = FileAccess.open("res://My_GS_Model/point_cloud/splat.ply", FileAccess.READ)
	
	var splatLine = splatAsFile.get_line()
	while splatLine != "end_header":
		splatLine = splatAsFile.get_line()
		print(splatLine)
		
		if splatLine.begins_with("element vertex "):
			splatPointCount = int(splatLine.replace("element vertex ", ""))
		
		if splatLine.begins_with("property float "):
			splatProperties.append(splatLine.replace("property float ", ""))
	
	addAllPoints()
	
	print(splatPoints[0])
	
	createMultiMesh()

func addAllPoints():
	var count : int = 0
	
	while count < splatPointCount:
		var newSplat : Array[float] = []
		for property in splatProperties:
			newSplat.append(splatAsFile.get_float())
		splatPoints.append(newSplat)
		
		count += 1
		if count % 10000 == 0:
			print(count)

func createMultiMesh():
	var splatMultiMesh : MultiMesh = $MultiMeshInstance3D.multimesh
	splatMultiMesh.instance_count = splatPointCount
	
	var xPos : int = splatProperties.find("x")
	var yPos : int = splatProperties.find("y")
	var zPos : int = splatProperties.find("z")
	
	var xScale : int = splatProperties.find("scale_0")
	var yScale : int = splatProperties.find("scale_1")
	var zScale : int = splatProperties.find("scale_2")
	
	var rot0 : int = splatProperties.find("rot_0")
	var rot1 : int = splatProperties.find("rot_1")
	var rot2 : int = splatProperties.find("rot_2")
	var rot3 : int = splatProperties.find("rot_3")
	
	var r : int = splatProperties.find("f_dc_0")
	var g : int = splatProperties.find("f_dc_1")
	var b : int = splatProperties.find("f_dc_2")
	
	var opacity : int = splatProperties.find("opacity")
	
	for meshInstance in range(splatMultiMesh.instance_count):
		var splatPoint = splatPoints[meshInstance]
		var splatPointTransform = Transform3D()
		
		splatPointTransform.origin = Vector3(
			splatPoint[xPos] * 5,
			splatPoint[yPos] * 5,
			splatPoint[zPos] * 5
		)
		
		splatPointTransform.scaled_local(Vector3(
			splatPoint[xScale],
			splatPoint[yScale],
			splatPoint[zScale]
		))
		
		splatPointTransform = splatPointTransform.rotated_local(
			Vector3(
				splatPoint[rot1],
				splatPoint[rot2],
				splatPoint[rot3]
			).normalized(),
			splatPoint[rot0]
		)
		
		splatMultiMesh.set_instance_transform(meshInstance, splatPointTransform)
		
		splatMultiMesh.set_instance_color(meshInstance, 
			Color(
				splatPoint[r], 
				splatPoint[g], 
				splatPoint[b],
				splatPoint[opacity]
			)
		)
     GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://firrtec2qowm"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 RSRC                    PackedScene            ��������                                            t      resource_local_to_scene    resource_name    background_mode    background_color    background_energy_multiplier    background_intensity    background_canvas_max_layer    background_camera_feed_id    sky    sky_custom_fov    sky_rotation    ambient_light_source    ambient_light_color    ambient_light_sky_contribution    ambient_light_energy    reflected_light_source    tonemap_mode    tonemap_exposure    tonemap_white    ssr_enabled    ssr_max_steps    ssr_fade_in    ssr_fade_out    ssr_depth_tolerance    ssao_enabled    ssao_radius    ssao_intensity    ssao_power    ssao_detail    ssao_horizon    ssao_sharpness    ssao_light_affect    ssao_ao_channel_affect    ssil_enabled    ssil_radius    ssil_intensity    ssil_sharpness    ssil_normal_rejection    sdfgi_enabled    sdfgi_use_occlusion    sdfgi_read_sky_light    sdfgi_bounce_feedback    sdfgi_cascades    sdfgi_min_cell_size    sdfgi_cascade0_distance    sdfgi_max_distance    sdfgi_y_scale    sdfgi_energy    sdfgi_normal_bias    sdfgi_probe_bias    glow_enabled    glow_levels/1    glow_levels/2    glow_levels/3    glow_levels/4    glow_levels/5    glow_levels/6    glow_levels/7    glow_normalized    glow_intensity    glow_strength 	   glow_mix    glow_bloom    glow_blend_mode    glow_hdr_threshold    glow_hdr_scale    glow_hdr_luminance_cap    glow_map_strength 	   glow_map    fog_enabled    fog_light_color    fog_light_energy    fog_sun_scatter    fog_density    fog_aerial_perspective    fog_sky_affect    fog_height    fog_height_density    volumetric_fog_enabled    volumetric_fog_density    volumetric_fog_albedo    volumetric_fog_emission    volumetric_fog_emission_energy    volumetric_fog_gi_inject    volumetric_fog_anisotropy    volumetric_fog_length    volumetric_fog_detail_spread    volumetric_fog_ambient_inject    volumetric_fog_sky_affect -   volumetric_fog_temporal_reprojection_enabled ,   volumetric_fog_temporal_reprojection_amount    adjustment_enabled    adjustment_brightness    adjustment_contrast    adjustment_saturation    adjustment_color_correction    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    size    subdivide_width    subdivide_depth    center_offset    orientation    transform_format    use_colors    use_custom_data    instance_count    visible_instance_count    mesh    buffer 	   _bundled       Script    res://GaussianLoader.gd ��������	   Material    res://PlainUnshaded.tres �<+uds�f   Script    res://CameraRotator.gd ��������      local://Environment_etv8q <         local://QuadMesh_ea5ei X         local://MultiMesh_dwfgj �         local://PackedScene_uc4vn �         Environment    `      	   QuadMesh    b            g   
   ���=���=`      
   MultiMesh    l         m         q            `         PackedScene    s      	         names "   	      Node3D    script    WorldEnvironment    environment    MultiMeshInstance3D 
   transform 
   multimesh 	   Marker3D 	   Camera3D    	   variants                                �?            1�;�  �?      ��1�;�                                   �?            г]?   ?       �г]?       A  �A      node_count             nodes     /   ��������        ����                            ����                           ����                                 ����                          ����                   conn_count              conns               node_paths              editable_instances              version       `      RSRC             RSRC                    StandardMaterial3D            ��������                                            B      resource_local_to_scene    resource_name    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script        !   local://StandardMaterial3D_mmqye          StandardMaterial3D                      	                                              A      RSRC          [remap]

path="res://.godot/exported/133200997/export-bcb0d2eb5949c52b6a65bfe9de3e985b-Main.scn"
               [remap]

path="res://.godot/exported/133200997/export-30b3c08a3d6e14e08ee6a26d4f904f03-PlainUnshaded.res"
      list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
              ��ӆA   res://icon.svgR.�B�"�+   res://Main.tscn�<+uds�f   res://PlainUnshaded.tres   ECFG      application/config/name         Gaussian Splatting     application/run/main_scene         res://Main.tscn    application/config/features(   "         4.1    GL Compatibility       application/config/icon         res://icon.svg  #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility    