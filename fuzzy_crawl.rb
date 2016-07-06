#!/usr/bin/env ruby

require 'mechanize'
require 'pp'

def extract_talk text
  talks = []
  text.split("\n").each do |line|
    talks << $1 if line =~ /[:：](.*)$/
    talks << $1 if line =~ /「([^「」]+)」/
  end
  return talks
end

urls = [
  "http://ajatt.com/gits/02_gs/05_etc/01_ghost_in_the_shell.html",
  "http://www.geocities.jp/maskdclub/eurekastory1a.htm",
]

agent = Mechanize.new
urls.each do |url|
  agent.get(url) do |page|
    talks = extract_talk(page.search("body").inner_text)
    open('odd.txt', 'a').write talks.values_at(*talks.each_index.select {|i| i.odd?}).join("\n")
    open('even.txt', 'a').write talks.values_at(*talks.each_index.select {|i| i.even?}).join("\n")
  end
end

