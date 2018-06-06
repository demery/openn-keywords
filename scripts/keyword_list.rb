#!/usr/bin/env ruby

require 'nokogiri'
require 'csv'

ns = { t: 'http://www.tei-c.org/ns/1.0' }

ARGV.each do |xml_file|
  doc = File.open(xml_file) { |f| Nokogiri::XML(f) }
  %w{ subjects form/genre }.each do |type|
    doc.xpath("//t:keywords[@n='#{type}']/t:term", ns).each { |e| puts "#{type}: #{e.text}" }
  end
end
