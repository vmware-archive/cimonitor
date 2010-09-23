class IntegrityProject < Project
  validate :validate_feed_url

  def project_name
    return nil if feed_url.nil?
    feed_url.split('/').last
  end

  def build_status_url
    feed_url
  end

  def parse_building_status(content)
    status = super(content)
    begin
      doc = Nokogiri::XML.parse(content)
      latest_build = doc.css('#last_build').first
      status.building = !!(latest_build.attribute('class').value =~ /building/i)
      return status
    rescue
      #silent
    end
    status
  end

  def parse_project_status(content)
    status = super(content)
    begin
      doc = Nokogiri::XML.parse(content)
      latest_build = doc.css('#last_build').first
      status.success = !!(latest_build.attribute('class').value =~ /success/i)
      host = URI.parse(feed_url).host
      build_path = doc.css('#previous_builds li a').first.attribute('href')
      status.url = "http://#{host}#{build_path}"
      pub_date = Time.parse(latest_build.css('.when').first.attribute('title').value)
      status.published_at = (pub_date == Time.at(0) ? Clock.now : pub_date).localtime
    rescue
      #silent
    end
    status
  end

  private

  def validate_feed_url
    #please someone write this as a REGEX
    errors.add(:feed_url, "Feed Url cannot be blank") if feed_url.blank?
    errors.add(:feed_url, "Feed URL must look like http://example.com:port/project") if feed_url.count("/") != 3
  end
end