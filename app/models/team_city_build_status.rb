class TeamCityBuildStatus
  attr_reader :build
  # "#{base_url}/app/rest/builds?locator=running:all,buildType:(id:#{id})"

  def initialize(build)
    @build = build
  end

  def fetch
    @building = build_response["running"] == "true"
    @green = build_response["status"] == "SUCCESS"
    @online = true

  rescue Net::HTTPError
    @online = false
  end

  def online?
    @online
  end

  def green?
    online? && !building? && @green
  end

  def red?
    online? && !green? && !building?
  end

  def building?
    online? && @building
  end

  private
  def build_response
    @build_response || fetch_build_response
  end

  def fetch_build_response
    response = UrlRetriever.retrieve_content_at(build.feed_url, build.auth_username, build.auth_password)
    response = Hash.from_xml response

    @build_response = response['builds']['build']
    @build_response = @build_response.first if @build_response.kind_of? Array
    @build_response
  end
end
