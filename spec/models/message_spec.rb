require 'spec_helper'

describe Message do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) {FactoryGirl.create(:user) }

  before { @message = user.messages.build(content: "Lorem ipsum", receiver_id: other_user.id) }

  subject { @message }

  it { should respond_to(:to) }
  it { should respond_to(:content) }
  it { should respond_to(:sender_id) }
  it { should respond_to(:receiver_id) }
  it { should respond_to(:sender) }
  it { should respond_to(:receiver) }
  its(:sender) { should eq user }
  its(:receiver) { should eq other_user }

  it { should be_valid }

  describe "when sender id is not present" do
    before { @message.sender_id = nil }
    it { should_not be_valid }
  end

  describe "when sender id is a string" do
    before { @message.sender_id = "a" }
    it { should_not be_valid }
  end

  describe "when receiver id is not present" do
    before { @message.receiver_id = nil }
    it { should_not be_valid }
  end

  describe "when receiver id is not present" do
    before { @message.receiver_id = "a" }
    it { should_not be_valid }
  end

  describe "when content is empty" do
    before { @message.content = "" }
    it { should_not be_valid }
  end

  describe "when content is too long" do
    before { @message.content = "a" * 1001 }
    it { should_not be_valid }
  end
end
