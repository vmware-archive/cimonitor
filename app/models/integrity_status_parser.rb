require 'nokogiri'

class IntegrityStatusParser < StatusParser
  class << self
    def building(content, project)
      building_parser = self.new
      begin
        latest_build = Nokogiri::XML.parse(content).css('#last_build').first
        building_parser.building = !!(latest_build.attribute('class').value =~ /building/i)
      rescue
        #die quietly
      end
      building_parser
    end
 
    def status(content, project)
      status_parser = self.new
      doc = Nokogiri::XML.parse(content)
      latest_build = doc.css('#last_build').first
      status_parser.success = !!(latest_build.attribute('class').value =~ /success/i)
      build_number = doc.css('#previous_builds li a').first.attribute('href').value.split('/').last
      status_parser.url = "#{project.feed_url}/builds/#{build_number}"
      pub_date = Time.parse(latest_build.css('.when').first.attribute('title').value)
      status_parser.published_at = (pub_date == Time.at(0) ? Clock.now : pub_date).localtime
      status_parser
    end
  end
end

