require "spec_helper"

describe TeamCityBuildStatus do

  describe "#initialize" do
    let(:build) { double(:build) }
    it "requires a build" do
      status = TeamCityBuildStatus.new(build)
      status.build.should == build
    end
  end

  describe "#fetch" do
    let(:build) { double(:build, :feed_url => "http", :auth_username => "foo", :auth_password => "bar") }
    let(:status) { TeamCityBuildStatus.new(build) }
    let(:response_xml) do
      <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <builds count="1">
          <build id="1" number="1" status="SUCCESS"/>
          <build id="2" number="2" status="SUCCESS"/>
        </builds>
      XML
    end

    before do
      UrlRetriever.stub(:retrieve_content_at).
        with(build.feed_url, build.auth_username, build.auth_password).
        and_return(response_xml)
    end

    it "uses the urlretriever to fetch the status" do
      UrlRetriever.should_receive(:retrieve_content_at).
        with(build.feed_url, build.auth_username, build.auth_password).
        and_return(response_xml)
      status.fetch
    end

    context "green response" do
      before { status.fetch }

      it "assigns online? true" do
        status.online?.should be_true
      end

      it "assigns green? true" do
        status.green?.should be_true
      end

      it "assigns building? false" do
        status.building?.should be_false
      end

      it "assigns red? false" do
        status.red?.should be_false
      end
    end

    context "building response" do
      let(:response_xml) do
        <<-XML
          <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
          <builds count="1">
            <build id="1" number="1" running="true" status="SUCCESS"/>
          </builds>
        XML
      end

      before { status.fetch }

      it "assigns online? true" do
        status.online?.should be_true
      end

      it "assigns green? false" do
        status.green?.should be_false
      end

      it "assigns building? true" do
        status.building?.should be_true
      end

      it "assigns red? false" do
        status.red?.should be_false
      end
    end

    context "red response" do
      let(:response_xml) do
        <<-XML
          <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
          <builds count="1">
            <build id="1" number="1" status="#{['ERROR','FAILURE'].sample}"/>
            <build id="2" number="2" status="SUCCESS"/>
          </builds>
        XML
      end

      before { status.fetch }

      it "assigns online? true" do
        status.online?.should be_true
      end

      it "assigns green? false" do
        status.green?.should be_false
      end

      it "assigns building? false" do
        status.building?.should be_false
      end

      it "assigns red? true" do
        status.red?.should be_true
      end
    end

    context "invalid response" do
      before do
        UrlRetriever.stub(:retrieve_content_at).and_raise(Net::HTTPError.new("foo", "jkfldsaj"))
        status.fetch
      end

      it "assigns online? false" do
        status.online?.should be_false
      end

      it "assigns green? false" do
        status.green?.should be_false
      end

      it "assigns building? false" do
        status.building?.should be_false
      end

      it "assigns red? false" do
        status.red?.should be_false
      end
    end
  end
end
