require 'spec_helper'

###
# Describes MentionSystem::MentionProcessor
###
describe MentionSystem::MentionProcessor do
  ###
  # Let mention_processor be MentionSystem::MentionProcessor.new
  ###
  let(:mention_processor) { MentionSystem::MentionProcessor.new }

  ###
  # Let mentionee be DummyMentionee.create
  ###
  let(:mentionee) { DummyMentionee.create }

  ###
  # Let mentioner be DummyMentioner.create
  ###
  let(:mentioner) { DummyMentioner.create }

  ###
  # Describes instance methods
  ###
  describe "instance methods" do
    ###
    # Should process mentions with default mention prefix
    ###
    it "should process mentions with default mention prefix" do
      expect(mention_processor).to receive(:extract_mentioner_content).with(mentioner) { "This is the mentioner content with @handle1 and @handle2" }

      expect(mention_processor).to receive(:find_mentionees_by_handles).with(["handle1", "handle2"]) { [mentionee] }

      expect(mentioner).to receive(:mention).with(mentionee) { true }

      mention_processor.process_mentions(mentioner)
    end

    ###
    # Should process mentions with overriden mention prefix
    ###
    it "should process mentions with overriden mention prefix" do
      expect(mention_processor).to receive(:mention_prefix).exactly(3).times { "#" }

      expect(mention_processor).to receive(:extract_mentioner_content).with(mentioner) { "This is the mentioner content with #handle1 and #handle2" }

      expect(mention_processor).to receive(:find_mentionees_by_handles).with(["handle1", "handle2"]) { [mentionee] }

      expect(mentioner).to receive(:mention).with(mentionee) { true }

      mention_processor.process_mentions(mentioner)
    end

    ###
    # Should invooke after callbacks when processing mentions
    ###
    it "should invoke after callbacks when processing mentions" do
      callback = Proc.new { }

      mention_processor.add_after_callback(callback)
      mention_processor.add_after_callback(callback)

      expect(callback).to receive(:call).exactly(2).times { true }

      expect(mention_processor).to receive(:extract_mentioner_content).with(mentioner) { "This is the mentioner content with @handle1 and @handle2" }

      expect(mention_processor).to receive(:find_mentionees_by_handles).with(["handle1", "handle2"]) { [mentionee] }

      expect(mentioner).to receive(:mention).with(mentionee) { true }

      mention_processor.process_mentions(mentioner)
    end

    ###
    # Should stop processing when invoke after callback returns false
    ###
    it "should sto processing when invoke after callback returns false" do
      callback = Proc.new { }

      mention_processor.add_after_callback(callback)
      mention_processor.add_after_callback(callback)

      expect(callback).to receive(:call).once { false }

      expect(mention_processor).to receive(:extract_mentioner_content).with(mentioner) { "This is the mentioner content with @handle1 and @handle2" }

      expect(mention_processor).to receive(:find_mentionees_by_handles).with(["handle1", "handle2"]) { [mentionee] }

      expect(mentioner).to receive(:mention).with(mentionee) { true }

      mention_processor.process_mentions(mentioner)
    end

    ###
    # Should invoke before callbacks when processing mentions
    ###
    it "should invoke before callbacks when processing mentions" do
      callback = Proc.new {}

      mention_processor.add_before_callback(callback)
      mention_processor.add_before_callback(callback)

      expect(callback).to receive(:call).exactly(2).times { true }

      expect(mention_processor).to receive(:extract_mentioner_content).with(mentioner) { "This is the mentioner content with @handle1 and @handle2" }

      expect(mention_processor).to receive(:find_mentionees_by_handles).with(["handle1", "handle2"]) { [mentionee] }

      expect(mentioner).to receive(:mention).with(mentionee) { true }

      mention_processor.process_mentions(mentioner)
    end

    ###
    # Should stop processing when invoke before callbacks returns false
    ###
    it "should stop processing when invoke before callback returns false" do
      callback = Proc.new {}

      mention_processor.add_before_callback(callback)
      mention_processor.add_before_callback(callback)

      expect(callback).to receive(:call).once { false }

      expect(mention_processor).to receive(:extract_mentioner_content).with(mentioner) { "This is the mentioner content with @handle1 and @handle2" }

      expect(mention_processor).to receive(:find_mentionees_by_handles).with(["handle1", "handle2"]) { [mentionee] }

      expect(mentioner).to receive(:mention).with(mentionee).at_most(0).times

      mention_processor.process_mentions(mentioner)
    end

    ###
    # Should stop processing when mention returns false
    ###
    it "should stop processing when mention returns false" do
      callback = Proc.new {}

      mention_processor.add_after_callback(callback)
      mention_processor.add_after_callback(callback)

      expect(callback).to receive(:call).at_most(0).times

      expect(mention_processor).to receive(:extract_mentioner_content).with(mentioner) { "This is the mentioner content with @handle1 and @handle2" }

      expect(mention_processor).to receive(:find_mentionees_by_handles).with(["handle1", "handle2"]) { [mentionee] }

      expect(mentioner).to receive(:mention).with(mentionee) { false }

      mention_processor.process_mentions(mentioner)
    end
  end
end

