require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe IntegrityProject do
  before(:each) do
    @project = IntegrityProject.new(:name => "my_integrity_project", :feed_url => "http://integrity.example.com/integrity_project")
  end

  describe "#project_name" do
    it "should return nil when feed_url is nil" do
      @project.feed_url = nil
      @project.project_name.should be_nil
    end

    it "should extract the project name from the project URL" do
      @project.project_name.should == "integrity_project"
    end

    it "should extract the project name from the url regardless of capitalization" do
      @project.feed_url = @project.feed_url.upcase
      @project.project_name.should == "INTEGRITY_PROJECT"
    end
  end

  describe 'validations' do
    it "should require a Integrity url format" do
      @project.should have(0).errors_on(:feed_url)
      @project.feed_url = 'http://foo.bar.com:9292/wrong/wrong'
      @project.should have(1).errors_on(:feed_url)
    end
  end

  describe "#build_status_url" do
    it "should use the feet url" do
      @project.build_status_url.should == @project.feed_url
    end
  end

  describe "#status_parser" do
    describe "with reported success" do
      before(:each) do
        @status_parser = @project.parse_project_status(IntegrityHtmlExample.new("success.html").read)
      end

      it "should return the link to the checkin" do
        @status_parser.url.should == 'http://integrity.example.com/integrity_project/builds/12'
      end

      it "should return the published date of the checkin" do
        @status_parser.published_at.should == Time.parse('2010-03-27T20:54:17-07:00')
      end

      it "should report success" do
        @status_parser.should be_success
      end
    end

    describe "with reported failure" do
      before(:each) do
        @status_parser = @project.parse_project_status(IntegrityHtmlExample.new("failure.html").read)
      end

      it "should return the link to the checkin" do
        @status_parser.url.should == 'http://integrity.example.com/integrity_project/builds/12'
      end

      it "should return the published date of the checkin" do
        @status_parser.published_at.should == Time.parse('2010-03-27T20:54:17-07:00')
      end

      it "should report failure" do
        @status_parser.should_not be_success
      end
    end

    describe "with invalid html" do
      it "should not raise and error" do
        lambda { @project.parse_project_status('bad data here') }.should_not raise_error

      end
    end

    describe "#building_parser" do
      context "with a valid response that the project is building" do
        it "should set the building flag on the project to true" do
          @status_parser = @project.parse_building_status(IntegrityHtmlExample.new("building.html").read)
          @status_parser.should be_building
        end
      end

      context "with a valid response that the project is not building" do
        it "should set the building flag on the project to false" do
          @status_parser = @project.parse_building_status(IntegrityHtmlExample.new("success.html").read)
          @status_parser.should_not be_building
        end
      end

    context "with an invalid response" do
      it "should set the building flag on the project to false" do
        @status_parser = @project.parse_building_status("bad data here")
        @status_parser.should_not be_building
      end
    end
    end
  end
end
