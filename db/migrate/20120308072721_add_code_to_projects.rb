class AddCodeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :code, :string
    add_column :aggregate_projects, :code, :string
    Project.all.each do |p|
      p.code = p.name.truncate(4, omission:'')
      p.save
    end
    AggregateProject.all.each do |p|
      p.code = p.name.truncate(4, omission:'')
      p.save
    end
  end
end
