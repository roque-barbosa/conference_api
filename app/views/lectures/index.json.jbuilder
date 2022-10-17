json.data do
  json.array! @lectures do |lecture|
    json.lecture do
      json.call(
        lecture,
        :id,
        :name,
        :duration
      )
    end
  end
end