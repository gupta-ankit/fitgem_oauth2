require 'rspec'

describe FitgemOauth2::Client do
  let(:client) { FactoryGirl.build(:client) }
  let(:user_id) { client.user_id }

  describe '#friends' do
    it 'gets all friends' do
      url = "user/#{user_id}/friends.json"
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.friends).to eql(response)
    end
  end

  describe '#friends_leaderboard' do
    it 'gets friend leaderboard' do
      url = "user/#{user_id}/friends/leaderboard.json"
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.friends_leaderboard).to eql(response)
    end
  end

  describe '#invite_friend' do
    it 'invites friend' do
      url = "user/#{user_id}/friends/invitations.json"
      params = random_sequence
      response = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.invite_friend(params)).to eql(response)
    end
  end

  describe '#friend_invitations' do
    it 'gets friend invitations' do
      url = "user/#{user_id}/friends/invitations.json"
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.friend_invitations).to eql(response)
    end
  end

  describe '#respond_to_friend_invitation' do
    it 'responds to friend invitation' do
      from_user_id = random_sequence
      url = "user/#{user_id}/friends/invitations/#{from_user_id}.json"
      params = random_sequence
      response = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.respond_to_invitation(from_user_id,   params)).to eql(response)
    end
  end

  describe '#badges' do
    it 'gets badges' do
      url = "user/#{user_id}/badges.json"
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.badges).to eql(response)
    end
  end
end
