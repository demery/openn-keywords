#!/usr/bin/env ruby

require 'nokogiri'
require 'csv'

ns = { t: 'http://www.tei-c.org/ns/1.0' }

out_csv = 'keywords.csv'

headings = %w{ file bibid shelf_mark type text }
CSV.open(out_csv, 'wb+') do |csv|
  csv << headings
  ARGV.each do |xml_file|
    doc = File.open(xml_file) { |f| Nokogiri::XML(f) }
    base = File.basename xml_file
    bibid = doc.xpath('//t:altIdentifier[@type="bibid"]/t:idno', ns).text
    shelf_mark = doc.xpath('//t:sourceDesc/t:msDesc/t:msIdentifier/t:idno[@type="call-number"]', ns).text
    %w{ subjects form/genre }.each do |n|
      doc.xpath("//t:keywords[@n='#{n}']/t:term", ns).each do |e|
        csv << [base, bibid, shelf_mark, n, e.text]
      end
    end
  end
end

puts "Wrote: #{out_csv}"
