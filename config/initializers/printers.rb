configuration_file = YAML.load(File.open(File.expand_path("../../printers.yml", __FILE__)))
buildings = configuration_file.inject(Set.new) {|memo, obj| memo << obj[1][:location] }
buildings.delete_if { |b| SPLIT_LOCATIONS.has_key?(b) }

printers = buildings.inject({}) { |memo, obj| memo.merge(obj => []) }
SPLIT_LOCATIONS.values.map(&:keys).flatten.each { |split_location| printers[split_location] = [] }

configuration_file.each do |k, v|
  l = v[:location]
  if split = SPLIT_LOCATIONS[l]
    split.each_pair do |k2, v2|
      if k[v2]
        printers[k2] << k
        break
      end
    end
  else
    printers[l] << k
  end
end

$printers = printers
$buildings = printers.keys