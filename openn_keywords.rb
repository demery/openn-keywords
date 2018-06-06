#!/usr/bin/env ruby

require 'nokogiri'
require 'csv'

ns = { t: 'http://www.tei-c.org/ns/1.0' }

# ARGV.each do |xml_file|
#   doc = File.open(xml_file) { |f| Nokogiri::XML(f) }
#   %w{ subjects form/genre }.each do |type|
#     doc.xpath("//t:keywords[@n='#{type}']/t:term", ns).each { |e| puts "#{type}: #{e.text}" }
#   end
# end

headings = %w{ file bibid type text }
CSV.open('keywords.csv', 'wb+') do |csv|
  csv << headings
  ARGV.each do |xml_file|
    doc = File.open(xml_file) { |f| Nokogiri::XML(f) }
    base = File.basename xml_file
    bibid = doc.xpath('//t:altIdentifier[@type="bibid"]/t:idno', ns).text
    %w{ subjects form/genre }.each do |type|
      doc.xpath("//t:keywords[@n='#{type}']/t:term", ns).each do |e|
        csv << [base, bibid, type, e.text]
      end
    end
  end
end

puts "Wrote: keywords.csv"
