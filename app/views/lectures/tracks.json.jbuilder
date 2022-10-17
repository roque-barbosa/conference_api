json.data do
  json.array! @tracks do |track|
    json.track do
      json.array! track do |lecture|
        json.name lecture["name"]
        json.duration lecture["duration"]
      end
    end
  end
end
