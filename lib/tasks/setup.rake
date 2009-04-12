namespace :tapioca do

  desc "Takes care of default settings, bootstraps database, and installs default extensions"
  task :setup => [:copy_database_config, :environment, "db:bootstrap", :install_plugins, :install_extensions, :copy_layout, "db:migrate:extensions", "radiant:extensions:update_all"] do
    Radiant::Config['admin.title'] = prompt_for_title
    Radiant::Config['admin.subtitle'] = prompt_for_subtitle
    Radiant::Config['defaults.page.parts'] = "body,sidebar"
    Radiant::Config['defaults.page.status'] = "published"
    Radiant::Config['defaults.page.filter'] = "TinyMce"
  end

  desc "Sets up database config"
  task :copy_database_config do
    db_type = prompt_for_db_type
    from  = "config/database.#{db_type}.yml"
    to    = "config/database.yml"
    system "cp #{from} #{to}"
  end

  desc "Copies modified admin layout to app directory"
  task :copy_layout do
    from  = "vendor/extensions/tapioca/lib/views/layouts/application.html.haml"
    to    = "app/views/layouts/application.html.haml"
    system "cp #{from} #{to}"
  end

  desc "Installs default extensions"
  task :install_extensions do
    default_extensions.each do |name, url|
      system "git submodule add #{url} vendor/extensions/#{name}"
    end
  end

  desc "Installs default plugins"
  task :install_plugins do
    default_plugins.each do |name, url|
      system "git submodule add #{url} vendor/plugins/#{name}"
    end
  end

  desc "Installs optional extensions"
  task :install_optional_extensions do
    #TODO
  end

end

def default_extensions
  {
    :mailer             => "git://github.com/radiant/radiant-mailer-extension.git",
    :settings           => "git://github.com/Squeegy/radiant-settings.git",
    :sns                => "git://github.com/iamsolarpowered/radiant-sns-extension.git",
    :tinymce_filter     => "git://github.com/miv/radiant_tinymce_filter.git",
    :search             => "git://github.com/radiant/radiant-search-extension.git",
    :reorder            => "git://github.com/radiant/radiant-reorder-extension.git",
    :tags               => "git://github.com/jomz/radiant-tags-extension.git",
    :rss_reader         => "git://github.com/lorenjohnson/radiant-rss-reader.git",
    :mail_to            => "git://github.com/yoon/radiant-mail-to-extension.git"
  }
end

def default_plugins
  {
    :paperclip => "git://github.com/thoughtbot/paperclip.git"
  }
end

def prompt_for_db_type
  default_value = "sqlite"
  db_type = ask "What type of database would you like to use? (#{default_value}):"
  db_type = default_value if db_type.blank?
  db_type
end

def prompt_for_title
  default_value = "Tapioca Application"
  title = ask "What would you like to call this application? (#{default_value}):"
  title = default_value if title.blank?
  title
end

def prompt_for_subtitle
  default_value = "Created by Tapioca Collective"
  subtitle = ask "And the subtitle? (#{default_value}):"
  subtitle = default_value if subtitle.blank?
  subtitle
end

def ask message
  puts message
  STDIN.gets.chomp
end
