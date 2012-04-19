# encoding: utf-8
$:.unshift "lib"
require 'srx/english/sentence_splitter'

Given /^a text$/ do |text|
  @text = text
end

When /^the text is split$/ do
  @splitter = SRX::English::SentenceSplitter.new(@text)
end

Then /^the following sentences should be detected$/ do |table|
  table.hashes.zip(@splitter.to_a).each do |expected,returned|
    returned.gsub(/\s*\n/," ").strip.should == expected[:sentence]
  end
end
