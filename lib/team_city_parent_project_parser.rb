class TeamCityParentProjectParser

  def self.parse(content)
    new(content).build
  end

  def initialize(content)
    @content = content
  end

  def build
    dependencies + [project]
  end

  private

  def build_project(id)
    TeamCityRestProject.new(
      :feed_url => "#{base_url}/app/rest/builds?locator=running:all,buildType:(id:#{id})"
    )
  end

  def dependencies
    parsed_content.xpath("//snapshot-dependency").collect {|d| d.attributes["id"].to_s }.map do |id|
      build_project id
    end
  end

  def project
    build_project parsed_content.xpath("//buildType").first.attributes["id"].to_s
  end

  def parsed_content
    @parsed_content ||= Nokogiri::XML(@content)
  end

  def base_url
    @base_url ||= "#{root_url.scheme}://#{root_url.host}:#{root_url.port}"
  end

  def root_url
    @root_url ||= URI(parsed_content.xpath("//buildType").first.attributes["webUrl"].to_s)
  end
end
