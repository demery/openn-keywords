#!/usr/bin/env ruby

require 'nokogiri'
require 'csv'

ns = { t: 'http://www.tei-c.org/ns/1.0' }

headings = %w{ file bibid shelf_mark title language mainLang otherLangs origin origDate origPlace binding scriptNote support description }
out_csv = 'descriptions.csv'
CSV.open(out_csv, 'wb+') do |csv|
  csv << headings
  ARGV.each do |xml_file|
    doc = File.open(xml_file) { |f| Nokogiri::XML(f) }
    file = File.basename xml_file
    bibid = doc.xpath('//t:altIdentifier[@type="bibid"]/t:idno', ns).text
    shelf_mark = doc.xpath('//t:sourceDesc/t:msDesc/t:msIdentifier/t:idno[@type="call-number"]', ns).text
    title = doc.xpath('//t:msContents/t:msItem[1]/t:title', ns).text
    language = doc.xpath('//t:msContents/t:textLang', ns).text
    mainLang = doc.xpath('//t:msContents/t:textLang/@mainLang', ns)
    otherLangs = doc.xpath('//t:msContents/t:textLang/@otherLangs', ns)
    origin = doc.xpath('//t:sourceDesc/t:msDesc/t:history/t:origin/t:p', ns).text
    origDate = doc.xpath('//t:sourceDesc/t:msDesc/t:history/t:origin/t:origDate', ns).text
    origPlace = doc.xpath('//t:sourceDesc/t:msDesc/t:history/t:origin/t:origPlace', ns).text
    description = doc.xpath('//t:msContents/t:summary', ns).text
    # /TEI/teiHeader[1]/fileDesc[1]/sourceDesc[1]/msDesc[1]/physDesc[1]/bindingDesc[1]/binding[1]/p[1]
    binding = doc.xpath('//t:sourceDesc/t:msDesc/t:physDesc/t:bindingDesc/t:binding/t:p', ns).text
    # /TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/scriptDesc/scriptNote
    scriptNote = doc.xpath('//t:sourceDesc/t:msDesc/t:physDesc/t:scriptDesc/t:scriptNote', ns).text
    # /t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:support/t:p
    support = doc.xpath('//t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/@material', ns).text
    csv << [ file, bibid, shelf_mark, title, language, mainLang, otherLangs, origin, origDate, origPlace, binding, scriptNote, support, description ]
  end
end

puts "Wrote: #{out_csv}"
