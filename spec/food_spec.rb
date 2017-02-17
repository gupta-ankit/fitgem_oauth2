require 'rspec'

describe FitgemOauth2::Client do
  let(:client) { FactoryGirl.build(:client) }
  let(:user_id) { client.user_id }

  describe '#food_goals' do
    it 'gets food goal' do
      response = random_sequence
      url = "user/#{user_id}/foods/log/goal.json"
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.food_goals).to eql(response)
    end
  end

  describe '#food_logs' do
    it 'gets food on date' do
      response = random_sequence
      url = "user/#{user_id}/foods/log/date/#{client.format_date(Date.today)}.json"
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.food_logs(Date.today)).to eql(response)
    end
  end

  describe '#water_logs' do
    it 'gets water on date' do
      response = random_sequence
      url = "user/#{user_id}/foods/log/water/date/#{client.format_date(Date.today)}.json"
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.water_logs(Date.today)).to eql(response)
    end
  end

  describe '#water_goal' do
    it 'gets water goal' do
      response = random_sequence
      url = "user/#{user_id}/foods/log/water/goal.json"
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.water_goal).to eql(response)
    end
  end

  describe '#food_series' do
    before(:each) do
      @valid_period = '1d'
      @invalid_period = '1day'
      @valid_resource = 'caloriesIn'
      @invalid_resource = 'cakes'
    end

    it 'gets series in period' do
      url = "user/#{user_id}/foods/log/#{@valid_resource}/date/#{client.format_date(Date.today - 1)}/#{@valid_period}.json"
      opts = {resource: 'caloriesIn', start_date: Date.today - 1, period: '1d'}
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.food_series(opts)).to eql(response)
    end

    it 'gets series in range' do
      url = "user/#{user_id}/foods/log/#{@valid_resource}/date/#{client.format_date(Date.today - 1)}/#{client.format_date(Date.today)}.json"
      opts = {resource: 'caloriesIn', start_date: Date.today - 1, end_date: Date.today}
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.food_series(opts)).to eql(response)
    end

    it 'raises error if resource is invalid' do
      opts = {resource: 'cakes', start_date: Date.today - 1, end_date: Date.today}
      expect { client.food_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, "Invalid resource: #{opts[:resource]}. Specify a valid resource from #{FitgemOauth2::Client::FOOD_SERIES_RESOURCES}")
    end

    it 'raises error if period is invalid' do
      opts = {resource: 'caloriesIn', start_date: Date.today - 1, period: '1year'}
      expect { client.food_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, "Invalid period: #{opts[:period]}. Specify a valid period from #{FitgemOauth2::Client::FOOD_SERIES_PERIODS}")
    end
  end

  describe '#log_food' do
    it 'logs food' do
      url = "user/#{user_id}/foods/log.json"
      response = random_sequence
      params = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.log_food(params)).to eql(response)
    end
  end

  describe 'update_food_log' do
    it 'edits food log' do
      response = random_sequence
      params = random_sequence
      id = random_sequence
      url = "user/#{user_id}/foods/log/#{id}.json"
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.update_food_log(id, params)).to eql(response)
    end
  end

  describe '#log_water' do
    it 'logs water' do
      url = "user/#{user_id}/foods/log/water.json"
      response = random_sequence
      params = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.log_water(params)).to eql(response)
    end
  end

  describe '#update_food_goal' do
    it 'updates food goal' do
      url = "user/#{user_id}/foods/log/goal.json"
      response = random_sequence
      params = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.update_food_goal(params)).to eql(response)
    end
  end

  describe '#update_water_goal' do
    it 'updates water goal' do
      url = "user/#{user_id}/foods/log/water/goal.json"
      response = random_sequence
      params = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.update_water_goal(params)).to eql(response)
    end
  end

  describe '#delete_food_log' do
    it 'deletes food log' do
      id = random_sequence
      url = "user/#{user_id}/foods/log/#{id}.json"
      response = random_sequence
      expect(client).to receive(:delete_call).with(url).and_return(response)
      expect(client.delete_food_log(id)).to eql(response)
    end
  end

  describe 'update_water_log' do
    it 'updates water log' do
      response = random_sequence
      params = random_sequence
      id = random_sequence
      url = "user/#{user_id}/foods/log/water/#{id}.json"
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.update_water_log(id, params)).to eql(response)
    end
  end

  describe '#delete_water_log' do
    it 'deletes water log' do
      id = random_sequence
      url = "user/#{user_id}/foods/log/water/#{id}.json"
      response = random_sequence
      expect(client).to receive(:delete_call).with(url).and_return(response)
      expect(client.delete_water_log(id)).to eql(response)
    end
  end

  describe '#favorite_foods' do
    it 'gets favorite foods' do
      url = "user/#{user_id}/foods/log/favorite.json"
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.favorite_foods).to eql(response)
    end
  end

  describe '#get_frequent_foods' do
    it 'gets frequent foods' do
      url = "user/#{user_id}/foods/log/frequent.json"
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.frequent_foods).to eql(response)
    end
  end

  describe '#get_recent_foods' do
    it 'gets recent foods' do
      url = "user/#{user_id}/foods/recent.json"
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.recent_foods).to eql(response)
    end
  end


  describe '#add_favorite_food' do
    it 'adds favorite food' do
      response = random_sequence
      id = random_sequence
      url = "user/#{user_id}/foods/log/favorite/#{id}.json"
      expect(client).to receive(:post_call).with(url).and_return(response)
      expect(client.add_favorite_food(id)).to eql(response)
    end
  end

  describe '#delete_favorite_food' do
    it 'deletes favorite food' do
      response = random_sequence
      id = random_sequence
      url = "user/#{user_id}/foods/log/favorite/#{id}.json"
      expect(client).to receive(:delete_call).with(url).and_return(response)
      expect(client.delete_favorite_food(id)).to eql(response)
    end
  end


  describe '#meals' do
    it 'gets meals' do
      url = "user/#{user_id}/meals.json"
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.meals).to eql(response)
    end
  end


  describe '#create_meal' do
    it 'creates meal' do
      response =random_sequence
      params = random_sequence
      url = "user/#{user_id}/meals.json"
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.create_meal(params)).to eql(response)
    end
  end

  describe '#meal' do
    it 'gets a meal' do
      meal_id = random_sequence
      url = "user/#{user_id}/meals/#{meal_id}.json"
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.meal(meal_id)).to eql(response)
    end
  end

  describe '#update_meal' do
    it 'edits a meal' do
      response = random_sequence
      params = random_sequence
      id = random_sequence
      url = "user/#{user_id}/meals/#{id}.json"
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.update_meal(id, params)).to eql(response)
    end
  end

  describe '#delete_meal' do
    it 'deletes a meal' do
      response = random_sequence
      id = random_sequence
      url = "user/#{user_id}/meals/#{id}.json"
      expect(client).to receive(:delete_call).with(url).and_return(response)
      expect(client.delete_meal(id)).to eql(response)
    end
  end

  describe '#create_food' do
    it 'creates a food' do
      url = "user/#{user_id}/foods.json"
      response = random_sequence
      params = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.create_food(params)).to eql(response)
    end
  end

  describe '#delete_food' do
    it 'deletes custom food' do
      food_id = random_sequence
      url = "user/#{user_id}/foods/#{food_id}.json"
      response = random_sequence
      expect(client).to receive(:delete_call).with(url).and_return(response)
      expect(client.delete_food(food_id)).to eql(response)
    end
  end

  describe '#food' do
    it 'gets food' do
      food_id = random_sequence
      response = random_sequence
      url = "foods/#{food_id}.json"
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.food(food_id)).to eql(response)
    end
  end

  describe '#food_units' do
    it 'gets food units' do
      url = 'foods/units.json'
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.food_units).to eql(response)
    end
  end

  describe '#search_foods' do
    it 'searches food' do
      url = 'foods/search.json'
      params = random_sequence
      response = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.search_foods(params)).to eql(response)
    end
  end
end
