require 'rake'
require 'rspec/core/rake_task'
require 'yaml'
require 'ansible_spec'

properties = AnsibleSpec.get_properties
# {"name"=>"Ansible-Sample-TDD", "hosts"=>["192.168.0.103","192.168.0.103"], "user"=>"root", "roles"=>["nginx", "mariadb"]}
# {"name"=>"Ansible-Sample-TDD", "hosts"=>[{"name" => "192.168.0.103:22","uri"=>"192.168.0.103","port"=>22, "private_key"=> "~/.ssh/id_rsa"}], "user"=>"root", "roles"=>["nginx", "mariadb"]}
cfg = AnsibleSpec::AnsibleCfg.new

desc "Run serverspec to all test"
task :all => "serverspec:all"

namespace :serverspec do
  properties = properties.compact.reject{|e| e["hosts"].length == 0}
  task :all => properties.map {|v| 'serverspec:' + v["name"] }
  properties.each_with_index.map do |property, index|
    property["hosts"].each do |host|
      desc "Run serverspec for #{property["name"]}"
      RSpec::Core::RakeTask.new(property["name"].to_sym) do |t|
        puts "Run serverspec for #{property["name"]} to #{host}"
        ENV['TARGET_HOSTS'] = host["hosts"]
        ENV['TARGET_HOST'] = host["uri"]
        ENV['TARGET_PORT'] = host["port"].to_s
        ENV['TARGET_GROUP_INDEX'] = index.to_s
        ENV['TARGET_PRIVATE_KEY'] = host["private_key"]
        unless host["user"].nil?
          ENV['TARGET_USER'] = host["user"]
        else
          ENV['TARGET_USER'] = property["user"]
        end
        ENV['TARGET_PASSWORD'] = host["pass"]
        ENV['TARGET_CONNECTION'] = host["connection"]

        roles = property["roles"]
        for role in property["roles"]
          for rolepath in cfg.roles_path
            deps = AnsibleSpec.load_dependencies(role, rolepath)
            if deps != []
              roles += deps
              break
            end
          end
        end
        t.pattern = '{' + cfg.roles_path.join(',') + '}/{' + roles.join(',') + '}/spec/*_spec.rb'
      end
    end
  end
end
