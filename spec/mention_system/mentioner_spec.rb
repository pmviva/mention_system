require 'spec_helper'

###
# Shared examples for MentionSystem::Mentioner
###
shared_examples_for MentionSystem::Mentioner do
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
    # Should have many mentionees
    ###
    it "should have many mentionees" do
      should have_many(:mentionees)
    end
  end

  ###
  # Describes class methods
  ###
  describe "class methods" do
    ###
    # Should be a mentioner
    ###
    it "should be a mentioner" do
      expect(mentioner.is_mentioner?).to equal(true)
    end

    ###
    # Should mention a mentionee
    ###
    it "Should mention a mentionee" do
      expect(MentionSystem::Mention).to receive(:mention).with(mentioner, mentionee) { true }

      expect(mentioner.mention(mentionee)).to equal(true)
    end

    ###
    # Should unmention a mentionee
    ###
    it "Should unmention a mentionee" do
      expect(MentionSystem::Mention).to receive(:unmention).with(mentioner, mentionee) { true }

      expect(mentioner.unmention(mentionee)).to equal(true)
    end

    ###
    # Should toggle mention a mentionee
    ###
    it "Should toggle mention a mentionee" do
      expect(MentionSystem::Mention).to receive(:toggle_mention).with(mentioner, mentionee) { true }

      expect(mentioner.toggle_mention(mentionee)).to equal(true)
    end

    ###
    # Should mention a mentionee
    ###
    it "should specify if mentions a mentionee" do
      expect(MentionSystem::Mention).to receive(:mentions?).with(mentioner, mentionee) { true }

      expect(mentioner.mentions?(mentionee)).to equal(true)
    end

    ###
    # Should scope mentionees filtered by mentionee type
    ###
    it "should scope mentionees filtered by mentionee type" do
      scope = MentionSystem::Mention.scope_by_mentioner(mentioner).scope_by_mentionee_type(DummyMentionee)

      expect(mentioner.mentionees_by(DummyMentionee)).to eq(scope)
    end
  end
end

###
# Describes DummyMentioner
###
describe DummyMentioner, type: :model do
  ###
  # It behaves like MentionSystem::Mentioner
  ###
  it_behaves_like MentionSystem::Mentioner
end
