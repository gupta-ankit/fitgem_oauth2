FactoryGirl.define do

  factory :client, :class => FitgemOauth2::Client do
    client_id '22942C'
    client_secret 'secret'
    token 'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzAzNDM3MzUsInNjb3BlcyI6Indwcm8gd2xvYyB3bnV0IHdzbGUgd3NldCB3aHIgd3dlaSB3YWN0IHdzb2MiLCJzdWIiOiJBQkNERUYiLCJhdWQiOiJJSktMTU4iLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJpYXQiOjE0MzAzNDAxMzV9.z0VHrIEzjsBnjiNMBey6wtu26yHTnSWz_qlqoEpUlpc'
    user_id '26FWFL'

    initialize_with { new(client_id: client_id, client_secret: client_secret, token: token, user_id: user_id) }
  end

end