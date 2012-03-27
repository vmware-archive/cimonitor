class TeamCityBuild < TeamCityRestProject

  attr_writer :build_status_fetcher, :build_type_fetcher

  def build_id
    feed_url.match(/id:([^)]*)/)[1]
  end

  def status
    super.tap do |s|
      s.online = build_status.online?
      s.success = build_status.green?
    end
  end

  def children
    TeamCityChildBuilder.parse(self, build_type_fetcher.call)
  end

  private

  def build_status
    @build_status ||= build_status_fetcher.call
  end

  def build_status_fetcher
    @build_status_fetcher
  end

  def build_type_fetcher
    @build_type_fetcher ||= proc {
      UrlRetriever.retrieve_content_at(build_type_url, auth_username, auth_password)
    }
  end

  def build_type_url
    uri = URI(feed_url)
    "#{uri.scheme}://#{uri.host}:#{uri.port}/httpAuth/app/rest/buildTypes/id:#{build_id}"
  end
end
