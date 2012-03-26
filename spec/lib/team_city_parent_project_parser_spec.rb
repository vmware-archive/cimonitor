require 'spec_helper'

describe TeamCityParentProjectParser do
  let(:parsed) { TeamCityParentProjectParser.parse(content) }
  let(:content) do
    <<-XML
    <buildType id="bt2" webUrl="http://localhost:8111/viewType.html?buildTypeId=bt2">
      <snapshot-dependencies>
        <snapshot-dependency id="bt3" type="snapshot_dependency" />
        <snapshot-dependency id="bt5" type="snapshot_dependency" />
        <snapshot-dependency id="bt9" type="snapshot_dependency" />
      </snapshot-dependencies>
    </buildType>
    XML
  end

  it "should return a team city rest project for the parent" do
    parsed.collect(&:feed_url).should(
      include("http://localhost:8111/app/rest/builds?locator=running:all,buildType:(id:bt2)")
    )
  end

  it "should return team city rest project instances for any dependencies" do
    [3,5,9].each do |i|
      parsed.collect(&:feed_url).should(
        include("http://localhost:8111/app/rest/builds?locator=running:all,buildType:(id:bt#{i})")
      )
    end
  end
end
