require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'validates the presence of title' do
      task = Task.new(description: 'Some description')
      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("can't be blank")
    end
  end

  # Add more test cases for other model behaviors, associations, etc.
end
