require "spec_helper"

describe TeamCityBuild do
  let(:feed_url) { "http://localhost:8111/app/rest/builds?locator=running:all,buildType:(id:#{build_id})" }
  let(:build_id) { "bt#{rand(1)}" }
  let(:build) { TeamCityBuild.new(:feed_url => feed_url, :auth_username => "john", :auth_password => "secret") }

  describe "#build_id" do
    it "is retrieved from the feed_url" do
      build.build_id.should == build_id
    end
  end

  describe "#status" do
    let(:build_status) { double(:build_status, :online? => online, :green? => green) }
    let(:online) { [true,false].sample }
    let(:green) { [true,false].sample }

    before { build.build_status_fetcher = proc { build_status } }
    subject { build.status }

    its(:online) { should == online }
    its(:success) { should == green }
  end

  describe "#children" do
    subject { build.children }

    before do
      build.build_type_fetcher = proc { build_type_xml }
    end

    context "no children" do
      let(:build_type_xml) do
        <<-XML
          <buildType id="bt2" webUrl="http://localhost:8111/viewType.html?buildTypeId=bt2">
            <snapshot-dependencies />
          </buildType>
        XML
      end

      it { should be_empty }
    end

    context "some children" do
      let(:build_type_xml) do
        <<-XML
          <buildType id="bt2" webUrl="http://localhost:8111/viewType.html?buildTypeId=bt2">
            <snapshot-dependencies>
              <snapshot-dependency id="bt3" type="snapshot_dependency" />
            </snapshot-dependencies>
          </buildType>
        XML
      end

      it "should have a child with an id of bt3" do
        subject.first.build_id.should == "bt3"
      end
    end

    context "some grand children" do
      let(:build_type_xml) do
        <<-XML
          <buildType id="bt2" webUrl="http://localhost:8111/viewType.html?buildTypeId=bt2">
            <snapshot-dependencies>
              <snapshot-dependency id="bt3" type="snapshot_dependency" />
            </snapshot-dependencies>
          </buildType>
        XML
      end

      let(:child_build_type_xml) do
        <<-XML
          <buildType id="bt3" webUrl="http://localhost:8111/viewType.html?buildTypeId=bt3">
            <snapshot-dependencies>
              <snapshot-dependency id="bt5" type="snapshot_dependency" />
            </snapshot-dependencies>
          </buildType>
        XML
      end

      let(:grandchild_build_type_xml) do
        <<-XML
          <buildType id="bt5" webUrl="http://localhost:8111/viewType.html?buildTypeId=bt5">
            <snapshot-dependencies/>
          </buildType>
        XML
      end

      before do
        UrlRetriever.stub(:retrieve_content_at).with("http://localhost:8111/httpAuth/app/rest/buildTypes/id:bt3", build.auth_username, build.auth_password).and_return child_build_type_xml
        UrlRetriever.stub(:retrieve_content_at).with("http://localhost:8111/httpAuth/app/rest/buildTypes/id:bt5", build.auth_username, build.auth_password).and_return grandchild_build_type_xml
      end

      it "should have a child with an id of bt3" do
        subject.first.build_id.should == "bt3"
      end

      it "should have a grandchild with an id of bt5" do
        subject.first.children.first.build_id.should == "bt5"
      end
    end
  end
end
