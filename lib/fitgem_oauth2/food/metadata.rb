# frozen_string_literal: true

module FitgemOauth2
  class Client
    def add_favorite_food(food_id)
      post_call("user/#{user_id}/foods/log/favorite/#{food_id}.json")
    end

    def delete_favorite_food(food_id)
      delete_call("user/#{user_id}/foods/log/favorite/#{food_id}.json")
    end

    def recent_foods
      get_call("user/#{user_id}/foods/recent.json")
    end

    def favorite_foods
      get_call("user/#{user_id}/foods/log/favorite.json")
    end

    def frequent_foods
      get_call("user/#{user_id}/foods/log/frequent.json")
    end

    def meals
      get_call("user/#{user_id}/meals.json")
    end

    def create_meal(params)
      post_call("user/#{user_id}/meals.json", params)
    end

    def meal(meal_id)
      get_call("user/#{user_id}/meals/#{meal_id}.json")
    end

    def update_meal(meal_id, params)
      post_call("user/#{user_id}/meals/#{meal_id}.json", params)
    end

    def delete_meal(meal_id)
      delete_call("user/#{user_id}/meals/#{meal_id}.json")
    end

    def create_food(params)
      post_call("user/#{user_id}/foods.json", params)
    end

    def delete_food(food_id)
      delete_call("user/#{user_id}/foods/#{food_id}.json")
    end

    def food(id)
      get_call("foods/#{id}.json")
    end

    def food_units
      get_call('foods/units.json')
    end

    def search_foods(params)
      post_call('foods/search.json', params)
    end
  end
end
