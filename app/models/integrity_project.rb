class IntegrityProject < Project
  validate :validate_feed_url

  def project_name
    return nil if feed_url.nil?
    feed_url.split('/').last
  end

  def build_status_url
    feed_url
  end

  def building_parser(content)
    IntegrityStatusParser.building(content, self)
  end

  def status_parser(content)
    IntegrityStatusParser.status(content, self)
  end
  
  private 
  
  def validate_feed_url
    #please someone write this as a REGEX
    errors.add(:feed_url, "Feed Url cannot be blank") if feed_url.blank?
    errors.add(:feed_url, "Feed URL must look like http://example.com:port/project") if feed_url.count("/") != 3
  end
end