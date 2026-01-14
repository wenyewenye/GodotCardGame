extends Node

# 复制文件函数
# @param src_path: 源文件路径
# @param dst_path: 目标文件路径
# @param overwrite: 是否覆盖已存在文件
# @param progress_callback: 可选进度回调函数 (current_bytes, total_bytes)
# @return: 返回字典 { "success": bool, "error": String }
func copy_file(src_path: String, dst_path: String, overwrite: bool = false, progress_callback: Callable = Callable()) -> Dictionary:
	var result := { "success": false, "error": "" }
	
	# 验证源文件
	if not FileAccess.file_exists(src_path):
		result.error = "源文件不存在: " + src_path
		return result
	
	# 检查目标文件是否已存在
	if FileAccess.file_exists(dst_path) and not overwrite:
		result.error = "目标文件已存在且不允许覆盖: " + dst_path
		return result
	
	# 打开源文件
	var src_file := FileAccess.open(src_path, FileAccess.READ)
	if src_file == null:
		result.error = "无法打开源文件: %s (错误: %s)" % [src_path, FileAccess.get_open_error()]
		return result
	
	# 创建目标目录（如果需要）
	var dir := DirAccess.open(dst_path.get_base_dir())
	if dir == null:
		result.error = "无法创建目标目录: %s" % dst_path.get_base_dir()
		src_file.close()
		return result
	
	# 打开目标文件
	var dst_file := FileAccess.open(dst_path, FileAccess.WRITE)
	if dst_file == null:
		result.error = "无法创建目标文件: %s (错误: %s)" % [dst_path, FileAccess.get_open_error()]
		src_file.close()
		return result
	
	# 获取文件总大小（用于进度回调）
	var file_size := src_file.get_length()
	var bytes_copied := 0
	var buffer_size := 65536  # 64KB 缓冲区
	
	# 开始复制
	while not src_file.eof_reached():
		var chunk := src_file.get_buffer(buffer_size)
		dst_file.store_buffer(chunk)
		
		bytes_copied += chunk.size()
		
		# 调用进度回调
		if progress_callback.is_valid():
			progress_callback.call(bytes_copied, file_size)
	
	# 关闭文件
	src_file.close()
	dst_file.close()
	
	result.success = true
	return result

# 删除单个文件
# @param path: 文件路径 (可以是 "res://", "user://" 或绝对路径)
# @return: 返回字典 { "success": bool, "error": String }
func delete_file(path: String) -> Dictionary:
	var result := { "success": false, "error": "" }
	
	# 检查文件是否存在
	if not FileAccess.file_exists(path):
		result.error = "文件不存在: " + path
		return result
	
	# 使用 DirAccess 删除文件
	var dir := DirAccess.open(path.get_base_dir())
	if dir == null:
		result.error = "无法访问目录: " + path.get_base_dir()
		return result
	
	# 执行删除
	var error := dir.remove(path)
	if error != OK:
		result.error = "删除失败 (错误代码: %d)" % error
		return result
	
	result.success = true
	return result
