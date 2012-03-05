require 'spec_helper'

describe 'dashboards/_project_tracker.html.erb' do
  let(:page) { Capybara::Node::Simple.new(rendered) }

  before do
    @project = projects(:red_currently_building)
    @project.tracker_release_deadline = '2012-12-31 12:00:00'
  end

  it "should display the project name" do
    render :partial => "dashboards/project_tracker", :locals => {:project => @project }
    page.should have_content('Red Currently Building - Tracker')
  end

  context 'is on track' do
    before do
      @project.tracker_release_status = Project::TrackerStatus::ON_TRACK
      render :partial => "dashboards/project_tracker", :locals => {:project => @project }
    end

    it "should display the correct release status" do
      page.should have_css('div.project_name.success')
      page.should have_css("div.project_status img[src*='checkmark.png']")
    end

    it "should have a green box css class" do
      page.should have_css('div.box.greenbox')
    end
  end

end