require 'spec_helper'

###
# Shared examples for MentionSystem::Mentionee
###
shared_examples_for MentionSystem::Mentionee do
  ###
  # Let mentionee be DummyMentionee.create
  ###
  let(:mentionee) { DummyMentionee.create }

  ###
  # Let mentioner be DummyMentioner.create
  ###
  let(:mentioner) { DummyMentioner.create }

  ###
  # Describes associations
  ###
  describe "associations" do
    ###
    # Should have many mentioners
    ###
    it "should have many mentioners" do
      should have_many(:mentioners)
    end
  end

  ###
  # Describes class methods
  ###
  describe "class methods" do
    ###
    # Should be a mentionee
    ###
    it "should be a mentionee" do
      expect(mentionee.is_mentionee?).to equal(true)
    end

    ###
    # Should be mentioned by a mentioner
    ###
    it "should specify if is mentioned by a mentioner" do
      expect(MentionSystem::Mention).to receive(:mentions?).with(mentioner, mentionee) { true }

      expect(mentionee.mentioned_by?(mentioner)).to equal(true)
    end

    ###
    # Should scope mentioners filtered by mentioner type
    ###
    it "should scope mentioners filtered by mentioner type" do
      scope = MentionSystem::Mention.scope_by_mentionee(mentionee).scope_by_mentioner_type(DummyMentioner)

      expect(mentionee.mentioners_by(DummyMentioner)).to eq(scope)
    end
  end
end

###
# Describes DummyMentionee
###
describe DummyMentionee, type: :model do
  ###
  # It behaves like MentionSystem::Mentionee
  ###
  it_behaves_like MentionSystem::Mentionee
end

