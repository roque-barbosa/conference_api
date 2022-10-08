json.data do
  json.array! @lectures do |lecture|
    json.lecture do
      json.call(
        lecture,
        :name,
        :duration
      )
    end
  end
end