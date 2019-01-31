# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/hangout-chat"
require "logstash/codecs/plain"
require "logstash/event"

describe LogStash::Outputs::HangoutChat do
  let(:sample_event) { LogStash::Event.new }
  let(:output) { LogStash::Outputs::HangoutChat.new }

  before do
    output.register
  end

  describe "receive message" do
    subject { output.receive(sample_event) }
    end
  end
end
