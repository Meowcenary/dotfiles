CASES = {'snake', 'camel', 'skewer'}

change_to_dir

files.each do |file_path|
  base_name = File.basename(file_path)
  if base_name != File.basename(__FILE__)
    rename_file(file_path, new_case)
  end
end

def args_valid?
  ARGV.first.is_a?(String) && CASES.include?(ARGV.last)
end

def change_to_dir
  directory_path = ARGV[0]
  Dir.chdir directory_path
  files = Dir["./*"]
end

def change_file_case file_path, new_case
  file_name = ''
  file_path_components = file_path.split(/[A-Z_]/).map do |file_path_component|
    # no char
    if file_path_component.empty?
      next
    # if separator char
    elsif file_path_component == '_' || file_path_component == '-'
      next
    # uppercase
    elsif file_path_component.match?(/[A-Z]/)
      file_name += file_path_component
    else
    end
  end

  File.rename(base_name, new_name)
end
