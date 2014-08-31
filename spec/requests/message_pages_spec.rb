require 'spec_helper'

describe "Message Page" do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let!(:m1) { FactoryGirl.create(:message, receiver_id: user.id, sender_id: other_user.id, content: "foo") }
  before { sign_in user }
  subject { page }

  describe "New Message" do
    let(:submit) { "Send" }
    before { visit new_message_path }

    it { should have_content('New Message') }
    it { should have_title(full_title('New Message')) }

    describe "with invalid information" do
      before { click_button submit }

      it { should have_title(full_title('New Message')) }
      it { should have_content("The form contains 3 errors.") }
      it { should have_content("Receiver can\'t be blank") }
      it { should have_content("Receiver is not a number") }
      it { should have_content("Content can\'t be blank") }
    end

    describe "with valid information" do
      before do
        fill_in "To", with: other_user.username
        fill_in "Content", with: "Lorem ipsum"
      end

      it "should create a message" do
        expect { click_button submit }.to change(Message, :count).by(1)
      end
    end
  end

  describe "Index" do
    let!(:m2) { FactoryGirl.create(:message, receiver_id: user.id, sender_id: other_user.id, content: "bar") }

    before { visit messages_path }

    it { should have_content('Inbox') }
    it { should have_title(full_title('Inbox')) }
    it { should have_link("New Message", new_message_path) }
    it { should have_link("Inbox", messages_path) }
    it { should have_link("Sent Messages", sent_messages_path) }

    describe "messages" do
      it { should have_content(m1.sender.name) }
      it { should have_content(m1.content) }
      it { should have_link("View Message", message_path(m1)) }
      it { should have_content(m2.content) }
    end
  end

  describe "Sent" do
    let!(:sent_message) { FactoryGirl.create(:message, receiver_id: other_user.id, sender_id: user.id, content: "lorem ipsum") }

    before { visit sent_messages_path }

    it { should have_content('Sent Messages') }
    it { should have_title(full_title('Sent Messages')) }

    describe "messages" do
      it { should have_content(sent_message.receiver.name)}
      it { should have_content(sent_message.content) }
      it { should have_link("View Message", message_path(sent_message)) }
    end
  end

  describe "View Message" do

    before { visit message_path(m1) }

    it { should have_content('View Message') }
    it { should have_title(full_title('View Message')) }
    it { should have_content(m1.receiver.name) }
    it { should have_content(m1.sender.name) }
    it { should have_content(m1.content) }
  end
end
