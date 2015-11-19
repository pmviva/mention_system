require 'spec_helper'

###
# Describes MentionSystem::Mention
###
describe MentionSystem::Mention, type: :model do
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
    # Should belong to mentionee
    ###
    it "should belong to mentionee" do
      should belong_to(:mentionee)
    end

    ###
    # Should belong to mentioner
    ###
    it "should belong to mentioner" do
      should belong_to(:mentioner)
    end
  end

  ###
  # Describes class methods
  ###
  describe "class methods" do
    ###
    # Should raise argument error on invalid mentionee when mentions
    ###
    it "should raise argument error on invalid mentionee when mentions" do
      expect { MentionSystem::Mention.mention(mentioner, mentioner) }.to raise_error ArgumentError
    end

    ###
    # Should raise argument error on invalid mentioner when mentions
    ###
    it "should raise argument error on invalid mentioner when mentions " do
      expect { MentionSystem::Mention.mention(mentionee, mentionee) }.to raise_error ArgumentError
    end

    ###
    # Should mention
    ###
    it "should mention" do
      expect(MentionSystem::Mention.mention(mentioner, mentionee)).to equal(true)
    end

    ###
    # Should not mention
    ###
    it "should not mention" do
      MentionSystem::Mention.mention(mentioner, mentionee)

      expect(MentionSystem::Mention.mention(mentioner, mentionee)).to equal(false)
    end

    ###
    # Should raise argument error on invalid mentionee when unmentions
    ###
    it "should raise argument error on invalid mentionee when unmentions" do
      expect { MentionSystem::Mention.unmention(mentioner, mentioner) }.to raise_error ArgumentError
    end

    ###
    # Should raise argument error on invalid mentioner when unmentions
    ###
    it "should raise argument error on invalid mentioner when unmentions" do
      expect { MentionSystem::Mention.unmention(mentionee, mentionee) }.to raise_error ArgumentError
    end

    ###
    # Should unmention
    ###
    it "should unmention" do
      MentionSystem::Mention.mention(mentioner, mentionee)

      expect(MentionSystem::Mention.unmention(mentioner, mentionee)).to equal(true)
    end

    ###
    # Should not unmention
    ###
    it "should not unmention" do
      expect(MentionSystem::Mention.unmention(mentioner, mentionee)).to equal(false)
    end

    ###
    # Should raise argument error on invalid mentionee when toggle mention
    ###
    it "should raise argument error on invalid mentionee when toggle mention" do
      expect { MentionSystem::Mention.toggle_mention(mentioner, mentioner) }.to raise_error ArgumentError
    end

    ###
    # Should raise argument error on invalid mentioner when toggle mention
    ###
    it "should raise argument error on invalid mentioner when toggle mention" do
      expect { MentionSystem::Mention.toggle_mention(mentionee, mentionee) }.to raise_error ArgumentError
    end

    ###
    # Should toggle mention
    ###
    it "should toggle mention" do
      expect(MentionSystem::Mention.mentions?(mentioner, mentionee)).to equal(false)

      MentionSystem::Mention.toggle_mention(mentioner, mentionee)

      expect(MentionSystem::Mention.mentions?(mentioner, mentionee)).to equal(true)

      MentionSystem::Mention.toggle_mention(mentioner, mentionee)

      expect(MentionSystem::Mention.mentions?(mentioner, mentionee)).to equal(false)
    end

    ###
    # Should specify if mentions
    ###
    it "should specify if mentions" do
      expect(MentionSystem::Mention.mentions?(mentioner, mentionee)).to equal(false)

      MentionSystem::Mention.mention(mentioner, mentionee)

      expect(MentionSystem::Mention.mentions?(mentioner, mentionee)).to equal(true)
    end

    ###
    # Should scope mentions by mentionee
    ###
    it "should scope mentions by mentionee" do
      scope = MentionSystem::Mention.where(mentionee: mentionee)

      expect(MentionSystem::Mention.scope_by_mentionee(mentionee)).to eq(scope)
    end

    ###
    # Should scope mentions by mentionee type
    ####
    it "should scope mentions by mentionee type" do
      scope = MentionSystem::Mention.where(mentionee_type: DummyMentionee)

      expect(MentionSystem::Mention.scope_by_mentionee_type(DummyMentionee)).to eq(scope)
    end

    ###
    # Should scope mentions by mentioner
    ###
    it "should scope mentions by mentioner" do
      scope = MentionSystem::Mention.where(mentioner: mentioner)

      expect(MentionSystem::Mention.scope_by_mentioner(mentioner)).to eq(scope)
    end

    ###
    # Should scope mentions by mentioner type
    ####
    it "should scope mentions by mentioner type" do
      scope = MentionSystem::Mention.where(mentioner_type: DummyMentioner)

      expect(MentionSystem::Mention.scope_by_mentioner_type(DummyMentioner)).to eq(scope)
    end
  end
end

