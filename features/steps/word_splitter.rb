# encoding: utf-8
$:.unshift "lib"
require 'srx/english/word_splitter'

Given /^a sentence '([^']+)'$/ do |sentence|
  @sentence = sentence.force_encoding('utf-8')
end

When /^the sentence is split$/ do
  @splitter = SRX::English::WordSplitter.new(@sentence)
end

Then /^the following segments should be detected$/ do |table|
  table.hashes.zip(@splitter.to_a).each do |expected,returned|
    returned[0].should == expected[:segment].gsub(/'/,"")
    returned[1].should == expected[:type].to_sym
    returned[2].should == expected[:start].to_i
    returned[3].should == expected[:end].to_i
  end
end

Then /^the following non-blank segments should be detected$/ do |table|
  segments = @splitter.select{|s| s[1] != :other}
  table.hashes.zip(segments).each do |expected,returned|
    returned[0].should == expected[:segment].gsub(/'/,"")
    returned[1].should == expected[:type].to_sym
  end
end
