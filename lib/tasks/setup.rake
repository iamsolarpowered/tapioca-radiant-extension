namespace :tapioca do

  desc "Takes care of default settings, bootstraps database, and installs default extensions"
  task :setup => [:environment, "db:bootstrap", :install_plugins, :install_extensions, "db:migrate:extensions", "radiant:extensions:update_all"] do
    Radiant::Config['admin.title'] = prompt_for_title
    Radiant::Config['admin.subtitle'] = prompt_for_subtitle
    Radiant::Config['defaults.page.parts'] = "body,sidebar"
    Radiant::Config['defaults.page.status'] = "published"
    Radiant::Config['defaults.page.filter'] = "FCKEditor"
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
    :sns                => "git://github.com/SwankInnovations/radiant-sns-extension.git",
    :tinymce_filter     => "git://github.com/miv/radiant_tinymce_filter.git",
    :search             => "git://github.com/radiant/radiant-search-extension.git",
    :drag_order         => "git://github.com/bright4/radiant-drag-order.git"
  }
end

def default_plugins
  {
    :paperclip => "git://github.com/thoughtbot/paperclip.git"
  }
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
