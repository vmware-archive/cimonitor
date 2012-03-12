require 'spec_helper'

describe ApplicationHelper do

  describe 'rendering status images' do

    before do
      @now = Time.parse('2008-06-15 12:00')
      Time.stub(:now).and_return(@now)
      @status = ProjectStatus.new
      @status.url = 'http://www.pivotallabs.com/build1'
    end




  end
  
end