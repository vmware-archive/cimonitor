require File.dirname(__FILE__) + '/../spec_helper'
require 'nokogiri'

shared_examples_for "integrity status for a valid build history xml response" do
  it "should return the link to the checkin" do
    link = @response_doc.css("entry:first link").first.attribute('href').value
    @status_parser.url.should == link
  end

  it "should return the published date of the checkin" do
    date_elements =  @response_doc.css("entry:first published").first
    @status_parser.published_at.should == Time.parse(date_elements.content)
  end
end

describe IntegrityStatusParser do

  @success_data = File.read('test/fixtures/integrity_examples/success.html')
  @never_green_data = File.read('test/fixtures/integrity_examples/never_green.html')
  @failure_data = File.read('test/fixtures/integrity_examples/failure.html')
  @invalid_data = "<foo><bar>baz</bar></foo>"

  describe "with reported success" do
    before(:all) do
      @response_doc = Nokogiri::XML.parse(@success_data)
      @status_parser = IntegrityStatusParser.status(@success_data)
    end

    it_should_behave_like "integrity status for a valid build history xml response"

    it "should report success" do
      @status_parser.should be_success
    end
  end

  describe "with reported failure" do
    before(:all) do
      @response_doc = Nokogiri::XML.parse(@failure_data)
      @status_parser = IntegrityStatusParser.status(@failure_data)
    end

    it_should_behave_like "integrity status for a valid build history xml response"

    it "should report failure" do
      @status_parser.should_not be_success
    end
  end

  describe "with invalid xml" do
    before(:all) do
      @parser = Nokogiri::XML.parse(@response_xml = @invalid_data)
      @response_doc = @parser.parse
      @status_parser = IntegrityStatusParser.status(@invalid_data)
    end
  end

  describe "building" do
    @building_data = File.read('test/fixtures/integrity_examples/building.html')
    @not_building_data = File.read('test/fixtures/integrity_examples/success.html')
    @invalid_building_data = "<foo><bar>baz</bar></foo>"

    context "with a valid response that the project is building" do
      before(:each) do
        @status_parser = IntegrityStatusParser.building(@building_data, stub("a project", :project_name => 'Pulse'))
      end

      it "should set the building flag on the project to true" do
        @status_parser.should be_building
      end
    end

    context "with a valid response that the project is not building" do
      before(:each) do
        @status_parser = IntegrityStatusParser.building(@not_building_data, stub("a project", :project_name => 'Pulse'))
      end

      it "should set the building flag on the project to false" do
        @status_parser.should_not be_building
      end
    end

    context "with an invalid response" do
      before(:each) do
        @status_parser = IntegrityStatusParser.building(@invalid_building_data, stub("a project", :project_name => 'Socialitis'))
      end

      it "should set the building flag on the project to false" do
        @status_parser.should_not be_building
      end
    end
  end
end

