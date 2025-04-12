def expect_public_fields(resource, response, fields)
  fields.each do |attr|
    expect(response[attr]).to eq resource.send(attr).as_json
  end
end
