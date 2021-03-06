require 'rails_helper'

RSpec.describe Comment, type: :model do

  it { should belong_to(:user) }
  it { should have_many(:comments) }
  it { should belong_to(:commentable) }
  it { should have_many(:likes).dependent(:destroy) }

end