json.data do
  json.lecture do
    json.call(
      @lecture,
      :name,
      :duration
    )
  end
end