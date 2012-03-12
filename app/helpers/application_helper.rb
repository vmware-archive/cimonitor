module ApplicationHelper
  def logo
    'ci-logo.png'
  end

  def title
    "Pivotal Labs CI"
  end


  private

  def internal?
    RAILS_ENV == 'internal'
  end

end
